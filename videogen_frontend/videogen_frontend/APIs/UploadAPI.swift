//
//  UploadAPI.swift
//  videogen_frontend
//
//  Created by JIN WOO SEONG on 2024/1/18.
//

import Foundation

//func UploadVideo(videoFile) {
//    // Create a URL request with the specified URL
//    var request = URLRequest(url: URL(string: "http://34.125.61.118:5000/v1/upload")!)
//    request.httpMethod = "POST"
//
//    // Create a boundary string for the form-data
//    let boundary = UUID().uuidString
//
//    // Set the request header for form-data
//    request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//
//    // Create the form-data body
//    var body = Data()
//
//    // Append the video file data
//    body.append("--\(boundary)\r\n".data(using: .utf8)!)
//    body.append("Content-Disposition: form-data; name=\"video\"; filename=\"video.mp4\"\r\n".data(using: .utf8)!)
//    body.append("Content-Type: video/mp4\r\n\r\n".data(using: .utf8)!)
//    body.append(try! Data(contentsOf: videoURL))
//    body.append("\r\n".data(using: .utf8)!)
//
//    // Append the closing boundary
//    body.append("--\(boundary)--\r\n".data(using: .utf8)!)
//
//    // Set the request body
//    request.httpBody = body
//
//    // Perform the upload task
//    URLSession.shared.dataTask(with: request) { data, response, error in
//        if let error = error {
//            print("Error: \(error.localizedDescription)")
//        } else if let data = data, let response = response as? HTTPURLResponse {
//            if response.statusCode == 200 {
//                print("Upload success")
//                // Handle successful upload
//            } else {
//                print("Upload failed with status code: \(response.statusCode)")
//                // Handle upload failure
//            }
//        }
//    }.resume()
//}

