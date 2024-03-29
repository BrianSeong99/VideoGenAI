//
//  ProjectsView.swift
//  videogen_frontend
//
//  Created by JIN WOO SEONG on 2024/2/17.
//

import SwiftUI

struct ProjectsView: View {
    @State private var projectList: [ProjectData] = []
    @State private var projectList_left: [ProjectData] = []
    @State private var projectList_right: [ProjectData] = []
    @State private var isFetchingMore = false
    @StateObject private var projectListModel = ProjectListModel()
    
    @State private var isCreateProjectWindowPresented: Bool = false
    @State private var navigateToTimelineView = false
    @State private var insertedIdForTimelineView: String? = nil
    @State private var navigateToTimelineViewProjectData: ProjectData? = nil
    @State private var defaultProjectData = ProjectData.placeholder
    
    @State private var refreshList = false
    
    private func loadMoreContentIfNeeded() {
        if (projectListModel.totalCount > projectList_left.count + projectList_right.count) {
            guard !isFetchingMore else { return }
            isFetchingMore = true
            projectListModel.getProjectList(page_offset: projectListModel.page+1) {
                _projects in
                projectList = _projects
            }
        }
    }
    
    private func projectTileComponent(currentIndex: Int, leftOrRight: Bool) -> some View {
        let projectData = leftOrRight ? self.projectList_left[currentIndex] : self.projectList_right[currentIndex]
        let thumbnail_url: String = projectData.blocks[0].matches?[0].metadata.url ?? "https://res.cloudinary.com/demtzsiln/video/upload/v1708079752/s6gl22ltwnnoxgppbhgc.jpg"
        return ProjectTileComponent(
            thumbnail_url: URL(string: thumbnail_url)!,
                project_title: projectData.project_title,
                project_id: projectData._id,
                projectListModel: projectListModel,
                refreshList: $refreshList
            )
        .onTapGesture {
            // jump to project details page (Timeline Page)
            print("tapped \(leftOrRight)")
            self.insertedIdForTimelineView = leftOrRight ? self.projectList_left[currentIndex]._id : self.projectList_right[currentIndex]._id
            projectListModel.getProject(project_id: self.insertedIdForTimelineView!) { projectData in
                if let projectData = projectData {
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
            .onAppear {
                projectListModel.getProjectList() {
                    _projects in
                    projectList = _projects
                }
            }
            .onChange(of: refreshList) { _, _ in
                if (refreshList) {
                    projectListModel.getProjectList() {
                        _projects in
                        projectList = _projects
                    }
                    refreshList = false
                }
            }
            .onChange(of: projectList) { _, _ in
                self.projectList_left = projectList.enumerated().compactMap { $0.offset % 2 == 0 ? $0.element : nil }
                self.projectList_right = projectList.enumerated().compactMap { $0.offset % 2 != 0 ? $0.element : nil }
                isFetchingMore = false
            }
            .navigationBarTitle("Projects", displayMode: .inline)
            .background(
                NavigationLink(destination: TimelineView(
                        projectId: insertedIdForTimelineView ?? "",
                        projectData: navigateToTimelineViewProjectData ?? defaultProjectData
                    ), isActive: $navigateToTimelineView) {
                        EmptyView()
                    }
            )
        }
    }
}

struct ProjectView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectsView()
    }
}
