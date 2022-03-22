//
//  SongSearchViewModel.swift
//  CiThemes iOS
//
//  Created by Loïc Heinrich on 20/01/2022.
//

import Foundation
import Combine

final class SongSearchViewModel: ObservableObject {
    @Published var searchTerms: String = ""
    @Published var results: [SongInfo] = []
    @Published var loading: Bool = false

    private var searchResultsSubscription: AnyCancellable?
    
    private func searchPublisher() -> AnyPublisher<[SongInfo], Never> {
        guard let url = getUrl(for: "/api/songs/search") else { return Just([]).eraseToAnyPublisher() }
        var request = URLRequest(url: url)
        let encoded = try? JSONEncoder().encode(["query": self.searchTerms])
        request.httpBody = encoded
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        return URLSession.shared.dataTaskPublisher(for: request)
            .map { data, response in
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                guard let results = try? decoder.decode(RootResponse<[SongInfo]>.self, from: data) else { return [] }
                return results.result
            }
            .replaceError(with: [])
            .eraseToAnyPublisher()
    }
    
    func search() {
        loading = true
        searchResultsSubscription = searchPublisher()
            .receive(on: DispatchQueue.main)
            .sink { results in
                self.results = results
                self.loading = false
            }
    }
    
}
