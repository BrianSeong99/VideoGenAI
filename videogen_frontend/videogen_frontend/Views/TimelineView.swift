//
//  TimelineView.swift
//  videogen_frontend
//
//  Created by JIN WOO SEONG on 2024/1/9.
//

import SwiftUI

struct TimelineView: View {
    @State var projectId: String
    @State var projectData: ProjectData?
    @StateObject private var projectListModel = ProjectListModel()
        
    @State private var navigateToBlockView = false
    
    @State private var isEditing = false
    @State private var titleText = "Untitled Project"
    
    @State var block_id: String = UUID().uuidString
    @State var promptString: String = ""
    @State var blockIndex: Int = 0
    @State var blockData: BlockData = BlockData(
        block_id: "",
        type: BlockType.Prompted,
        matches: nil,
        prompt: ""
    )

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
    
    private func deleteRow(at offsets: IndexSet) {
        self.projectData!.blocks.remove(atOffsets: offsets)
    }
    
    private func promptSubmitted(){
        blockIndex = projectData!.blocks.count
        block_id = UUID().uuidString
        blockData = BlockData(
            block_id: block_id,
            type: BlockType.Prompted,
            matches: [],
            prompt: promptString
        )
        self.navigateToBlockView = true;
    }
    
    var body: some View {
        NavigationView {
            VStack(){
                EditableTitle
                    .onChange(of: projectData) { _, _ in
                        projectListModel.updateProject(projectData: projectData!)
                    }
                    .onChange(of: titleText) { _, _ in
                        projectData!.project_title = titleText
                    }
                NavigationStack {
                    List {
                        ForEach(projectData!.blocks) { block in
                            BlockRowComponent(blockData: block)
                        }
                        .onDelete(perform: deleteRow)
                        .onMove { from, to in
                            self.projectData!.blocks.move(fromOffsets: from, toOffset: to)
                        }
                    }
                    Divider()
                    Spacer()
                    SearchBarComponent(text: $promptString, displayText: "Search with Prompt", onSubmit: promptSubmitted)
                }
            }
            .onAppear() {
                print("blockview", projectData)
                self.titleText = projectData!.project_title
                self.blockIndex = projectData!.blocks.count
            }
            .navigationBarItems(
                trailing: Button(isEditing ? "Done" : "Edit") {
                    isEditing.toggle()
                }
            )
            .background(
                NavigationLink(destination: BlockView(
                    project_id: projectId,
                    blockIndex: $blockIndex,
                    block_id: $block_id,
                    promptString: $promptString,
                    blockData: $blockData
                ), isActive: $navigateToBlockView) {
                    EmptyView()
                }
            )
            Spacer()

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
