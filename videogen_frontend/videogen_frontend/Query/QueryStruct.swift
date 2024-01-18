//
//  QueryStruct.swift
//  videogen_frontend
//
//  Created by JIN WOO SEONG on 2024/1/16.
//

import SwiftUI

struct ResponseStruct {
    var text: String
    var videoList: Any
}

struct ParserResult: Identifiable {
    
    let id = UUID()
    let attributedString: AttributedString    
}

struct AttributedOutput {
    let string: String
    let results: [ParserResult]
}

enum QueryStructType {
    case attributed(AttributedOutput)
    case rawText(String)
    
    var text: String {
        switch self {
        case .attributed(let attributedOutput):
            return attributedOutput.string
        case .rawText(let string):
            return string
        }
    }
}

struct QueryStruct: Identifiable {
    
    let id = UUID()
    
    var isInteracting: Bool
    
    var sendQuery: String
    let senderImage: String
    
    var response: ResponseStruct?
    var previousResponse: ResponseStruct?
    let responderImage: String
        
    let responseError: String?
}
