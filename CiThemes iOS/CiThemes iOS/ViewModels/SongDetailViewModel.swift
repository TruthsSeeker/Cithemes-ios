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
    @Published var votes: Int
    
    private var voteSubscription: AnyCancellable?
    private var fetchSubscription: AnyCancellable?
    private unowned let coordinator: SongDetailsCoordinator
    
    init(entry: PlaylistEntry, coordinator: SongDetailsCoordinator) {
        self.coordinator = coordinator
        self.details = entry.songInfo
        self.cityID = entry.cityId
        self.votes = entry.votes
        self.voted = entry.voted
    }
    
    func dismiss() {
        coordinator.dismissDetails()
    }
    
    //MARK: Vote Request
    func vote(onAuthFail authClosure: @escaping ()->Void = {}, onSuccess successClosure: @escaping () -> Void = {}) {
        loading = true
        guard let url = URL.getUrl(for: "/songs/vote") else {
            return
        }
        
        guard let id = KeychainHelper.standard.read(service: .userId, type: String.self),
              let encoded = try? JSONEncoder().encode(VoteRequest(city_id: cityID, song_id: Int(details.id ?? "", format: .number, lenient: true), user_id: Int(id) ?? 0, remove: voted)) else {
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
                            coordinator.toggleLogin()
                        case .httpError(let code):
                            if code == 403 {
                                coordinator.displayError(message: "You can only change hometowns once a month")
                            }
                        default:
                            break
                        }
                    }
                }
            }, receiveValue: { [self] id in
                voted = id != -1
            })
    }
}

fileprivate struct VoteRequest: Encodable {
    var city_id: Int
    var song_id: Int
    var user_id: Int
    var remove: Bool
}
