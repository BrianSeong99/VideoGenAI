//
//  VideoPlayerModel.swift
//  videogen_frontend
//
//  Created by JIN WOO SEONG on 2024/3/5.
//

import SwiftUI
import AVKit
import AVFoundation

class VideoPlayerModel: ObservableObject {
    private var queuePlayer: AVQueuePlayer?
    private var playerItems: [AVPlayerItem] = []

    // Create AVPlayerItems from URLs and queue them for playback
    func setupQueue(with videos: [URL]) {
        playerItems = videos.map { AVPlayerItem(url: $0) }
        queuePlayer = AVQueuePlayer(items: playerItems)
    }

    // Start playing the videos
    func play() {
        queuePlayer?.play()
    }

    // Access the AVPlayer to use in AVPlayerViewController
    func getPlayer() -> AVPlayer? {
        return queuePlayer
    }
}
