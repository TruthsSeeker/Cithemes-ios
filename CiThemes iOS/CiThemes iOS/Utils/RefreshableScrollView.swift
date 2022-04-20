//
//  RefreshableScrollView.swift
//  CiThemes iOS
//
//  Created by Loïc Heinrich on 20/04/2022.
//

import SwiftUI

//MARK: View
struct RefreshableScrollView<Content: View>: View {
    let onRefresh: OnRefresh
    let content: Content
    
    @State private var refreshState: RefreshState = .waiting
    
    init(onRefresh: @escaping OnRefresh, @ViewBuilder content: () -> Content) {
        self.onRefresh = onRefresh
        self.content = content()
    }
    
    var body: some View {
        ScrollView {
            ZStack(alignment: .top) {
                PositionIndicator(type: .moving)
                    .frame(height: 0)
                
                content
                    .alignmentGuide(.top) { _ in
                        refreshState == .loading ? -threshold : 0
                }
                
                ProgressView()
                    .frame(height: threshold)
                    .offset(y: refreshState == .loading ? 0 : -threshold)
            }
        }
        .background(PositionIndicator(type: .fixed))
        .onPreferenceChange(PositionPreferenceKey.self) { values in
            DispatchQueue.main.async {
                let movingY = values.first { $0.type == .moving }?.y ?? 0
                let fixedY = values.first { $0.type == .fixed}?.y ?? 0
                let offset = movingY - fixedY
                
                if offset > threshold && refreshState == .waiting {
                    refreshState = .primed
                } else if offset < threshold && refreshState == .primed {
                    refreshState = .loading
                    onRefresh {
                        withAnimation {
                            refreshState = .waiting
                        }
                    }
                }
                
                
            }
        }
    }
}

//MARK: Setup
private enum PositionType {
    case fixed, moving
}

private struct Position: Equatable {
    let type: PositionType
    let y: CGFloat
}

private struct PositionPreferenceKey: PreferenceKey {
    static var defaultValue: [Position] = []
    
    static func reduce(value: inout [Position], nextValue: () -> [Position]) {
        value.append(contentsOf: nextValue())
    }
    
    typealias Value = [Position]
    
    
}

fileprivate struct PositionIndicator: View {
    let type: PositionType
    
    var body: some View {
        GeometryReader { proxy in
            Color.clear
                .preference(key: PositionPreferenceKey.self, value: [Position(type: type, y: proxy.frame(in: .global).minY)])
        }
    }
}

typealias RefreshComplete = () -> Void

typealias OnRefresh = (@escaping RefreshComplete) -> Void

private let threshold: CGFloat = 50

private enum RefreshState {
    case waiting, primed, loading
}

struct RefreshableScrollView_Previews: PreviewProvider {
    static var previews: some View {
        RefreshableScrollView { done in
            done()
        } content: {
            Text("")
        }

    }
}
