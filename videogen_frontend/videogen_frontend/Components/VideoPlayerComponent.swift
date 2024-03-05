//
//  VideoPlayerComponent.swift
//  videogen_frontend
//
//  Created by JIN WOO SEONG on 2024/3/5.
//

import SwiftUI
import AVKit

struct VideoPlayerComponent: UIViewControllerRepresentable {
    let player: AVPlayer?

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.player = player
        return controller
    }

    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        // Leave this empty
    }
}
