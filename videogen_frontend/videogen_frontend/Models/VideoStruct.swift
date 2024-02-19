//
//  VideoModel.swift
//  videogen_frontend
//
//  Created by JIN WOO SEONG on 2024/2/15.
//

import Foundation

struct VideoResource: Decodable, Equatable {
    let asset_id: String
    let public_id: String
    let format: String
    let version: Int
    let resource_type: String
    let type: String
    let created_at: String
    let bytes: Int
    let width: Int
    let height: Int
    let folder: String
    let url: String
    let secure_url: String
}
