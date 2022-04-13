//
//  AnyTransition+Flip.swift
//  CiThemes iOS
//
//  Created by Loïc Heinrich on 12/04/2022.
//

import SwiftUI

extension AnyTransition {
    static var flip: AnyTransition{
        .modifier(active: Flip(degrees: 90),
                  identity: Flip(degrees: 0))
    }
    
    static var flipHide: AnyTransition{
        .modifier(active: Flip(degrees: 180),
                  identity: Flip(degrees: 0))
    }
    
    static var flipShow: AnyTransition{
        .modifier(active: Flip(degrees: -180),
                  identity: Flip(degrees: 0))
    }
}

fileprivate struct Flip: ViewModifier {
    let degrees: Double
    func body(content: Content) -> some View {
        content
            .rotation3DEffect(Angle(degrees: degrees), axis: (x: 0, y: 1, z: 0))
    }
}

