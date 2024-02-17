//
//  ProjectListModel.swift
//  videogen_frontend
//
//  Created by JIN WOO SEONG on 2024/2/17.
//

import Foundation
import Alamofire
import Combine

struct ProjectListResponse: Decodable {
    let projects: [ProjectData]
    let next_cursor: String?
}

class ProjectListModel: ObservableObject {
    @Published var projects: [ProjectData] = []
    @Published var next_cursor: String?
    
    func getProjectList(next_page: Bool = false, limit: Int = 20) {
        let baseString = "http://localhost:5000/v1/projects/get_projects"
        let urlString = next_page && next_cursor != nil ? "\(baseString)?next_cursor=\(next_cursor!)&limit=\(limit)" : "\(baseString)?limit=\(limit)"
        
        AF.request(urlString)
            .validate()
            .responseDecodable(of: ProjectListResponse.self) { response in
                switch response.result {
                case .success(let projectListResponse):
                    if (next_page) {
                        DispatchQueue.main.async {
                            self.projects.append(contentsOf: projectListResponse.projects)
                            print("continue", projectListResponse.projects.count)
                            if let nextCursor = projectListResponse.next_cursor, !nextCursor.isEmpty {
                                self.next_cursor = nextCursor
                                print("Next cursor: \(nextCursor)")
                            } else {
                                self.next_cursor = nil
                                print("No more pages.")
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.projects = projectListResponse.projects
                            print("first", projectListResponse.projects.count, projectListResponse)
                            if let nextCursor = projectListResponse.next_cursor, !nextCursor.isEmpty {
                                self.next_cursor = nextCursor
                                print("Next cursor: \(nextCursor)")
                            } else {
                                self.next_cursor = nil
                                print("No more pages.")
                            }
                        }
                    }
                case .failure(let error):
                    print(error)
                }
            }
    }
    
    func deleteSelectedProjects(delete_id: String) {
        let parameters: Parameters = [
            "id": delete_id
        ]
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        let urlString = "http://34.125.61.118:5000/v1/projects/delete"
        AF.request(urlString, method: .delete, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseData { response in
                switch response.result {
                case .success:
                    print("delete success")
                    self.getProjectList(next_page: false)
                case .failure(let error):
                    print(error)
                }
            }
    }
}
