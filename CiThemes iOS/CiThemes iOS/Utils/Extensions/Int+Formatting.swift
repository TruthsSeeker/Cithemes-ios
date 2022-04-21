//
//  Int+Formatting.swift
//  CiThemes iOS
//
//  Created by Loïc Heinrich on 21/04/2022.
//

import Foundation

extension Int {
    static let thousandsFormatter: NumberFormatter = {
        let thousandsFormatter = NumberFormatter()
        thousandsFormatter.usesSignificantDigits = true
        thousandsFormatter.maximumSignificantDigits = 3
        return thousandsFormatter
    }()
    
    static let millionsFormatter: NumberFormatter = {
        let millionsFormatter = NumberFormatter()
        millionsFormatter.usesSignificantDigits = true
        millionsFormatter.maximumSignificantDigits = 3
        return millionsFormatter
    }()
    
    func formatForDisplay() -> String {
        switch self {
        case 0...999:
            return String(self)
        case 1000...999999:
            let fraction: Float = Float(self) / 1000.0
            
            let formatted = Int.thousandsFormatter.string(from: NSNumber(value: fraction)) ?? ""
            return "\(formatted)K"
        default:
            let fraction: Float = Float(self) / 1000000.0
            
            let formatted = Int.millionsFormatter.string(from: NSNumber(value: fraction)) ?? ""
            return "\(formatted)M"
        }
    }
}
