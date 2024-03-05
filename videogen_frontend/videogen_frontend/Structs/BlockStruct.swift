//
//  BlockStruct.swift
//  videogen_frontend
//
//  Created by JIN WOO SEONG on 2024/2/19.
//

import Foundation

enum BlockType: String, Codable {
    case Imported = "Imported"
    case Prompted = "Prompted"
}

struct BlockData: Codable, Equatable, Identifiable{
    let block_id: String
    var id: String { block_id }
    let type: BlockType
    var matches: [Match]?
    var prompt: String
}

struct PineconeSearchResponse: Decodable {
    let matches: [Match]
    let namespace: String
    let usage: Usage
}

struct Match: Codable, Equatable {
    let id: String
    let metadata: VideoStruct
    let score: Double
    let values: [String]
}

struct Usage: Decodable {
    let readUnits: Int
}

