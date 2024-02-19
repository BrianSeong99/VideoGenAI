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
    let tags: [String]?
    let url: String
    let secure_url: String

    enum CodingKeys: String, CodingKey {
        case asset_id
        case public_id
        case format
        case version
        case resource_type
        case type
        case created_at
        case bytes
        case width
        case height
        case folder
        case tags
        case url
        case secure_url
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.asset_id = try container.decode(String.self, forKey: .asset_id)
        self.public_id = try container.decode(String.self, forKey: .public_id)
        self.format = try container.decode(String.self, forKey: .format)
        self.version = try container.decode(Int.self, forKey: .version)
        self.resource_type = try container.decode(String.self, forKey: .resource_type)
        self.type = try container.decode(String.self, forKey: .type)
        self.created_at = try container.decode(String.self, forKey: .created_at)
        self.bytes = try container.decode(Int.self, forKey: .bytes)
        self.width = try container.decode(Int.self, forKey: .width)
        self.height = try container.decode(Int.self, forKey: .height)
        self.folder = try container.decode(String.self, forKey: .folder)
        
        if let tagsArray = try? container.decodeIfPresent([String].self, forKey: .tags) {
            self.tags = tagsArray
        } else {
            self.tags = []
        }
        
        self.url = try container.decode(String.self, forKey: .url)
        self.secure_url = try container.decode(String.self, forKey: .secure_url)
    }
}
