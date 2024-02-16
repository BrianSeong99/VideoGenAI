//
//  VideoTileComponent.swift
//  videogen_frontend
//
//  Created by JIN WOO SEONG on 2024/1/18.
//

import SwiftUI
import AVKit

struct VideoTileComponent: View {
    
    @State private var scaleFactor: CGFloat
    @State private var player: AVPlayer?
    @State private var isMagnified: Bool
    @Binding var videoURL: URL
    @Binding var isSelected: Bool

    
    public init(videoURL: Binding<URL>, isSelected: Binding<Bool>) {
        self._videoURL = videoURL
        self._scaleFactor = State(initialValue: 1.0)
        self._isMagnified = State(initialValue: false)
        self._isSelected = isSelected
    }

    var body: some View {
        ZStack(alignment: .topTrailing) {
            // Small video tile view
            VideoPlayer(player: player) {}
                .scaledToFit()
                .frame(width: 80 * scaleFactor, height: 80 * scaleFactor)
                .cornerRadius(10 * scaleFactor)
//                .border(Color.gray, width: 0.5)
                .onAppear {
                    player = AVPlayer(url: videoURL)
                }
                .onChange(of: videoURL) { _, newURL in
                    player = AVPlayer(url: newURL)
                }
                .contextMenu {
                    Button(action: {
                        print("Share Video")
                    }) {
                        Text("Share")
                        Image(systemName: "square.and.arrow.up")
                    }
                    
                    Button(action: {
                        print("Save Video")
                    }) {
                        Text("Save")
                        Image(systemName: "square.and.arrow.down")
                    }
                } preview: {
                    VideoPreviewComponent(videoURL: videoURL)
                        .animation(Animation.snappy(duration: 0.1), value: 0)
                        .zIndex(2)
                }
                .zIndex(isMagnified ? 1 : 0)
            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.blue)
                    .padding(4) 
            }
        }
    }
}

//#Preview {
//    VideoTileComponent(videoURL: URL(string: "https://res.cloudinary.com/demtzsiln/video/upload/e_preview:duration_12:max_seg_2:min_seg_dur_1/v1704760797/l2sc5xsrwrimyldyx9nt")!)
//}
