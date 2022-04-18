//
//  FlippableView.swift
//  CiThemes iOS
//
//  Created by Loïc Heinrich on 13/04/2022.
//

import SwiftUI

struct FlippableView<Front: View, Back: View>: View {
    @State var backDegree = 90.0
    @State var frontDegree = 0.0
    @Binding var isFaceUp: Bool
    
    var duration : CGFloat
    
    let frontView: Front
    let backView: Back
    
    init(duration: CGFloat = 0.6, isFaceUp: Binding<Bool>, @ViewBuilder frontView: () -> Front, @ViewBuilder backView: () -> Back) {
        self._isFaceUp = isFaceUp
        self.duration = duration
        self.frontView = frontView()
        self.backView = backView()
    }
    
    func flip () {
        if isFaceUp {
            withAnimation(.linear(duration: duration/2)) {
                backDegree = 90
            }
            withAnimation(.linear(duration: duration/2).delay(duration/2)){
                frontDegree = 0
            }
        } else {
            withAnimation(.linear(duration: duration/2)) {
                frontDegree = -90
            }
            withAnimation(.linear(duration: duration/2).delay(duration/2)){
                backDegree = 0
            }
        }
    }
    //MARK: View Body
    var body: some View {
        ZStack {
            frontView
                .rotation3DEffect(Angle(degrees: frontDegree), axis: (x: 0, y: 1, z: 0))
                .disabled(!isFaceUp)
                .allowsHitTesting(isFaceUp)
            backView
                .rotation3DEffect(Angle(degrees: backDegree), axis: (x: 0, y: 1, z: 0))
                .disabled(isFaceUp)
                .allowsHitTesting(!isFaceUp)
        }.onChange(of: isFaceUp) { newValue in
            flip()
        }
    }
}

struct FlippableView_Previews: PreviewProvider {
    static var previews: some View {
        FlippableView(isFaceUp: .constant(true)) {
            Text("Front")
        } backView: {
            Text("Back")
        }

    }
}
