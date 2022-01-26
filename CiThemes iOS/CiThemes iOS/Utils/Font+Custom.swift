//
//  Font+Custom.swift
//  CiThemes iOS
//
//  Created by Loïc Heinrich on 26/01/2022.
//

import SwiftUI

extension Font {
    
    enum CustomFonts: String, CaseIterable {
        case openSans = "OpenSans-Regular"
        case ralewayRegular = "Raleway-VariableFont_wght"
        case ralewayDots = "RalewayDots-Regular"
    }
    
    static func customFont(_ type: CustomFonts, size: CGFloat) -> Font {
        return Font.custom(type.rawValue, size: size)
    }
}
