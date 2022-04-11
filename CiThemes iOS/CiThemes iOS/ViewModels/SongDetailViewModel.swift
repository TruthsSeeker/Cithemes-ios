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
    
    convenience init(details: SongInfo, cityId: Int) {
        self.init()
        self.details = details
        self.cityID = cityId
    }
    
    private var voteSubscription: AnyCancellable?
    
    
    private func votePublisher() -> AnyPublisher<Void, Never> {
        guard let url = getUrl(for: "/api/songs/vote") else { return Just(()).eraseToAnyPublisher() }
        var request = URLRequest(url: url)
        let encoded = try? JSONEncoder().encode(VoteRequest(city_id: cityID ?? 1, song_id: Int.init(details?.id ?? "", format: .number, lenient: true), user_id: 1))
        request.httpBody = encoded
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        return URLSession.shared.dataTaskPublisher(for: request)
            .map{ data, response in
                print(response)
                return ()
            }
            .replaceError(with: ())
            .eraseToAnyPublisher()
    }
    
    func vote() {
        loading = true
        voteSubscription = votePublisher()
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { _ in
                self.loading = false
            })
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

fileprivate struct VoteRequest: Encodable {
    var city_id: Int
    var song_id: Int
    var user_id: Int
}
