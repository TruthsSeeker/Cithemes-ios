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
    @Published var results: [SongInfoFull] = []
    @Published var loading: Bool = false
    
    func search() {
        loading = true
        #if DEBUG
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.loading = false
            self?.results = { count in
                return Array(repeating: 0, count: count).map({ _ in
                    return SongInfoFull(id: "1", title: self?.searchTerms, artist: "Red Hot Chili Peppers", album: "Blood Sugar Sex Magik", score: 450, release: "1991", duration: "4:33", preview: nil, originalSuggestion: nil, spotifyURI: nil, albumCoverURL: nil)
                })
            }(50)
            
        }
        #else
        #endif
    }
}
