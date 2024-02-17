//
//  ProjectsView.swift
//  videogen_frontend
//
//  Created by JIN WOO SEONG on 2024/2/17.
//

import SwiftUI

struct ProjectsView: View {
    
    @State private var ProjectList: [ProjectData] = []
    
    var body: some View {
        NavigationView {
            ZStack {
                UploadButtonComponent(isPickerPresented: .constant(true))
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
