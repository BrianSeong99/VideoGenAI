//
//  ProjectTileComponent.swift
//  videogen_frontend
//
//  Created by JIN WOO SEONG on 2024/2/17.
//

import SwiftUI

struct ProjectTileComponent: View {
    
    @State private var scaleFactor: CGFloat
    @State private var isMagnified: Bool
    @Binding var refreshList: Bool
    var projectListModel: ProjectListModel
    let thumbnail_url: URL
    let project_title: String
    let project_id: String
    
    public init(thumbnail_url: URL, project_title: String, project_id: String, projectListModel: ProjectListModel, refreshList: Binding<Bool>) {
        self.thumbnail_url = thumbnail_url
        self._scaleFactor = State(initialValue: 1.0)
        self._isMagnified = State(initialValue: false)
        self.project_title = project_title
        self.project_id = project_id
        self.projectListModel = projectListModel
        self._refreshList = refreshList
    }
    
    private func toThumbnailURL(url: URL) -> URL {
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        
        if let path = components?.path, path.hasSuffix(".mp4") || path.hasSuffix(".mov") {
            let newPath = path.replacingOccurrences(of: ".mp4", with: ".jpg")
                                  .replacingOccurrences(of: ".mov", with: ".jpg")
            components?.path = newPath
        }

        return components?.url ?? url
    }

    var body: some View {
        ZStack {
            AsyncImage(url: toThumbnailURL(url: thumbnail_url)) { phase in
                if let image = phase.image {
                    image.resizable()
                        .scaledToFill()
//                        .frame(width: 150 * scaleFactor, height: 150 * scaleFactor)
//                        .clipped()
                } else if phase.error != nil {
                    Color.gray.opacity(0.3)
                } else {
                    ProgressView()
                }
            }
            .cornerRadius(10 * scaleFactor)
            .shadow(radius: 5)
            Text(project_title)
                .font(.headline)
                .padding(6)
//                .background(Color.black.opacity(0.7))
                .cornerRadius(5)
                .foregroundColor(.white)
                .padding(8)
            }
            .contextMenu {
                Button(action: {
                    print("Remove Project")
                    projectListModel.deleteSelectedProject(delete_id: project_id) {
                        refreshList = true
                    }
                }) {
                    Text("Remove")
                    Image(systemName: "trash")
            }
        }
    }
}

//#Preview {
//    ProjectTileComponent(thumbnail_url: URL(string: "https://res.cloudinary.com/demtzsiln/video/upload/e_preview:duration_12:max_seg_2:min_seg_dur_1/v1704760797/l2sc5xsrwrimyldyx9nt")!, project_title: "Test")
//}
