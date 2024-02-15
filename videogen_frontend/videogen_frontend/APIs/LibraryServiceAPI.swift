//
//  LibraryServiceAPI.swift
//  videogen_frontend
//
//  Created by JIN WOO SEONG on 2024/1/18.
//

import Foundation
import Alamofire

struct DecodableType: Decodable { let url: String }

func uploadVideo(video_list: [Data]){
    print("jere")
    guard !video_list.isEmpty else {
        print("Video list is empty.")
        return
    }
    
    let baseString = "http://34.125.61.118:5000/v1/upload/videos"
    let numVideos = video_list.count
    guard let url = URL(string: "\(baseString)?num_videos=\(numVideos)") else {
        print("Invalid URL")
        return
    }
    
    AF.upload(multipartFormData: { (multipartFormData) in
        for (index, videoData) in video_list.enumerated() {
            let fileName = "video\(index).mp4"
            multipartFormData.append(videoData, withName: "video\(index)", fileName: fileName, mimeType: "video/mp4")
        }
    }, to: url)
    .uploadProgress { progress in
        print("Upload Progress: \(progress.fractionCompleted)")
    }
    .responseDecodable(of: DecodableType.self) { response in
        print("Response DecodableType: \(String(describing: response.value))")
    }
}
