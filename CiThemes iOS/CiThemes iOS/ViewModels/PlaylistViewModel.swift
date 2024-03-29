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
    
    @Published var city: City?
    @Published var detailedItem: PlaylistEntry?
    var songsDict: [PlaylistEntry] {
        didSet {
            songsDict.sort { lhs, rhs in
                lhs.votes > rhs.votes
            }
            objectWillChange.send()
        }
    }
    
    private var playlistSubscription: AnyCancellable?
    
    private unowned let coordinator: PlaylistCoordinator
    
    init(list: [PlaylistEntry] = [], city: City? = nil, coordinator: PlaylistCoordinator) {
        self.songsDict = list
        self.city = city
        self.coordinator = coordinator
    }
    
    func setDetails(_ entry: PlaylistEntry?) {
        if let entry = entry {
            coordinator.setDetail(for: entry)
        } else {
            coordinator.dismissDetails()
        }
    }
    
    func showSearch() {
        guard let city = city else {
            return
        }
        coordinator.search(for: city)
    }
        
    func fetch(onComplete complete: @escaping () -> Void = {}) {
        guard var url = URL.getUrl(for: "/cities/\(city?.id ?? 0)/playlist") else {
            return
        }
        
        if let userId = KeychainHelper.standard.read(service: .userId, type: String.self) {
            var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
            components?.queryItems = [
                URLQueryItem(name: "user_id", value: userId)
            ]
            if let queryUrl = components?.url { url = queryUrl }
        }
        
        let request = URLRequest(url: url)
        playlistSubscription = NetworkManager.shared.requestPublisher(for: request, decoding: RootResponse<[PlaylistEntry]>.self)
            .map(\.result)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                complete()
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    #if DEBUG
                    print(error)
                    #endif
                    break
                }
            }, receiveValue: { [self] entries in
                songsDict = entries
            })
    }

    
    
    func update(id: Int, vote: VoteType) {
        guard let index = songsDict.firstIndex(where: { entry in
            entry.id == id
        }) else { return }
        
        songsDict[index] = PlaylistEntry(id: songsDict[index].id, songInfo: songsDict[index].songInfo, votes: songsDict[index].votes + vote.rawValue, cityId: songsDict[index].cityId)
    }
    
    static var placeholder = PlaylistViewModel(list: Array(repeating: 0, count: 50).map({ _ in
        return PlaylistEntry(id: UUID().hashValue, songInfo: SongInfo(id: UUID().uuidString, title: String(Int.random(in: 1...100000)), artist: String(Int.random(in: 1...100000))), votes: Int.random(in: 0...1000), cityId: -1)
    }), city: City(country: "France", iso2: "FR", name: "Strasbour", population: 123456), coordinator: PlaylistCoordinator(parent: RootCoordinator(), city: City(country: "France", iso2: "FR", name: "Strasbour", population: 123456)))
}
