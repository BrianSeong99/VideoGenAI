//
//  ProjectsView.swift
//  videogen_frontend
//
//  Created by JIN WOO SEONG on 2024/2/17.
//

import SwiftUI

struct ProjectsView: View {
    
    @State private var projectList_left: [ProjectData] = []
    @State private var projectList_right: [ProjectData] = []
    @State private var isFetchingMore = false
    @StateObject private var projectListModel = ProjectListModel()
    
    @State private var isCreateProjectWindowPresented: Bool = false
    @State private var navigateToTimelineView = false
    @State private var insertedIdForTimelineView: String? = nil
    @State private var navigateToTimelineViewProjectData: ProjectData? = nil
    
    private func loadMoreContentIfNeeded() {
        if (projectListModel.totalCount > projectList_left.count + projectList_right.count) {
            guard !isFetchingMore else { return }
            isFetchingMore = true
            projectListModel.getProjectList(next_page_or_refresh: true)
        }
    }
    
    private func projectTileComponent(currentIndex: Int, leftOrRight: Bool) -> some View {
        let projectData = leftOrRight ? self.projectList_left[currentIndex] : self.projectList_right[currentIndex]
        let defaultThumbnailURL = "https://res.cloudinary.com/demtzsiln/video/upload/v1708079752/s6gl22ltwnnoxgppbhgc.jpg"
        return ProjectTileComponent(
                thumbnail_url: URL(string: projectData.thumbnail_url) ?? URL(string: defaultThumbnailURL)!,
                project_title: projectData.project_title,
                project_id: projectData._id,
                projectListModel: projectListModel
            )
        .onTapGesture {
            // jump to project details page (Timeline Page)
            print("tapped \(leftOrRight)")
            print(currentIndex)
            self.insertedIdForTimelineView = leftOrRight ? self.projectList_left[currentIndex]._id : self.projectList_right[currentIndex]._id
            projectListModel.getProject(project_id: self.insertedIdForTimelineView!) { projectData in
                if let projectData = projectData {
                    print(projectData)
                    self.navigateToTimelineViewProjectData = projectData
                    self.navigateToTimelineView = true
                    print("Project Fetch Success")
                } else {
                    print("Project Fetch Failed")
                }
            }
        }
        .onAppear {
            if currentIndex == self.projectList_left.count - 1 {
                print(leftOrRight, currentIndex)
                loadMoreContentIfNeeded()
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
                    .sheet(isPresented: $isCreateProjectWindowPresented) {
                        CreateNewProjectComponent(isPresented: $isCreateProjectWindowPresented) { insertedId in
                            self.insertedIdForTimelineView = insertedId
                            self.isCreateProjectWindowPresented = false
                            projectListModel.getProject(project_id: self.insertedIdForTimelineView!) { projectData in
                                if let projectData = projectData {
                                    print(projectData)
                                    self.navigateToTimelineViewProjectData = projectData
                                    self.navigateToTimelineView = true
                                    print("Project Fetch Success")
                                } else {
                                    print("Project Fetch Failed")
                                }
                            }
                        }
                    }
            }
            .navigationBarTitle("Projects", displayMode: .inline)
            .background(
                NavigationLink(destination: TimelineView(projectId: insertedIdForTimelineView ?? "", projectData: self.navigateToTimelineViewProjectData ?? ProjectData(
                        _id: "65d156f6e5aff7bbf2eb7f3f",
                        created_at: 1708218102.6884632,
                        updated_at: 1708218102.6884632,
                        project_title: "two more things",
                        thumbnail_url: "https://res.cloudinary.com/demtzsiln/video/upload/v1708079752/s6gl22ltwnnoxgppbhgc.jpg",
                        blocks: []
                    )), isActive: $navigateToTimelineView) {
                    EmptyView()
                }
            )
        }
        .onAppear {
            projectListModel.getProjectList(next_page_or_refresh: false)
        }
        .onChange(of: projectListModel.projects) { _, _ in
            let projectList = projectListModel.projects
            print(projectList)
            self.projectList_left = projectList.enumerated().compactMap { $0.offset % 2 == 0 ? $0.element : nil }
            self.projectList_right = projectList.enumerated().compactMap { $0.offset % 2 != 0 ? $0.element : nil }
            print(self.projectList_left.count, self.projectList_right.count)
            isFetchingMore = false
        }
    }
}

struct ProjectView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectsView()
    }
}
