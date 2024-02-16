//
//  LibraryListModel.swift
//  videogen_frontend
//
//  Created by JIN WOO SEONG on 2024/2/14.
//

import Foundation
import Alamofire
import Combine

struct VideoLibraryResponse: Decodable {
    let resources: [VideoResource]
    let next_cursor: String?
}

class LibraryListModel: ObservableObject {
    @Published var videos: [VideoResource] = []
    @Published var next_cursor: String?

    func getAllVideoList(next_page: Bool, limit: Int = 36) {
        let baseString = "http://34.125.61.118:5000/v1/library/get_videos"
        let urlString = next_page && next_cursor != nil ? "\(baseString)?next_cursor=\(next_cursor!)&limit=\(limit)" : "\(baseString)?limit=\(limit)"
        
        AF.request(urlString)
            .validate()
            .responseDecodable(of: VideoLibraryResponse.self) { response in
                print(response)
                switch response.result {
                case .success(let videoLibraryResponse):
                    DispatchQueue.main.async {
                        self.videos = videoLibraryResponse.resources
                        self.next_cursor = videoLibraryResponse.next_cursor
                    }
                case .failure(let error):
                    print(error)
                }
            }
    }
}



