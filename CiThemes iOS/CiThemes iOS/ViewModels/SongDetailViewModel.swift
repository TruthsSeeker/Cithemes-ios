//
//  SongDetailViewModel.swift
//  CiThemes iOS
//
//  Created by Loïc Heinrich on 04/01/2022.
//

import Foundation
import Combine

final class SongDetailViewModel: ObservableObject {
    @Published var details: SongInfoFull?
    @Published var loading: Bool = false
    
    func fetch() {
        loading = true
        #if DEBUG
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) { [weak self] in
            self?.loading = false
            self?.details = SongInfoFull(id: self?.details?.id, title: self?.details?.title, artist: self?.details?.artist, album: "Blood Sugar Sex Magik", score: self?.details?.score, release: "1991", duration: "4:33", preview: nil, originalSuggestion: nil, spotifyURI: nil, albumCoverURL: nil)
        }
        #else
        #endif
    }
}
