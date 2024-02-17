//
//  ProjectsView.swift
//  videogen_frontend
//
//  Created by JIN WOO SEONG on 2024/2/17.
//

import SwiftUI

struct ProjectsView: View {
    
    @State private var ProjectList: [ProjectData] = []
    @State private var isFetchingMore = false
    @State private var isCreateProjectWindowPresented: Bool = false

    @StateObject private var projectListModel = ProjectListModel()
    
    private func loadMoreContentIfNeeded() {
        if (projectListModel.next_cursor != nil) {
            guard !isFetchingMore, let _ = projectListModel.next_cursor else { return }
            isFetchingMore = true
            projectListModel.getProjectList(next_page: true)
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 70))], spacing: 2) {
                        ForEach(0..<ProjectList.count, id: \.self) { index in
                            ProjectTileComponent(
                                thumbnail_url: Binding(
                                    get: { URL(string: ProjectList[index].thumb_nail_url)! },
                                    set: { _ in }
                                )
                            )
                            .onTapGesture {
                                // jump to project details page (Timeline Page)
                            }
                            .onAppear {
                                if index == ProjectList.count - 1 {
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
        //        .onAppear {
        ////            libraryListModel.getAllVideoList(next_page: false)
        //        }
        //        .onChange(of: libraryListModel.videos) { _, _ in
        ////            print("------BEFORE")
        ////            print(self.AssetLibrary)
        //
        //            self.AssetLibrary = libraryListModel.videos
        //            selectedVideoIndexes.removeAll()
        //
        ////            print("------AFTER")
        ////            print(self.AssetLibrary)
        //            isFetchingMore = false
        //        }
    }
}

struct ProjectView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectsView()
    }
}
