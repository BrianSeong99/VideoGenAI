import Foundation
import Alamofire
import Combine

class UploadViewModel: ObservableObject {
    @Published var uploadProgress: Float = 0.0
    @Published var isUploading: Bool = false

    func uploadVideos(video_list: [Data]) {
        guard !video_list.isEmpty else {
            print("Video list is empty.")
            return
        }
        
        self.isUploading = true
        let baseString = "http://34.125.61.118:5000/v1/upload/videos"
        let numVideos = video_list.count
        guard let url = URL(string: "\(baseString)?num_videos=\(numVideos)") else {
            print("Invalid URL")
            self.isUploading = false
            return
        }
        
        AF.upload(multipartFormData: { multipartFormData in
            for (index, videoData) in video_list.enumerated() {
                let fileName = "video\(index).mp4"
                multipartFormData.append(videoData, withName: "video\(index)", fileName: fileName, mimeType: "video/mp4")
            }
        }, to: url)
        .uploadProgress { progress in
            DispatchQueue.main.async {
                self.uploadProgress = Float(progress.fractionCompleted)
            }
        }
        .responseDecodable(of: uploadResponse.self) { response in
            DispatchQueue.main.async {
                self.isUploading = false
                print("Upload Complete")
                // Handle response here
            }
        }
    }
}

