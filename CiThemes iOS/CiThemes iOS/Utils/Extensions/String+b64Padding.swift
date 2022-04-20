//
//  String+b64Padding.swift
//  CiThemes iOS
//
//  Created by Loïc Heinrich on 20/04/2022.
//

import Foundation

extension String {
    func paddingb64()-> String {
        return self.padding(toLength: ((self.count+3)/4)*4,
                          withPad: "=",
                          startingAt: 0)
    }
    
    func unpaddingb64() -> String {
        return self.replacingOccurrences(of: "=", with: "")
    }
}
