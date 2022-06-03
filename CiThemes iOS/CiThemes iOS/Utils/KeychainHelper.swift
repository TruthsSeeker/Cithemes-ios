//
//  KeychainHelper.swift
//  CiThemes iOS
//
//  Created by Loïc Heinrich on 13/04/2022.
//

import Foundation

final class KeychainHelper {
    
    static let standard = KeychainHelper()
    private init() {}
    
    func save(_ data: Data, service: KeychainHelper.Service, account: String = KeychainHelper.account) {

        let query = [
            kSecValueData: data,
            kSecAttrService: service.rawValue,
            kSecAttrAccount: account,
            kSecClass: kSecClassGenericPassword
        ] as CFDictionary

        // Add data in query to keychain
        let status = SecItemAdd(query, nil)

        if status == errSecDuplicateItem {
            // Item already exist, thus update it.
            let query = [
                kSecAttrService: service.rawValue,
                kSecAttrAccount: account,
                kSecClass: kSecClassGenericPassword,
            ] as CFDictionary

            let attributesToUpdate = [kSecValueData: data] as CFDictionary

            // Update existing item
            SecItemUpdate(query, attributesToUpdate)
        }
    }
    
    func read(service: KeychainHelper.Service, account: String = KeychainHelper.account) -> Data? {
        
        let query = [
            kSecAttrService: service.rawValue,
            kSecAttrAccount: account,
            kSecClass: kSecClassGenericPassword,
            kSecReturnData: true
        ] as CFDictionary
        
        var result: AnyObject?
        SecItemCopyMatching(query, &result)
        
        return (result as? Data)
    }
    
    func delete(service: KeychainHelper.Service, account: String = KeychainHelper.account) {
        
        let query = [
            kSecAttrService: service.rawValue,
            kSecAttrAccount: account,
            kSecClass: kSecClassGenericPassword,
            ] as CFDictionary
        
        // Delete item from keychain
        SecItemDelete(query)
    }
    
    func logout() {
        self.delete(service: .email)
        self.delete(service: .tokens)
        self.delete(service: .userId)
    }
}

extension KeychainHelper {
    
    func save<T>(_ item: T, service: KeychainHelper.Service, account: String = KeychainHelper.account) where T : Codable {
        
            // Encode as JSON data and save in keychain
        if let data = try? JSONEncoder().encode(item) {
            save(data, service: service, account: account)
        }
            
    }
    
    func read<T>(service: KeychainHelper.Service, account: String = KeychainHelper.account, type: T.Type) -> T? where T : Codable {
        
        // Read item data from keychain
        guard let data = read(service: service, account: account) else {
            return nil
        }
        
        // Decode JSON data to object
        if let item = try? JSONDecoder().decode(type, from: data) {
            return item
        }
        return nil
    }
    
}

extension KeychainHelper {
    static var account = "app.cithemes"
    
    enum Service: String {
        case tokens
        case email
        case userId
    }
}
