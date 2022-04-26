//
//  SongDetailViewModel.swift
//  CiThemes iOS
//
//  Created by Loïc Heinrich on 04/01/2022.
//

import Foundation
import Combine

final class SongDetailViewModel: ObservableObject {
    @Published var details: SongInfo = SongInfo.example
    @Published var loading: Bool = false
    @Published var cityID: Int = -1
    @Published var voted: Bool = false
    
    private var voteSubscription: AnyCancellable?
    private var fetchSubscription: AnyCancellable?
    
//    func fetch() {
//        loading = true
//        #if DEBUG
//        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) { [weak self] in
//            self?.loading = false
//            self?.details = SongInfo(id: self?.details.id ?? "", title: self?.details.title, artist: self?.details.artist, album: "Blood Sugar Sex Magik", release: "1991", duration: 283000, preview: nil, originalSuggestion: nil, spotifyUri: nil, cover: nil)
//        }
//        #else
//        #endif
//    }
//    
}

extension SongDetailViewModel {
    //TODO
//    private func fetchPublisher() -> AnyPublisher<SongInfo, URLError> {
//        guard let url = getUrl(for: "/songs")
//    }
}

//MARK: Vote Request
extension SongDetailViewModel {
//    private func votePublisher() -> AnyPublisher<Void, Error> {
//        guard let url = getUrl(for: "/songs/vote") else {
//            return Fail(error:APIError.invalidURL)
//                .eraseToAnyPublisher()
//        }
//        
//        guard let tokens = KeychainHelper.standard.read(service: .tokens, type: UserToken.self),
//              let id = KeychainHelper.standard.read(service: .userId, type: Int.self)
//        else {
//            return Fail(error:APIError.invalidAuth)
//                .eraseToAnyPublisher()
//        }
//        
//        var request = URLRequest(url: url)
//        let encoded = try? JSONEncoder().encode(VoteRequest(city_id: cityID ?? 1, song_id: Int(details.id ?? "", format: .number, lenient: true), user_id: id))
//        
//        request.httpBody = encoded
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.setValue("application/json", forHTTPHeaderField: "Accept")
//        request.setValue("Bearer \(tokens.accessToken)", forHTTPHeaderField: "Authorization")
//        
//        return URLSession.shared.dataTaskPublisher(for: request)
//            .tryMap({ data, response in
//                guard let response = response as? HTTPURLResponse else {
//                    throw APIError.other
//                }
//                guard response.statusCode == 200 else {
//                    throw APIError.httpError(response.statusCode)
//                }
//                
//                return
//            })
//            .eraseToAnyPublisher()
//    }
    
    
    func vote(onAuthFail authClosure: @escaping ()->Void = {}, onSuccess successClosure: @escaping () -> Void = {}) {
        loading = true
        guard let url = getUrl(for: "/songs/vote") else {
            return
        }
        
        guard let id = KeychainHelper.standard.read(service: .userId, type: Int.self),
            let encoded = try? JSONEncoder().encode(VoteRequest(city_id: cityID, song_id: Int(details.id ?? "", format: .number, lenient: true), user_id: id, remove: voted)) else {
            authClosure()
            return
        }
        
        var request = URLRequest(url: url)
        request.httpBody = encoded
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        voteSubscription = NetworkManager.shared.authenticatedRequestPublisher(for: request, decoding: RootResponse<Int>.self)
            .receive(on: DispatchQueue.main)
            .map(\.result)
            .sink(receiveCompletion: { [self] completion in
                loading = false
                switch completion {
                case .finished:
                    successClosure()
                    break
                case .failure(let error):
                    if let apiError = error as? APIError {
                        switch apiError {
                        case .invalidAuth, .loginRequired:
                            authClosure()
                        default:
                            break
                        }
                    }
                }
            }, receiveValue: { [self] id in
                voted = id != -1
            })
        
//        voteSubscription = votePublisher()
//            .receive(on: DispatchQueue.main)
//            .sink(receiveCompletion: { error in
//                print(error)
//            }, receiveValue: { _ in
//                print("Success")
//            })
    }
}

fileprivate struct VoteRequest: Encodable {
    var city_id: Int
    var song_id: Int
    var user_id: Int
    var remove: Bool
}
