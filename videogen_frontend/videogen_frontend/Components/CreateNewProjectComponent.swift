//
//  CreateNewProjectComponent.swift
//  videogen_frontend
//
//  Created by JIN WOO SEONG on 2024/2/18.
//

import SwiftUI

struct CreateNewProjectComponent: View {
    @State private var projectTitle = ""
    @State private var navigateToTimelineView = false
    @State private var insertedId: String? = nil
    @StateObject var projectListModel = ProjectListModel() // Assuming you have a function to add projects

    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter project title", text: $projectTitle)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding(.horizontal)
                
                Button(action: {
                    projectListModel.createProject(project_title: projectTitle) { insertedId in
                        self.insertedId = insertedId
                        self.navigateToTimelineView = insertedId != nil
                    }
                }) {
                    Text("Create Project")
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding(.horizontal)
                }
                .disabled(projectTitle.isEmpty)
                
                Spacer() // Pushes all content to the top
            }
            .navigationBarTitle("New Project", displayMode: .inline)
            .background(
                NavigationLink(destination: TimelineView(projectId: insertedId ?? ""), isActive: $navigateToTimelineView) {
                    EmptyView()
                }
            )
        }
    }
}

struct CreateNewProjectComponent_Previews: PreviewProvider {
    static var previews: some View {
        CreateNewProjectComponent()
    }
}
