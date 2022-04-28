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

    func search() {
        loading = true
        //TODO: Alert Error
        guard let url = getUrl(for: "/songs/search") else { return }
        
        var request = URLRequest(url: url)
        let encoded = try? JSONEncoder().encode(["query": self.searchTerms])
        request.httpBody = encoded
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        searchResultsSubscription = NetworkManager.shared.requestPublisher(for: request, decoding: RootResponse<[SongInfo]>.self)
            .map(\.result)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    break
                }
            }, receiveValue: { [self] infos in
                self.results = infos
                self.loading = false
            })
    }
    
}
