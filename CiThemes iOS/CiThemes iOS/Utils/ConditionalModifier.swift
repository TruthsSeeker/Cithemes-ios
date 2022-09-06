//
//  ConditionalModifier.swift
//  CiThemes
//
//  Created by Loïc Heinrich on 23/08/2022.
//

import Foundation
import SwiftUI

struct ConditionalModifier<AlternateView: View>: ViewModifier {
    let isEmpty: Bool
    var alternate: () -> AlternateView
    
    func body(content: Content) -> some View {
        Group {
            if isEmpty {
                alternate()
            } else {
                content
            }
        }
    }
}
