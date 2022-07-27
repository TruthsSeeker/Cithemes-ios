//
//  CacheManager.swift
//  CiThemes
//
//  Created by Loïc Heinrich on 27/07/2022.
//

import Foundation

class CacheManager {
    static let shared = CacheManager()
    
    private lazy var cityDirectory: URL? = {
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
                    return nil
                }
                return cityDirectory
            } else {
                return filteredChildren.first
            }
        }
        return nil
    }()
    
    private init() {}
    
    func savePicture(withNameAndExtension name: String, forData data: Data) -> String? {
        guard let directory = cityDirectory else { return nil }
        let path = directory.path.appending(name)
        if FileManager.default.createFile(atPath: path, contents: data) {
            return path
        } else {
            return nil
        }
    }
    
    func loadPictureData(fromPath path: String) -> Data? {
        guard let fileHandle = FileHandle(forReadingAtPath: path) else { return nil }
        return try? fileHandle.readToEnd()
    }
}
