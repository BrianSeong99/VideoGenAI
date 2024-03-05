//
//  ProjectModel.swift
//  videogen_frontend
//
//  Created by JIN WOO SEONG on 2024/2/17.
//

import Foundation

struct ProjectListResponse: Decodable {
    let success: Bool
    let totalCount: Int
    let page: Int
    let pageSize: Int
    let projects: [ProjectData]
}

struct CreateProjectResponse: Decodable {
    let acknowledged: Bool
    let inserted_id: String
}

struct ProjectData: Codable, Equatable {
    let _id: String
    let created_at: Float
    let updated_at: Float
    var project_title: String
    var thumbnail_url: String
    var blocks: [BlockData]
}

extension ProjectData {
    static var placeholder: ProjectData {
        return ProjectData(
            _id: "",
            created_at: 0,
            updated_at: 0,
            project_title: "Placeholder",
            thumbnail_url: "",
            blocks: []
        )
    }
}
