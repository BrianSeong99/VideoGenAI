//
//  BlockModel.swift
//  videogen_frontend
//
//  Created by JIN WOO SEONG on 2024/1/16.
//

import Foundation
import SwiftUI
import Alamofire

class BlockModel: ObservableObject {
    
    private let baseURL: String = "http://34.125.61.118:5000/v1/query"
    @Published var matches: [Match] = []
    
    func searchWithPrompt(prompt: String) {
        let urlString = "\(baseURL)/query_videos?query=\(prompt)"
        
        AF.request(urlString)
            .validate()
            .responseDecodable(of: PineconeSearchResponse.self) { [weak self] response in
                switch response.result {
                case .success(let searchResponse):
                    DispatchQueue.main.async {
                        self?.matches = searchResponse.matches
                    }
                case .failure(let error):
                    print("Error during the search: \(error.localizedDescription)")
                }
            }
    }
}
