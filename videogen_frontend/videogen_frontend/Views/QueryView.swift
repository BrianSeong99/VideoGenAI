//
//  QueryView.swift
//  videogen_frontend
//
//  Created by JIN WOO SEONG on 2024/1/16.
//

import SwiftUI

struct QueryView: View {
    @Environment(\.colorScheme) private var colorScheme
    let query: QueryModel
    
    var imageSize: CGSize {
        CGSize(width: 25, height: 25)
    }
    
    var body: some View {
        queryRow(text: query.inputMessage, image: "ProfilePicture", bgColor: Color.black)    }
    
    func queryRow(text: String, image: String, bgColor: Color, responseError: String?=nil, showDotLoading: Bool=false) -> some View {
        HStack(alignment: .top, spacing: 24) {
            
        }
    }
    
    @ViewBuilder
    func queryStructContent(queryType: QueryStructType, image: String, responseError: String? = nil, showDotLoading: Bool = false) -> some View {
        if image.hasPrefix("http"), let url = URL(string: image) {
            AsyncImage(url: url) { image in
                image
                    .resizable()
                    .frame(width: imageSize.width, height: imageSize.height)
            } placeholder: {
                ProgressView()
            }

        } else {
            Image(image)
                .resizable()
                .frame(width: imageSize.width, height: imageSize.height)
        }
        
        VStack(alignment: .leading) {
            switch queryType {
            case .attributed(let attributedOutput):
                attributedView(results: attributedOutput.results)
                
            case .rawText(let text):
                if !text.isEmpty {
                    Text(text)
                        .multilineTextAlignment(.leading)
                        .textSelection(.enabled)
                }
            }
            
            if let error = responseError {
                Text("Error: \(error)")
                    .foregroundColor(.red)
                    .multilineTextAlignment(.leading)
                
//                Button("Regenerate response") {
//                    retryCallback(query)
//                }
                .foregroundColor(.accentColor)
                .padding(.top)
            }
            
            if showDotLoading {
                #if os(tvOS)
                ProgressView()
                    .progressViewStyle(.circular)
                    .padding()
                #else
                DotLoadingView()
                    .frame(width: 60, height: 30)
                #endif
                
            }
        }
    }
    
    func attributedView(results: [ParserResult]) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(results) { parsed in
                Text(parsed.attributedString)
                    .textSelection(.enabled)
            }
        }
    }
}

struct QueryView_Previews: PreviewProvider {
    static let baseURL: String = "http://34.125.61.118:5000/"
    
    static let message = QueryStruct(
            isInteracting: true,
            sendQuery: "What is SwiftUI?",
            senderImage: "ProfilePicture",
            response: ResponseStruct(text: "its fun", videoList: [""]),
            previousResponse: nil,
            responderImage: "Meta",
            responseError: nil
    )

    static let query = QueryModel(
        baseURL: baseURL,
        inputMessage: "Videos about Travel.",
        isInteracting: true
    )
    
    static var previews: some View {
        QueryView(query: query);
    }
}
