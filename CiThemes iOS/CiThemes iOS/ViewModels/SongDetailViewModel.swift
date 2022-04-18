//
//  SongDetailViewModel.swift
//  CiThemes iOS
//
//  Created by Loïc Heinrich on 04/01/2022.
//

import Foundation
import Combine

final class SongDetailViewModel: ObservableObject {
    @Published var details: SongInfo?
    @Published var loading: Bool = false
    @Published var cityID: Int?
    
    private var voteSubscription: AnyCancellable?
    private var fetchSubscription: AnyCancellable?
    
    convenience init(details: SongInfo, cityId: Int) {
        self.init()
        self.details = details
        self.cityID = cityId
    }
    
    func fetch() {
        loading = true
        #if DEBUG
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) { [weak self] in
            self?.loading = false
            self?.details = SongInfo(id: self?.details?.id ?? "", title: self?.details?.title, artist: self?.details?.artist, album: "Blood Sugar Sex Magik", release: "1991", duration: 283000, preview: nil, originalSuggestion: nil, spotifyUri: nil, cover: nil)
        }
        #else
        #endif
    }
    
}

extension SongDetailViewModel {
    //TODO
//    private func fetchPublisher() -> AnyPublisher<SongInfo, URLError> {
//        guard let url = getUrl(for: "/songs")
//    }
}

//MARK: Vote Request
extension SongDetailViewModel {
    private func votePublisher() -> AnyPublisher<Void, URLError> {
        guard let url = getUrl(for: "/songs/vote") else {
            return Result.failure(URLError(.badURL)).publisher.eraseToAnyPublisher()
        }
        guard let user = KeychainHelper.standard.read(service: KeychainHelper.service, account: KeychainHelper.account, type: User.self), let tokens = user.tokens else {
            return Result.failure(URLError(.badURL)).publisher.eraseToAnyPublisher()
        }
        var request = URLRequest(url: url)
        let encoded = try? JSONEncoder().encode(VoteRequest(city_id: cityID ?? 1, song_id: Int(details?.id ?? "", format: .number, lenient: true), user_id: user.id))
        request.httpBody = encoded
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(tokens.accessToken)", forHTTPHeaderField: "Authorization")
        return URLSession.shared.dataTaskPublisher(for: request)
            .map{ data, response in
                print(response)
                return ()
            }
            .eraseToAnyPublisher()
    }
    func vote() {
        loading = true
        voteSubscription = votePublisher()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { error in
                print(error)
            }, receiveValue: { _ in
                print("Success")
            })
    }
}

fileprivate struct VoteRequest: Encodable {
    var city_id: Int
    var song_id: Int
    var user_id: Int
}
