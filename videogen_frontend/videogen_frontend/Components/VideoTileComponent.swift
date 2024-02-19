//
//  VideoTileComponent.swift
//  videogen_frontend
//
//  Created by JIN WOO SEONG on 2024/1/18.
//

import SwiftUI
import UIKit

struct VideoTileComponent: View {
    
    @State private var scaleFactor: CGFloat
    @State private var isMagnified: Bool
    @Binding var videoURL: URL
    @Binding var isSelected: Bool
    @Binding var isIndexing: Bool

    
    public init(videoURL: Binding<URL>, isSelected: Binding<Bool>, isIndexing: Binding<Bool>) {
        self._videoURL = videoURL
        self._scaleFactor = State(initialValue: 1.0)
        self._isMagnified = State(initialValue: false)
        self._isSelected = isSelected
        self._isIndexing = isIndexing
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
            .frame(width: 80 * scaleFactor, height: 80 * scaleFactor)
            .clipped()
//            .cornerRadius(10 * scaleFactor)
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
//                
//                Button(action: {
//                    print("Save Video")
//                }) {
//                    Text("Save")
//                    Image(systemName: "square.and.arrow.down")
//                }
            } preview: {
                VideoPreviewComponent(videoURL: toPreviewURL(url: videoURL))
                    .animation(Animation.snappy(duration: 0.1), value: 0)
                    .zIndex(2)
            }
            .zIndex(isMagnified ? 1 : 0)
            
            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.blue)
                    .padding(4) 
            }
            
            if isIndexing {
                Color.gray.opacity(0.5)
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
    }
}

//#Preview {
//    VideoTileComponent(videoURL: URL(string: "https://res.cloudinary.com/demtzsiln/video/upload/e_preview:duration_12:max_seg_2:min_seg_dur_1/v1704760797/l2sc5xsrwrimyldyx9nt")!)
//}
