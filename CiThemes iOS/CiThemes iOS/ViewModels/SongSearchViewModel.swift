//
//  SongSearchViewModel.swift
//  CiThemes iOS
//
//  Created by Loïc Heinrich on 20/01/2022.
//

import Foundation
import Combine

final class SongSearchViewModel: ObservableObject, Identifiable {
    @Published var searchTerms: String = ""
    @Published var results: [SongInfo] = []
    @Published var loading: Bool = false
    @Published var city: City
    
    lazy var decoder:JSONDecoder = {
        var dcdr = JSONDecoder()
        dcdr.keyDecodingStrategy = .convertFromSnakeCase
        return dcdr
    }()
    
    private var searchResultsSubscription: AnyCancellable?
    private unowned let coordinator: SongDetailsCoordinator
    
    init(city: City, coordinator: SongDetailsCoordinator) {
        self.coordinator = coordinator
        self.city = city
    }
    
    func setDetails(for entry: PlaylistEntry) {
        coordinator.setDetail(for: entry)
    }

    func search() {
        loading = true
        guard let url = URL.getUrl(for: "/songs/search") else { return }
        
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
                    #if DEBUG
                    print(error)
                    #endif
                    break
                }
            }, receiveValue: { [self] infos in
                self.results = infos
                self.loading = false
            })
    }
    
}
