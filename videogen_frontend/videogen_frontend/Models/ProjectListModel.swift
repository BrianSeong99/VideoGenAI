//
//  ProjectListModel.swift
//  videogen_frontend
//
//  Created by JIN WOO SEONG on 2024/2/17.
//

import Foundation
import Alamofire
import Combine

class ProjectListModel: ObservableObject {
    @Published var projects: [ProjectData] = []
    @Published var page: Int = 0
    @Published var totalCount: Int = 0
    
    func getProject(project_id: String, completion: @escaping (ProjectData?) -> Void) {
        let urlString = "http://34.125.61.118:5000/v1/projects?_id=\(project_id)"
        AF.request(urlString)
            .validate()
            .responseDecodable(of: ProjectData.self) { response in
                switch response.result {
                case .success(let projectData):
                    print("getProject", projectData)
                    completion(projectData)
                case .failure(let error):
                    print(error)
                    completion(nil)
                }
            }
    }
    
    func getProjectList(next_page_or_refresh: Bool = false, limit: Int = 10) {
        let baseString = "http://34.125.61.118:5000/v1/projects/get_projects"
        if (next_page_or_refresh) {
            page += 1
        } else {
            page = 0
        }
        let urlString = "\(baseString)?page=\(page)&limit=\(limit)"
        
        AF.request(urlString)
            .validate()
            .responseDecodable(of: ProjectListResponse.self) { response in
                switch response.result {
                case .success(let projectListResponse):
                    self.totalCount = projectListResponse.totalCount;
                    if (next_page_or_refresh) {
                        DispatchQueue.main.async {
                            self.projects.append(contentsOf: projectListResponse.projects)
                            print("continue", projectListResponse.projects.count)
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.projects = projectListResponse.projects
                            print("first", projectListResponse.projects.count)
                            print("getProjectList", projectListResponse.projects[0])
                        }
                    }
                    if projectListResponse.projects.count < limit {
                        print("No more pages.")
                    } else {
                        print("More to load")
                    }
                case .failure(let error):
                    print(error)
                }
            }
    }
    
    func deleteSelectedProject(delete_id: String) {
        let parameters: Parameters = [
            "_id": delete_id
        ]
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        let urlString = "http://34.125.61.118:5000/v1/projects"
        AF.request(urlString, method: .delete, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseData { response in
                switch response.result {
                case .success:
                    print("delete success")
                    self.getProjectList(next_page_or_refresh: false)
                case .failure(let error):
                    print(error)
                }
            }
    }

    func createProject(project_title: String, completion: @escaping (String?) -> Void) {
        let parameters: Parameters = [
            "project_title": project_title,
        ]
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        let urlString = "http://34.125.61.118:5000/v1/projects"
        AF.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseDecodable(of: CreateProjectResponse.self) { response in
                switch response.result {
                case .success(let createProjectResponse):
                    if (createProjectResponse.acknowledged) {
                        print("create success")
                        completion(createProjectResponse.inserted_id)
                    } else {
                        print("create acknowledged false")
                        completion(nil)
                    }
                case .failure(let error):
                    print(error)
                    completion(nil)
                }
            }
    }

    func updateProject(projectData: ProjectData) {
        let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .secondsSince1970 // Adjust this based on your date format needs

            do {
                let jsonData = try encoder.encode(projectData)
                guard let parameters = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] else {
                    print("Failed to convert JSON data to a dictionary")
                    return
                }

                let headers: HTTPHeaders = ["Content-Type": "application/json"]
                let urlString = "http://34.125.61.118:5000/v1/projects"

                AF.request(urlString, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                    .validate()
                    .responseData { response in
                        switch response.result {
                        case .success:
                            print("Update success")
                        case .failure(let error):
                            print("Update failed: \(error)")
                        }
                    }
            } catch {
                print("Encoding failed: \(error)")
            }
        
        //        let parameters: Parameters = [
//            "_id": projectData._id,
//            "project_title": projectData.project_title,
//            "created_at": projectData.created_at,
//            "thumbnail_url": projectData.thumbnail_url,
//            "blocks": []//projectData.blocks
//        ]
////        print(projectData.blocks)
//        let headers: HTTPHeaders = [
//            "Content-Type": "application/json"
//        ]
//        let urlString = "http://34.125.61.118:5000/v1/projects"
//        AF.request(urlString, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
//            .validate()
//            .responseData { response in
//                switch response.result {
//                case .success:
//                    print("update success")
//                case .failure(let error):
//                    print("update failed")
//                    print(error)
//                }
//            }

    }
}
