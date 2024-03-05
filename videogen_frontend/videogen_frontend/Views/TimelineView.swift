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
    
    @State private var isUpdate = false
    
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
                TextField("Enter project title", text: $titleText, onCommit: {
                    // Actions to take when the user commits the edit
                    isEditing.toggle()
                    // Any additional logic to handle the updated title
                })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            } else {
                Text(titleText)
                    .fontWeight(.bold) // Bold font weight for prominence
//                    .padding() // Add padding for spacing
                    .frame(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .onTapGesture {
                        self.isEditing = true // Enter editing mode when text is tapped
                    }
            }
        }
    }
    
    private func deleteRow(at offsets: IndexSet) {
        self.projectData!.blocks.remove(atOffsets: offsets)
        isUpdate = true
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
        var _projectData = self.projectData!
        _projectData.blocks.append(blockData)
        projectListModel.updateProject(projectData: _projectData) {
            self.navigateToBlockView = true;
        }
    }
    
    private func getFullVideoList() -> [URL] {
        var fullVideoList: [URL] = []
        if let blocks = projectData?.blocks {
            for block in blocks {
                if let matches = block.matches {
                    for match in matches {
                        if let url = URL(string: match.metadata.secure_url) {
                            fullVideoList.append(url)
                        }
                    }
                }
            }
        }
        return fullVideoList
    }

    
    var body: some View {
        VStack(){
            List {
                ForEach(Array(projectData!.blocks.enumerated()), id: \.element.id) { index, block in
                    NavigationLink(destination:
                        BlockView(
                            project_id: projectId,
                            blockIndex: .constant(index),
                            block_id: .constant(block.block_id),
                            promptString: .constant(block.prompt)
                        )) {
                            BlockRowComponent(blockData: block)
                        }
                    }
                .onDelete(perform: deleteRow)
                .onMove { from, to in
                    self.projectData!.blocks.move(fromOffsets: from, toOffset: to)
                    isUpdate = true
                }
            }
            .listStyle(PlainListStyle())
            Divider()
            Spacer()
            SearchBarComponent(text: $promptString, displayText: "Search with Prompt", onSubmit: promptSubmitted)
        }
        .onAppear() {
            self.titleText = projectData!.project_title
            self.blockIndex = projectData!.blocks.count
            projectListModel.getProject(project_id: projectId) {
                newProjectData in
                self.projectData = newProjectData
            }
        }
        Spacer()
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button(isEditing ? "Done" : "Edit") {
                    isEditing.toggle()
                }
                Button(action: {
                    let fullVideoList = getFullVideoList()
                    print(fullVideoList)
                }) {
                    Image(systemName: "play.circle")
                }
                Button(action: {
                    // do sth, preview
                }) {
                    Image(systemName: "square.and.arrow.up")
                }
            }
        }
        .navigationBarItems(
            leading: EditableTitle
        )
        .onChange(of: isUpdate) { _, _ in
            if (isUpdate) {
                projectListModel.updateProject(projectData: projectData!) {
                    
                }
                isUpdate = false
            }
        }
        .onChange(of: isEditing) { _, _ in
            projectData!.project_title = titleText
        }
        .background(
            NavigationLink(destination: BlockView(
                project_id: projectId,
                blockIndex: $blockIndex,
                block_id: $block_id,
                promptString: $promptString
            ), isActive: $navigateToBlockView) {
                EmptyView()
            }
        )
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
