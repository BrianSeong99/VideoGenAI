//
//  QueryModel.swift
//  videogen_frontend
//
//  Created by JIN WOO SEONG on 2024/1/16.
//

import Foundation
import SwiftUI

class QueryModel: ObservableObject {
    @Published var query: QueryStruct
    @Published var inputMessage: String
    @Published var isInteracting: Bool
    
    private var baseURL: String = ""
    
    init(baseURL: String, inputMessage: String, isInteracting: Bool) {
        self.baseURL = baseURL
        self.query = QueryStruct(
            isInteracting: isInteracting,
            sendQuery: inputMessage,
            senderImage: "ProfilePicture",
            response: nil,
            responderImage: "Meta",
            responseError: nil
        )
        self.inputMessage = inputMessage
        self.isInteracting = isInteracting
    }
    
    @MainActor
    func sendTapped() async {
        let text = inputMessage
        inputMessage = ""
        await send(text: text)
    }
    
    @MainActor
    private func send(text: String) async {
        isInteracting = true
        let sendQuery: String = text
        var response: ResponseStruct = ResponseStruct(text: "", videoList: [])
        var responseError: String? = nil
        
        // Create a URL
        var urlComponents = URLComponents(string: "http://34.125.61.118:5000/v1/query/query_videos")!
        urlComponents.queryItems = [URLQueryItem(name: "query", value: text)]

        
        var request = URLRequest(url: urlComponents.url!, timeoutInterval: Double.infinity)
        request.httpMethod = "GET"

        do {
            let (data, resp) = try await URLSession.shared.data(for: request)
            response.videoList = data
        } catch {
            responseError = error.localizedDescription
        }
        
        isInteracting = false
        
        let queryStruct = QueryStruct(
            isInteracting: isInteracting,
            sendQuery: sendQuery,
            senderImage: "ProfilePicture",
            response: response,
            previousResponse: nil,
            responderImage: "Meta",
            responseError: responseError
        )
        
        self.query = queryStruct

    }
}
