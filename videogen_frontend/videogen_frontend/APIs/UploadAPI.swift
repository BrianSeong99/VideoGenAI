//
//  UploadAPI.swift
//  videogen_frontend
//
//  Created by JIN WOO SEONG on 2024/1/18.
//

import Foundation
import Alamofire

struct DecodableType: Decodable { let url: String }

func uploadVideo(video: Data?){
    if video == nil {
        return
    }
    
    print("Here", video)

    guard let url = URL(string: "http://34.125.61.118:5000/v1/upload/video") else {
        return
    }
    AF.upload(multipartFormData: { (multipartFormData) in
        multipartFormData.append(video!, withName: "video", fileName: "video.mp4", mimeType: "video/mp4")
    }, to: url)
    .uploadProgress { progress in
        print("Upload Progress: \(progress.fractionCompleted)")
    }
    .responseDecodable(of: DecodableType.self) { response in
        print("Response DecodableType: \(response.value)")
    }
}
