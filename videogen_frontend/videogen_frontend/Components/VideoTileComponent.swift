//
//  VideoTileComponent.swift
//  videogen_frontend
//
//  Created by JIN WOO SEONG on 2024/1/18.
//

import SwiftUI
import AVKit

struct VideoTileComponent: View {
    let videoURL: URL
    
    @State private var player: AVPlayer?

    var body: some View {
        // Small video tile view
        VideoPlayer(player: player) {
            // You can customize the video player controls here
        }
        .frame(width: 100, height: 100)
        .cornerRadius(10)
        .onAppear {
            player = AVPlayer(url: videoURL)
        }
    }
}

#Preview {
    VideoTileComponent(videoURL: URL(string: "https://res.cloudinary.com/demtzsiln/video/upload/e_preview:duration_12:max_seg_2:min_seg_dur_1/v1704760797/l2sc5xsrwrimyldyx9nt")!)
}
