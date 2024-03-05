//
//  QueryView.swift
//  videogen_frontend
//
//  Created by JIN WOO SEONG on 2024/1/16.
//

import SwiftUI

struct BlockView: View {
    @Binding var block_id: String
    @Binding private var promptString: String
    @Binding var blockIndex: Int
    let project_id: String
    @State var projectData: ProjectData? = nil
    
    @State var isUpdate: Bool = false
    
    @StateObject var blockModel: BlockModel = BlockModel()
    @StateObject var projectListModel: ProjectListModel = ProjectListModel()
        
    init(project_id: String, blockIndex: Binding<Int>, block_id: Binding<String>, promptString: Binding<String>) {
        self._block_id = block_id
        self._promptString = promptString
        self._blockIndex = blockIndex
        self.project_id = project_id
    }
    
    private func replaceVideoExtensionWithJPG(for urlString: String) -> String {
        var returnString = urlString
        if urlString.hasSuffix(".mp4") {
            returnString = urlString.replacingOccurrences(of: ".mp4", with: ".jpg")
        } else if urlString.hasSuffix(".mov") {
            returnString = urlString.replacingOccurrences(of: ".mov", with: ".jpg")
        }
        return returnString
    }
    
    private func searchVideosWithPrompt() {
        print("Searching for: \(promptString)")
        self.projectData!.blocks[blockIndex].prompt = promptString
        self.blockModel.searchWithPrompt(prompt: self.projectData!.blocks[blockIndex].prompt) { matches in
            DispatchQueue.main.async {
                if let matches = matches {
                    self.projectData!.blocks[blockIndex].matches = matches
                    isUpdate = true
                }
            }
        }
    }
    
    private func deleteRow(at offsets: IndexSet) {
        print("offsets", offsets)
        self.projectData!.blocks[blockIndex].matches?.remove(atOffsets: offsets)
        isUpdate = true
    }
    
    var body: some View {
        VStack {
            SearchBarComponent(text: $promptString, displayText: "Search with Prompt", onSubmit: searchVideosWithPrompt)
            List {
                ForEach(projectData?.blocks[blockIndex].matches! ?? [], id: \.id) { match in
                    PromptResultRowComponent(
                        videoURL: URL(string: match.metadata.url) ?? URL(string: "https://example.com")!,
                        score: Float(match.score),
                        tags: match.metadata.tags!
                    )
                }
                .onDelete(perform: deleteRow)
                .onMove { from, to in
                    self.projectData!.blocks[blockIndex].matches?.move(fromOffsets: from, toOffset: to)
                    isUpdate = true
                }
                .onChange(of: isUpdate) {
                    if (isUpdate) {
                        if (self.projectData!.blocks[blockIndex].matches != nil && self.projectData!.blocks[blockIndex].matches!.count > 0) {
                            self.projectData!.thumbnail_url = replaceVideoExtensionWithJPG(
                                for: self.projectData!.blocks[blockIndex].matches![0].metadata.url)
                        }
                        if (self.projectData?.blocks.count ?? 0 <= blockIndex) {
                            self.projectData?.blocks.append(self.projectData!.blocks[blockIndex])
                        } else {
                            self.projectData?.blocks[blockIndex] = self.projectData!.blocks[blockIndex]
                        }
                        projectListModel.updateProject(projectData: self.projectData!) {
                            isUpdate = false
                            projectListModel.getProject(project_id: project_id) {
                                newProjectData in
                                self.projectData = newProjectData
                            }
                        }
                    }
                }
            }
            .onAppear() {
                projectListModel.getProject(project_id: project_id) {
                    newProjectData in
                    self.projectData = newProjectData
                    print("projectData updated")
                    if (self.projectData!.blocks[blockIndex].matches! == []) {
                        searchVideosWithPrompt()
                    }
                }
            }
            .listStyle(PlainListStyle())
            Spacer()
        }
    }
}

//struct BlockView_Previews: PreviewProvider {
//    static var previews: some View {
//        let _: ProjectData = ProjectData(
//            _id: "Test_ID", created_at: 0.0, updated_at: 0.0, project_title: "TEST_TITLE", thumbnail_url: "URL.jpg", blocks: [])
//        BlockView(blockIndex: 0, block_id: UUID().uuidString, promptString: "Sunset beach", matches: []);
//    }
//}
