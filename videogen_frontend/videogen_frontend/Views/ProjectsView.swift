//
//  ProjectsView.swift
//  videogen_frontend
//
//  Created by JIN WOO SEONG on 2024/2/17.
//

import SwiftUI

struct ProjectsView: View {
    
//    @State private var projectList: [ProjectData] = []
    @State private var projectList_left: [ProjectData] = []
    @State private var projectList_right: [ProjectData] = []
    @State private var isFetchingMore = false
    @State private var isCreateProjectWindowPresented: Bool = false
    @StateObject private var projectListModel = ProjectListModel()
    
    private func loadMoreContentIfNeeded() {
        if (projectListModel.totalCount > projectList_left.count + projectList_right.count) {
            guard !isFetchingMore else { return }
            isFetchingMore = true
            projectListModel.getProjectList(next_page_or_refresh: true)
        }
    }
    
    private func projectTileComponent(currentIndex: Int, leftOrRight: Bool) -> some View {
        if (leftOrRight) {
            ProjectTileComponent(
                thumbnail_url: URL(string: self.projectList_left[currentIndex].thumbnail_url)!,
        project_title: self.projectList_left[currentIndex].project_title
            )
            .onTapGesture {
                // jump to project details page (Timeline Page)
                print("tapped left")
                print(currentIndex)
            }
            .onAppear {
                if currentIndex == self.projectList_left.count - 1 {
                    print(currentIndex)
                    loadMoreContentIfNeeded()
                }
            }
        } else {
            ProjectTileComponent(
                thumbnail_url: URL(string: self.projectList_right[currentIndex].thumbnail_url)!,
        project_title: self.projectList_right[currentIndex].project_title
            )
            .onTapGesture {
                // jump to project details page (Timeline Page)
                print("tapped right")
                print(currentIndex)
            }
            .onAppear {
                if currentIndex == self.projectList_right.count - 1 {
                    print(currentIndex)
                    loadMoreContentIfNeeded()
                }
            }
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView {
                    HStack(alignment: .top){
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100, maximum: 150))], spacing: 20) {
                            ForEach(0..<self.projectList_left.count, id: \.self) { index in
                                projectTileComponent(currentIndex: index, leftOrRight: true)
                            }
                        }
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100, maximum: 150))], spacing: 20) {
                            ForEach(0..<self.projectList_right.count, id: \.self) { index in
                                projectTileComponent(currentIndex: index, leftOrRight: false)
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
                if isFetchingMore {
                    ProgressView()
                        .padding()
                }
                UploadButtonComponent(isCreateProjectWindowPresented: $isCreateProjectWindowPresented)
            }
            .navigationBarTitle("Projects", displayMode: .inline)
        }
        .onAppear {
            projectListModel.getProjectList(next_page_or_refresh: false)
        }
        .onChange(of: projectListModel.projects) { _, _ in
            let projectList = projectListModel.projects
            self.projectList_left = projectList.enumerated().compactMap { $0.offset % 2 == 0 ? $0.element : nil }
            self.projectList_right = projectList.enumerated().compactMap { $0.offset % 2 != 0 ? $0.element : nil }
            isFetchingMore = false
        }
    }
}

struct ProjectView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectsView()
    }
}
