//
//  CreateNewProjectComponent.swift
//  videogen_frontend
//
//  Created by JIN WOO SEONG on 2024/2/18.
//

import SwiftUI

struct CreateNewProjectComponent: View {
    @State private var projectTitle = ""
    @State private var insertedId: String? = nil
    @StateObject var projectListModel = ProjectListModel() // Assuming you have a function to add projects
    @Binding var isPresented: Bool
    
    var onDismiss: ((String) -> Void)?

    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter project title", text: $projectTitle)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding(.horizontal)
                Spacer()
                Button(action: {
                    projectListModel.createProject(project_title: projectTitle) { insertedId in
                        if let insertedId = insertedId {
                            self.isPresented = false
                            onDismiss?(insertedId)
                        } else {
                            print("insertID failed")
                        }
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
//                .disabled(projectTitle.isEmpty)
            }
            .navigationBarTitle("New Project", displayMode: .inline)
        }
    }
}

//struct CreateNewProjectComponent_Previews: PreviewProvider {
//    static var previews: some View {
//        CreateNewProjectComponent()
//    }
//}
