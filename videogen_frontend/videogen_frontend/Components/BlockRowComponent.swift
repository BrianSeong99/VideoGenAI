//
//  BlockRowComponent.swift
//  videogen_frontend
//
//  Created by JIN WOO SEONG on 2024/2/19.
//

import SwiftUI
import UIKit

struct BlockRowComponent: View {

    @State var blockData: BlockData

    init(blockData: BlockData?) {
        if (blockData == nil) {
            self.blockData = BlockData(
                block_id: UUID().uuidString,
                type: BlockType.Prompted,
                matches: nil,
                prompt: "Enter Your Prompt"
            )
        } else {
            self.blockData = blockData!
        }
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
        VStack{
            Text(blockData.prompt)
                .bold()
                .font(.title2)
                .lineLimit(1)
                .padding(.horizontal)
            ScrollView(.horizontal) {
                HStack(spacing: 20) {
                    ForEach(0..<(self.blockData.matches?.count ?? 0), id: \.self) { index in
                        if let urlString = blockData.matches?[index].metadata.url, let validURL = URL(string: urlString) {
                            AsyncImage(url: toThumbnailURL(url: validURL)) { phase in
                                switch phase {
                                    case .success(let image):
                                        image.resizable()
                                             .aspectRatio(contentMode: .fill)
                                             .frame(width: 160, height: 90)
                                    case .failure(_):
                                        Image(systemName: "photo")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .foregroundColor(.gray)
                                            .frame(width: 160, height: 90)

                                    case .empty:
                                        ProgressView()
                                        .frame(width: 160, height: 90)

                                    @unknown default:
                                        EmptyView()
                                        .frame(width: 160, height: 90)

                                }
                            }
                        } else {
                            Image(systemName: "photo.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(.gray)
                                .frame(width: 160, height: 90)
                        }
                    }
                }
                .padding()
            }
        }
        
    }
}

struct BlockRowComponent_Previews: PreviewProvider {
    static var previews: some View {
        let mockMatch = VideoStruct(
            asset_id: "54a8f5424b3eb6f331840811f865cb34",
            public_id: "agvrbzadfckhgslmkz9h",
            format: "mov",
            version: 1708333095,
            resource_type: "video",
            type: "upload",
            created_at: "datetime.datetime(2024, 2, 19, 8, 58, 15, tzinfo=tzlocal())",
            bytes: 10545168,
            width: 1080,
            height: 1920,
            folder: "",
            tags: [],
            url: "https://res.cloudinary.com/demtzsiln/video/upload/v1708333095/agvrbzadfckhgslmkz9h.mov",
            secure_url: "https://res.cloudinary.com/demtzsiln/video/upload/v1708333095/agvrbzadfckhgslmkz9h.mov"
        )
        let mockBlockData = BlockData(
            block_id: "TEST_ID",
            type: BlockType.Prompted,
            matches: [
                Match(
                    id: "agvrbzadfckhgslmkz9h",
                    metadata: mockMatch,
                    score: 0.815376341,
                    values: []
                ),
                Match(
                    id: "agvrbzadfckhgslmkz9h",
                    metadata: mockMatch,
                    score: 0.815376341,
                    values: []
                ),
                Match(
                    id: "agvrbzadfckhgslmkz9h",
                    metadata: mockMatch,
                    score: 0.815376341,
                    values: []
                ),
                Match(
                    id: "agvrbzadfckhgslmkz9h",
                    metadata: mockMatch,
                    score: 0.815376341,
                    values: []
                ),
                Match(
                    id: "agvrbzadfckhgslmkz9h",
                    metadata: mockMatch,
                    score: 0.815376341,
                    values: []
                ),
                Match(
                    id: "agvrbzadfckhgslmkz9h",
                    metadata: mockMatch,
                    score: 0.815376341,
                    values: []
                )
            ],
            prompt: "TEST_PROMPT_TEST_PROMPT_TEST_PROMPT_TEST_PROMPT_TEST_PROMPT_TEST_PROMPT_"
        )
        
        BlockRowComponent(blockData: mockBlockData)
    }
}
