//
//  LibraryListModel.swift
//  videogen_frontend
//
//  Created by JIN WOO SEONG on 2024/2/14.
//

import Foundation
import Alamofire
import Combine

class LibraryListModel: ObservableObject {
    @Published var videos: [VideoStruct] = []
    @Published var next_cursor: String?
    
    func getAllVideoList(next_page: Bool = false, limit: Int = 20) {
        let baseString = "http://34.125.61.118:5000/v1/library/get_videos"
        let urlString = next_page && next_cursor != nil ? "\(baseString)?next_cursor=\(next_cursor!)&limit=\(limit)" : "\(baseString)?limit=\(limit)"
        
        AF.request(urlString)
            .validate()
            .responseDecodable(of: VideoLibraryResponse.self) { response in
                switch response.result {
                case .success(let videoLibraryResponse):
                    if (next_page) {
                        DispatchQueue.main.async {
                            self.videos.append(contentsOf: videoLibraryResponse.resources)
                            if let nextCursor = videoLibraryResponse.next_cursor, !nextCursor.isEmpty {
                                self.next_cursor = nextCursor
                                print("Next cursor: \(nextCursor)")
                            } else {
                                self.next_cursor = nil
                                print("No more pages.")
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.videos = videoLibraryResponse.resources
                            if let nextCursor = videoLibraryResponse.next_cursor, !nextCursor.isEmpty {
                                self.next_cursor = nextCursor
                                print("Next cursor: \(nextCursor)")
                            } else {
                                self.next_cursor = nil
                                print("No more pages.")
                            }
                        }
                    }
                case .failure(let error):
                    print(error)
                }
            }
    }
    
    func deleteSelectedVideos(deleteList: [String]) {
        let parameters: Parameters = [
            "public_ids": deleteList
        ]
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        let urlString = "http://34.125.61.118:5000/v1/library/delete_videos"
        AF.request(urlString, method: .delete, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseData { response in
                switch response.result {
                case .success:
                    print("delete success")
                    self.getAllVideoList(next_page: false)
                case .failure(let error):
                    print(error)
                }
            }
    }
    
    func searchCloudinaryVideosWithText(text: String, max_results: Int = 30, next_page: Bool = false) {
        var keywords = text.split(separator: " ").map(String.init)
        if (keywords.count == 0) {
            self.getAllVideoList(next_page: false)
            return
        }
        keywords.append("resource_type:video")
        let expression = keywords.joined(separator: " AND ")
        let baseString = "http://34.125.61.118:5000/v1/library/search"
        let urlString = "\(baseString)?expression=\(expression)&max_results=\(max_results)"
        AF.request(urlString)
            .validate()
            .responseDecodable(of: SearchVideoResponse.self) { response in
                switch response.result {
                case .success(let searchVideoResponse):
                    DispatchQueue.main.async {
                        self.videos = searchVideoResponse.resources
                        if let nextCursor = searchVideoResponse.next_cursor, !nextCursor.isEmpty {
                            self.next_cursor = nextCursor
                            print("Next cursor: \(nextCursor)")
                        } else {
                            self.next_cursor = nil
                            print("No more pages.")
                        }
                    }
                case .failure(let error):
                    print(error)
                }
            }
    }
}



