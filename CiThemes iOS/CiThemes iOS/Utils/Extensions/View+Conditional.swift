//
//  View+Conditional.swift
//  CiThemes
//
//  Created by Loïc Heinrich on 23/08/2022.
//

import SwiftUI

extension View {
    func conditional<AlternateView: View>(_ condition: Bool, @ViewBuilder alternate: @escaping () -> AlternateView) -> some View {
        modifier(ConditionalModifier(isEmpty: condition, alternate: alternate))
    }
    
    func conditional(_ condition: Bool) -> some View {
        modifier(ConditionalModifier(isEmpty: condition) {
            EmptyView()
        })
    }
}
