//
//  PreviewPlayerViewModel.swift
//  CiThemes
//
//  Created by Loïc Heinrich on 13/06/2022.
//

import Foundation
import Combine
import AVFoundation

final class PreviewPlayerViewModel: ObservableObject {
    private let player: AVPlayer
    private var subscriptions: [AnyCancellable] = []
    private var observer: Any?
    
    @Published var playbackProgress: Double = 0.0
    @Published var isReady: Bool = false
    @Published var duration: Double?
    @Published var playing: Bool = false
    
    init(url: URL) {
        player = AVPlayer(url: url)
        let readyPublisher = player.publisher(for: \.currentItem)
            .sink { item in
                self.isReady = item != nil
            }
        subscriptions.append(readyPublisher)
        
        let durationPublisher = player.publisher(for: \.currentItem?.duration)
            .sink { time in
                self.duration = time?.seconds
        }
        subscriptions.append(durationPublisher)
        
        observer = player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.1, preferredTimescale: 100), queue: nil) { [weak self] time in
            self?.playbackProgress = time.seconds
        }
        
    }
    
    deinit {
        if let observer = observer {
            player.removeTimeObserver(observer)
        }
    }
    
    private func play() {
        guard isReady else { return }
        playing = true
        player.play()
    }
    
    private func pause() {
        guard isReady else { return }
        playing = false
        player.pause()
    }
    
    public func startSeeking() {
        player.pause()
        
    }
    
    public func togglePlayback() {
        playing ? pause() : play()
    }
    
    public func seek() {
        player.seek(to: CMTime(seconds: playbackProgress, preferredTimescale: 100))
        if playing {
            player.play()
        }

    }
    
    public func getPlaybackRange() -> ClosedRange<Double> {
        let duration = self.duration ?? Double.greatestFiniteMagnitude
        if duration > 0 {
            return 0.0...duration
        } else {
            return 0.0...1.0
        }
    }
}
