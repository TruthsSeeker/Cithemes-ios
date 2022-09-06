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
    private let player: AVPlayer = AVPlayer.shared
    private var subscriptions: Set<AnyCancellable?> = []
    private var observer: Any?
    
    @Published var playbackProgress: Double = 0.0
    @Published var isReady: Bool = false
    @Published var duration: Double?
    @Published var playing: Bool = false
    
    init(url: URL) {
        player.replaceCurrentItem(with: AVPlayerItem(url: url))
        let readyPublisher = player.publisher(for: \.currentItem)
            .sink { [weak self] item in
                self?.isReady = item != nil
            }
        subscriptions.insert(readyPublisher)
        
        let durationPublisher = player.publisher(for: \.currentItem?.duration)
            .sink { [weak self] time in
                self?.duration = time?.seconds
        }
        subscriptions.insert(durationPublisher)
        
        observer = player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.1, preferredTimescale: 100), queue: nil) { [weak self] time in
            self?.playbackProgress = time.seconds
        }
        print("init PreviewPlayerVM")
    }
    
    deinit {
        if let observer = observer {
            player.removeTimeObserver(observer)
        }
        print("deinit PreviewPlayerVM")
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
    
    public func stop() {
        player.pause()
        playing = false
//        player.replaceCurrentItem(with: nil)
//        if let observer = observer {
//            player.removeTimeObserver(observer)
//        }
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
