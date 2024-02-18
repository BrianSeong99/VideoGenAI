//
//  TimelineView.swift
//  videogen_frontend
//
//  Created by JIN WOO SEONG on 2024/1/9.
//

import SwiftUI

struct TimelineView: View {
    @State var projectId: String
    @State var projectData: ProjectData
    @StateObject private var projectListModel = ProjectListModel()
    
    @State private var isEditing = false
    @State private var titleText = "Untitled Project"

    private var EditableTitle: some View {
        Group {
            if isEditing {
                TextField("Enter project title", text: $titleText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            } else {
                Text(titleText)
                    .font(.largeTitle)
            }
        }
        .padding()

    }
    
    var body: some View {
        NavigationView {
            VStack(){
                EditableTitle
//                Text("Timeline for Project ID: \(projectId)")
                    .onAppear() {
                        projectListModel.getProject(project_id: projectId) { projectData in
                            if let projectData = projectData {
                                print(projectData)
                                titleText = projectData.project_title
                                print("Project Fetch Success")
                            } else {
                                print("Project Fetch Failed")
                            }
                        }
                    }
                    .onChange(of: projectData) { _, _ in
                        projectListModel.updateProject(projectData: projectData)
                    }
                    .onChange(of: titleText) { _, _ in
                        projectData.project_title = titleText
//                            projectListModel.updateProject(projectData: projectData)
                    }
                    Spacer()
            }
//                .navigationBarTitle(EditableTitle, displayMode: .inline)
            .navigationBarItems(trailing: Button(isEditing ? "Done" : "Edit") {
                                isEditing.toggle()
                            })
        }
    }
}

struct Timeline_Previews: PreviewProvider {
    static var previews: some View {
        let mockProjectData = ProjectData(
            _id: "65d1561ee5aff7bbf2eb7f2d",
            created_at: 1708218102.6884632,
            updated_at: 1708218102.6884632,
            project_title: "beautiful day",
            thumbnail_url: "https://res.cloudinary.com/demtzsiln/video/upload/v1708079752/s6gl22ltwnnoxgppbhgc.jpg",
            blocks: []
        )
        
        TimelineView(projectId: "65d1561ee5aff7bbf2eb7f2d", projectData: mockProjectData)
    }
}
