//
//  CacheManager.swift
//  CiThemes
//
//  Created by Loïc Heinrich on 27/07/2022.
//

import Foundation

class CacheManager {
    lazy var cityDirectory: URL = {
        if let documentsURL = try? FileManager.default
            .url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true),
            let documentChildren = try? FileManager.default
            .contentsOfDirectory(
                at: documentsURL,
                includingPropertiesForKeys: [URLResourceKey.isDirectoryKey]) {
            
            let filteredChildren = documentChildren.filter({ url in
                return url.pathComponents.contains("Cities")
            })
            
            if filteredChildren.isEmpty {
                let cityDirectory = documentsURL.appendingPathComponent("Cities", isDirectory: true)
                do {
                    try FileManager.default.createDirectory(at: cityDirectory, withIntermediateDirectories: false)
                } catch {
                    //TODO: Handle error
                    fatalError("Unable to create Cities directory:\n\(error)")
                }
                return cityDirectory
            } else {
                return filteredChildren.first!
            }
        }
        return URL(fileURLWithPath: "")
    }()
    
    init() {
        
    }
}
