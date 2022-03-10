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
    
    func searchPublisher() -> AnyPublisher<[SongInfo], Never> {
        guard let url = URL(string: getUrl()) else { return Just([]).eraseToAnyPublisher() }
        var request = URLRequest(url: url)
        let encoded = try? JSONEncoder().encode(["query": self.searchTerms])
        request.httpBody = encoded
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        return URLSession.shared.dataTaskPublisher(for: request)
            .map { data, response in
                
                do {
                    let results = try JSONDecoder().decode(RootResponse<[SongInfo]>.self, from: data)
                    return results.result
                } catch {
                    print(error)
                }
                if let results = try? JSONDecoder().decode(RootResponse<[SongInfo]>.self, from: data) {
                    return results.result
                }
                return []
            }
            .replaceError(with: [])
            .eraseToAnyPublisher()
    }
    
    func search() {
        loading = true
        #if DEBUG
        print(getUrl())
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
//            self?.loading = false
//            self?.results = { count in
//                return Array(repeating: 0, count: count).map({ _ in
//                    return SongInfo(id: UUID().uuidString, title: self?.searchTerms, artist: "Red Hot Chili Peppers", album: "Blood Sugar Sex Magik", score: 450, release: "1991", duration: "4:33", preview: nil, originalSuggestion: nil, spotifyURI: nil, albumCoverURL: URL(string: "https://picsum.photos/200/300"))
//                })
//            }(50)
//
//        }
        searchResultsSubscription = searchPublisher()
            .receive(on: DispatchQueue.main)
            .sink { results in
                self.results = results
            }
        #else
        searchPublisher()
            .sink { results in
                self.results = results
            }
        #endif
    }
    
    func getUrl() -> String {
        guard let listPath = Bundle.main.url(forResource: "env", withExtension: "plist") else { return "" }
        do {
            let listData = try Data(contentsOf: listPath)
            if let dict = try PropertyListSerialization.propertyList(from: listData, options: [], format: nil) as? [String:String] {
                #if DEBUG
                return (dict["devUrl"] ?? "") + "/api/music/spotify/search"
                #else
                return (dict["liveUrl"] ?? "") + "/api/music/spotify/search"
                #endif
            }
        } catch { return "" }
        return ""
    }
}
