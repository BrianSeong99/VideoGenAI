//
//  ProjectsView.swift
//  videogen_frontend
//
//  Created by JIN WOO SEONG on 2024/2/17.
//

import SwiftUI

struct ProjectsView: View {
    
    @State private var projectList: [ProjectData] = []
    @State private var isFetchingMore = false
    @State private var isCreateProjectWindowPresented: Bool = false

    @StateObject private var projectListModel = ProjectListModel()
    
    private func loadMoreContentIfNeeded() {
        guard !isFetchingMore else { return }
        isFetchingMore = true
        projectListModel.getProjectList(next_page_or_refresh: true)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 70))], spacing: 2) {
                        ForEach(0..<self.projectList.count, id: \.self) { index in
                            ProjectTileComponent(
                                thumbnail_url: Binding(
                                    get: { URL(string: self.projectList[index].thumbnail_url)! },
                                    set: { _ in }
                                )
                            )
                            .onTapGesture {
                                // jump to project details page (Timeline Page)
                            }
                            .onAppear {
                                if index == self.projectList.count - 1 {
                                    print(index)
                                    loadMoreContentIfNeeded()
                                }
                            }
                        }
                    }
                    .padding()
                    if isFetchingMore {
                        ProgressView()
                            .padding()
                    }
                }
                UploadButtonComponent(isCreateProjectWindowPresented: $isCreateProjectWindowPresented)
            }
            .navigationBarTitle("Projects", displayMode: .inline)
        }
        .onAppear {
            projectListModel.getProjectList(next_page_or_refresh: false)
        }
        .onChange(of: projectListModel.projects) { _, _ in
            self.projectList = projectListModel.projects
            isFetchingMore = false
        }
    }
}

struct ProjectView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectsView()
    }
}
