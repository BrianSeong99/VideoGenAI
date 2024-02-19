//
//  ProjectModel.swift
//  videogen_frontend
//
//  Created by JIN WOO SEONG on 2024/2/17.
//

import Foundation

struct ProjectData: Decodable, Equatable {
    let _id: String
    let created_at: Float
    let updated_at: Float
    var project_title: String
    var thumbnail_url: String
    var blocks: [BlockData]
}

enum BlockType: String, Decodable {
    case Imported = "Imported"
    case Prompted = "Prompted"
}

// Block Data Type for Queries and Answers
struct BlockData: Decodable, Equatable{
    let block_id: String
    let type: BlockType
    let videoList: [VideoResource]
    let prompt: String
}
