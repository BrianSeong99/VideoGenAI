//
//  PromptResultRowComponent.swift
//  videogen_frontend
//
//  Created by JIN WOO SEONG on 2024/2/19.
//

import SwiftUI
import UIKit

struct PromptResultRowComponent: View {

    @State var videoURL: URL
    @State var score: Float
    @State var tags: [String]

    
    init(videoURL: URL, score: Float, tags: [String]) {
        self._videoURL = State(initialValue: videoURL)
        self._score = State(initialValue: score)
        self._tags = State(initialValue: tags)
    }
    
    private func toThumbnailURL(url: URL) -> URL {
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        
        if let path = components?.path, path.hasSuffix(".mp4") || path.hasSuffix(".mov") {
            let newPath = path.replacingOccurrences(of: ".mp4", with: ".jpg")
                                  .replacingOccurrences(of: ".mov", with: ".jpg")
            components?.path = newPath
        }

        return components?.url ?? url
    }
    
    private func toPreviewURL(url: URL) -> URL {
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return url
        }
        
        let previewTransformation = "e_preview:duration_6:max_seg_3:min_seg_dur_1/"
        
        if let uploadRange = components.path.range(of: "/upload/") {
            let startOfVersion = components.path.index(uploadRange.upperBound, offsetBy: 0)
            components.path.insert(contentsOf: previewTransformation, at: startOfVersion)
        }
        
        return components.url ?? url
    }

    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack{
                HStack{
                    AsyncImage(url: toThumbnailURL(url: videoURL)) { phase in
                        if let image = phase.image {
                            image.resizable()
                                .aspectRatio(contentMode: .fill)
                        } else if phase.error != nil {
                            Color.gray.opacity(0.3)
                        } else {
                            HStack{
                                Spacer()
                                VStack{
                                    Spacer()
                                    ProgressView()
                                    Spacer()
                                }
                                Spacer()
                            }
                        }
                    }
                    .frame(width: 160, height: 90)
                    .clipped()
                    .contextMenu {
                        Button(action: {
                            UIPasteboard.general.url = toPreviewURL(url: videoURL)
                            print("Copy Preview URL")
                        }) {
                            Text("Copy Preview Link")
                            Image(systemName: "link")
                        }
                        
                        Button(action: {
                            UIPasteboard.general.url = videoURL
                            print("Copy Full Video URL")
                        }) {
                            Text("Copy Full Video Link")
                            Image(systemName: "link")
                        }
                    } preview: {
                        VideoPreviewComponent(videoURL: toPreviewURL(url: videoURL))
                            .animation(Animation.snappy(duration: 0.1), value: 0)
                            .zIndex(2)
                    }
                    .zIndex(1)
                    Spacer()
                    Text("Score: " + String(format: "%.2f", self.score))
                    Spacer()
                }
                .padding(.horizontal, 10)
                Divider()
                    .padding(.vertical, 1)
                    .padding(.horizontal, 5)
                HStack{
                    ScrollView(.horizontal) {
                        HStack(spacing: 10) {
                            ForEach(self.tags, id: \.self) { tag in
                                Text(tag)
                                    .padding(.vertical, 2)
                                    .padding(.horizontal, 5)
                                    .background(Color.gray)
                                    .foregroundColor(.white)
                                    .cornerRadius(5)
                            }
                        }
                    }
                }
                .padding(.horizontal, 10)            }
            .padding(.vertical, 10)
            .background(RoundedRectangle(cornerRadius: 5)
                .fill(Color.white)
                .shadow(color: .gray, radius: 5, x: 0, y: 2))
            .padding(.horizontal, 10)
        }
    }
}

#Preview {
    PromptResultRowComponent(videoURL: URL(string: "http://res.cloudinary.com/demtzsiln/video/upload/v1708333103/az3nb7qc89e7hsrftl4y.mov")!, score: 89.2093, tags: ["Search", "Nature", "Tree", "Car", "Search", "Nature", "Tree", "Car", "Search", "Nature", "Tree", "Car"])
}
