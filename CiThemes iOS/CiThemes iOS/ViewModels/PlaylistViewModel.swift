//
//  SongInfoViewModel.swift
//  CiThemes iOS
//
//  Created by Loïc Heinrich on 01/01/2022.
//

import Foundation
import Combine

final class PlaylistViewModel: ObservableObject {
    enum VoteType: Int {
        case Up = 1
        case Down = -1
    }
    lazy var decoder:JSONDecoder = {
        var dcdr = JSONDecoder()
        dcdr.keyDecodingStrategy = .convertFromSnakeCase
        return dcdr
    }()
    
    @Published var cityId: Int
    var songsDict: [PlaylistEntry] {
        didSet {
            songsDict.sort { lhs, rhs in
                lhs.votes > rhs.votes
            }
            objectWillChange.send()
        }
    }
    
    init(list: [PlaylistEntry], cityId: Int) {
        self.songsDict = list
        self.cityId = cityId
    }
    
    private var playlistSubscription: AnyCancellable?
    
    private func playlistPublisher() -> AnyPublisher<[PlaylistEntry], Error> {
        guard let url = getUrl(for: "/cities/\(cityId)/playlist") else {
            return Fail(error: APIError.invalidURL)
                .eraseToAnyPublisher()
        }
            
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response in
                guard let response = response as? HTTPURLResponse else {
                    throw APIError.other
                }
                guard response.statusCode == 200 else {
                    throw APIError.httpError(response.statusCode)
                }
                
                return data
            }
            .decode(type: RootResponse<[PlaylistEntry]>.self, decoder: decoder)
            .map { decoded in
                return decoded.result
            }
            .eraseToAnyPublisher()
    }
    
    func fetch(onComplete complete: @escaping () -> Void = {}) {
        guard let url = getUrl(for: "/cities/\(cityId)/playlist") else {
            return
        }
        let request = URLRequest(url: url)
        playlistSubscription = NetworkManager.shared.requestPublisher(for: request, decoding: [PlaylistEntry].self)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                complete()
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }, receiveValue: { [self] entries in
                songsDict = entries
            })
    }
    
//    func fetch(onComplete complete: @escaping () -> Void = {}) {
//        playlistSubscription = playlistPublisher()
//            .receive(on: DispatchQueue.main)
//            .sink(receiveCompletion: { completion in
//                complete()
//                switch completion {
//                case .finished:
//                    break
//                case .failure(let error):
//                    print(error.localizedDescription)
//                }
//            }, receiveValue: { [self] entries in
//                print("Fetched VM")
//                songsDict = entries
//            })
//    }
    
    
    func update(id: Int, vote: VoteType) {
        guard let index = songsDict.firstIndex(where: { entry in
            entry.id == id
        }) else { return }
        
        songsDict[index] = PlaylistEntry(id: songsDict[index].id, songInfo: songsDict[index].songInfo, votes: songsDict[index].votes + vote.rawValue, cityId: songsDict[index].cityId)
    }
    
    static var placeholder = PlaylistViewModel(list: Array(repeating: 0, count: 50).map({ _ in
        return PlaylistEntry(id: UUID().hashValue, songInfo: SongInfo(id: UUID().uuidString, title: String(Int.random(in: 1...100000)), artist: String(Int.random(in: 1...100000))), votes: Int.random(in: 0...1000), cityId: -1)
    }), cityId: 1)
}
