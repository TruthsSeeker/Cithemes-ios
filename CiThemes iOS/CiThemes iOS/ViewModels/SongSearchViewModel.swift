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
    lazy var decoder:JSONDecoder = {
        var dcdr = JSONDecoder()
        dcdr.keyDecodingStrategy = .convertFromSnakeCase
        return dcdr
    }()
    private var searchResultsSubscription: AnyCancellable?
    
    private func searchPublisher() -> AnyPublisher<[SongInfo], Error> {
        guard let url = getUrl(for: "/songs/search") else { return
            Fail(error:APIError.invalidURL)
            .eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        let encoded = try? JSONEncoder().encode(["query": self.searchTerms])
        request.httpBody = encoded
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let response = response as? HTTPURLResponse else { throw APIError.other }
                guard response.statusCode == 200 else {
                    throw APIError.httpError(response.statusCode)
                }
                
                return data
            }
            .decode(type: RootResponse<[SongInfo]>.self, decoder: decoder)
            .map {$0.result}
            .eraseToAnyPublisher()
    }
    
    func search() {
        loading = true
        searchResultsSubscription = searchPublisher()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    break
                }
            }, receiveValue: { [self] infos in
                self.results = results
                self.loading = false
            })
    }
    
}
