//
//  ProjectModel.swift
//  videogen_frontend
//
//  Created by JIN WOO SEONG on 2024/2/17.
//

import Foundation

struct ProjectData {
    let project_id: String
    let created_at: String
    let project_title: String
    let thumb_nail_url: String
    let blocks: [BlockData]
}

enum BlockType {
    case Imported
    case Prompted
}

// Block Data Type for Queries and Answers
struct BlockData {
    let block_id: String
    let type: BlockType
    let videoList: [VideoResource]
    let prompt: String
}
