//
//  ObservableObject+getUrl.swift
//  CiThemes iOS
//
//  Created by Loïc Heinrich on 22/03/2022.
//

import Foundation

extension URL {
    static func getUrl(for path: String) -> URL? {
        guard let listPath = Bundle.main.url(forResource: "env", withExtension: "plist") else { return nil }
        do {
            let listData = try Data(contentsOf: listPath)
            if let dict = try PropertyListSerialization.propertyList(from: listData, options: [], format: nil) as? [String:String] {
                var root: String = ""
                #if DEBUG
                root = dict["devUrl"] ?? ""
                #else
                root = dict["liveUrl"] ?? ""
                #endif
                return URL(string:root + path)
            }
        } catch { return nil }
        return nil
    }
}
