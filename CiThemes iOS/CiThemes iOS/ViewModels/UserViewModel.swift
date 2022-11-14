//
//  UserViewModel.swift
//  CiThemes iOS
//
//  Created by Loïc Heinrich on 12/04/2022.
//

import Foundation
import Combine

final class UserViewModel: ObservableObject {
    @Published var user: User? = nil
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var oldPassword: String = ""
    
    private let coordinator: RootCoordinator
    
    init(coordinator: RootCoordinator) {
        if let existingTokens = KeychainHelper.standard.read(service: .tokens, type: UserToken.self),
            let existingEmail = KeychainHelper.standard.read(service: .email, type: String.self) {
            let hometown = KeychainHelper.standard.read(service: .hometown, type: Hometown.self)
            self.user = User(id: existingTokens.refreshToken.userId, email: existingEmail, hometown: hometown)
        }
        // TODO: Retrieve hometown from CoreData
        self.coordinator = coordinator
        coordinator.hometown = self.user?.hometown
    }
    
    lazy var decoder:JSONDecoder = {
        var dcdr = JSONDecoder()
        dcdr.keyDecodingStrategy = .convertFromSnakeCase
        return dcdr
    }()
    
    private var subscriptions: [AnyCancellable] = []
    
    //MARK: Signup request
    func signup() {
        guard let url = URL.getUrl(for: "/auth/signup") else { return }
        guard !email.isEmpty && !password.isEmpty else { return }
        
        var request = URLRequest(url: url)
        let encoded = try? JSONEncoder().encode(UserRequest(email: email, password: password))
        request.httpBody = encoded
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let publisher = NetworkManager.shared.requestPublisher(for: request, decoding: RootResponse<UserToken>.self)
            .map(\.result)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { error in
            }, receiveValue: { [self] tokens in
                saveUserData(from: tokens)
                self.user = User(id: tokens.refreshToken.userId, email: email)
                coordinator.toggleLogin()
                self.email = ""
                self.password = ""
            })
        subscriptions.append(publisher)
    }

    //MARK: Login request
    func login() {
        guard let url = URL.getUrl(for: "/auth/login") else {
            return
        }
        guard !email.isEmpty && !password.isEmpty else {
            return
        }
        let encoded = try? JSONEncoder().encode(UserRequest(email: email, password: password))
        
        var request = URLRequest(url: url)
        request.httpBody = encoded
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let publisher = NetworkManager.shared.requestPublisher(for: request, decoding: RootResponse<UserToken>.self)
            .map(\.result)
            .receive(on: RunLoop.main)
            
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.coordinator.errorConfig = .init(message: error.localizedDescription, type: .error(.error))
                    self.coordinator.showError = true
                    #if DEBUG
                    print(error)
                    #endif
                    break
                }
            }, receiveValue: { [self] tokens in
                
                saveUserData(from: tokens)
                Task {
                    let hometown = await Hometown.fetch(id: tokens.hometownId)
                    await MainActor.run {
                        self.user = User(id: tokens.refreshToken.userId, email: email, hometown: hometown)
                        coordinator.toggleLogin()
                        coordinator.hometown = hometown
                        self.email = ""
                        self.password = ""
                    }
                }
            })
        subscriptions.append(publisher)
    }
    
    func logout() {
        guard let url = URL.getUrl(for: "/auth/logout") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        guard let tokens = KeychainHelper.standard.read(service: .tokens, type: UserToken.self),
              let encoded = try? JSONEncoder().encode(LogoutRequest(token: tokens.refreshToken)) else { return }
        request.httpBody = encoded
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let publisher = NetworkManager.shared.authenticatedRequestPublisher(for: request, decoding: RootResponse<Bool>.self)
            .map(\.result)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.coordinator.errorConfig = .init(message: error.localizedDescription, type: .error(.error))
                    self.coordinator.showError = true
                    KeychainHelper.standard.logout()
                    self.user = nil
                    self.coordinator.hometown = nil
                    #if DEBUG
                    print(error)
                    #endif
                    break
                }
            } receiveValue: { [weak self] success in
                if success {
                    KeychainHelper.standard.logout()
                    self?.user = nil
                    self?.coordinator.hometown = nil
                }
            }
        subscriptions.append(publisher)
    }
    
    func update() {
        guard let url = URL.getUrl(for: "/auth/update") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        guard let data = try? JSONEncoder().encode(user) else { return }
        request.httpBody = data
        
        let publisher = NetworkManager.shared.authenticatedRequestPublisher(for: request, decoding: RootResponse<String>.self)
            .receive(on: DispatchQueue.main)
            .map(\.result)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.coordinator.errorConfig = .init(message: error.localizedDescription, type: .error(.error))
                    self.coordinator.showError = true
                    #if DEBUG
                    print(error)
                    #endif
                    break
                }
            } receiveValue: { message in
                print(message)
            }
        subscriptions.append(publisher)
    }
    
    func setHometown(id: Int) {
        guard let url = URL.getUrl(for: "/auth/hometown") else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        let params:[String: Int] = ["city_id":id]
        guard let data = try? JSONEncoder().encode(params) else {
            return
        }
        request.httpBody = data
    
        let publisher = NetworkManager.shared.authenticatedRequestPublisher(for: request, decoding: RootResponse<Hometown>.self)
            .receive(on: DispatchQueue.main)
            .map(\.result)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    #if DEBUG
                    print(error)
                    #endif
                    if let apiError = error as? APIError {
                        switch apiError {
                        case .httpError(let int):
                            self?.coordinator.errorConfig = .init(message: error.localizedDescription, type: .error(.error))
                            self?.coordinator.showError = true
                            #if DEBUG
                            print(int)
                            #endif
                        case .invalidURL, .other:
                            #if DEBUG
                            print(error)
                            #endif
                        case .invalidAuth, .loginRequired:
                            self?.coordinator.toggleLogin()
                        
                        }
                    }
                    break
                }
            } receiveValue: { hometown in
                KeychainHelper.standard.save(hometown, service: .hometown)
                self.user?.hometown = hometown
                self.coordinator.hometown = hometown
            }
        subscriptions.append(publisher)
    }
    
    func updatePassword(_ oldPassword: String, newPassword: String, onComplete: @escaping () -> Void) {
        guard let url = URL.getUrl(for: "/auth/update"),
              let id = user?.id
        else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        guard let data = try? JSONEncoder().encode(["id": String(id), "password": oldPassword, "new_password": newPassword]) else { return }
        request.httpBody = data
        
        let publisher = NetworkManager.shared.authenticatedRequestPublisher(for: request, decoding: RootResponse<String>.self)
            .receive(on: DispatchQueue.main)
            .map(\.result)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.coordinator.errorConfig = .init(message: error.localizedDescription, type: .error(.error))
                    self.coordinator.showError = true
                    #if DEBUG
                    print(error)
                    #endif
                    break
                }
            } receiveValue: { message in
                print(message)
                onComplete()
            }
        subscriptions.append(publisher)
    }
    
    private func saveUserData(from tokens: UserToken) {
        KeychainHelper.standard.save(email, service: .email, account: KeychainHelper.account)
        
        let userId = String(tokens.refreshToken.userId)
        KeychainHelper.standard.save(userId, service: .userId)
        KeychainHelper.standard.save(tokens, service: .tokens)
        Task {
            let hometown = await Hometown.fetch(id: tokens.hometownId)
            KeychainHelper.standard.save(hometown, service: .hometown)
        }
    }
}

fileprivate struct UserRequest: Encodable {
    var email: String
    var password: String
}

fileprivate struct LogoutRequest: Encodable {
    var token: RefreshToken
}
