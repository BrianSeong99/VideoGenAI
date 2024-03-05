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
    @Binding var blockData: BlockData
    let project_id: String
    @State var projectData: ProjectData? = nil
    
    @StateObject var blockModel: BlockModel = BlockModel()
    @StateObject var projectListModel: ProjectListModel = ProjectListModel()
        
    init(project_id: String, blockIndex: Binding<Int>, block_id: Binding<String>, promptString: Binding<String>, blockData: Binding<BlockData>) {
        self._block_id = block_id
        self._promptString = promptString
        self._blockIndex = blockIndex
        self._blockData = blockData
        self.project_id = project_id
    }
    
    private func replaceVideoExtensionWithJPG(for urlString: String) -> String {
        print(urlString)
        var returnString = urlString
        if urlString.hasSuffix(".mp4") {
            returnString = urlString.replacingOccurrences(of: ".mp4", with: ".jpg")
        } else if urlString.hasSuffix(".mov") {
            print("before", returnString)
            returnString = urlString.replacingOccurrences(of: ".mov", with: ".jpg")
            print("after", returnString)
        }
        print(returnString)
        return returnString
    }
    
    private func searchVideosWithPrompt() {
        print("Searching for: \(promptString)")
        self.blockData.prompt = promptString
        self.blockModel.searchWithPrompt(prompt: self.blockData.prompt) { matches in
            DispatchQueue.main.async {
                if let matches = matches {
                    self.blockData.matches = matches
                }
            }
        }
    }
    
    private func deleteRow(at offsets: IndexSet) {
        self.blockData.matches?.remove(atOffsets: offsets)
    }
    
    var body: some View {
        VStack {
            SearchBarComponent(text: $promptString, displayText: "Search with Prompt", onSubmit: searchVideosWithPrompt)
            List {
                ForEach(blockData.matches!, id: \.id) { match in
                    PromptResultRowComponent(
                        videoURL: URL(string: match.metadata.url) ?? URL(string: "https://example.com")!,
                        score: Float(match.score)
                    )
                }
                .onDelete(perform: deleteRow)
                .onMove { from, to in
                    self.blockData.matches?.move(fromOffsets: from, toOffset: to)
                }
                .onChange(of: self.blockData.matches) {
                    if (self.blockData.matches != nil && self.blockData.matches!.count > 0) {
                        self.projectData!.thumbnail_url = replaceVideoExtensionWithJPG(
                            for: self.blockData.matches![0].metadata.url)
                    }
                    if (self.projectData?.blocks.count ?? 0 <= blockIndex) {
                        self.projectData?.blocks.append(self.blockData)
                    } else {
                        self.projectData?.blocks[blockIndex] = self.blockData
                    }
                    print("prepared!", self.projectData!)
                    // TODO, projectData's block is always empty!
                    projectListModel.updateProject(projectData: self.projectData!)
                }
            }
            .listStyle(PlainListStyle())
            Spacer()
                .onAppear() {
                    projectListModel.getProject(project_id: project_id) {
                        newProjectData in
                        self.projectData = newProjectData
                        print("appear here")
                    }
                    if (self.blockData.matches! == []) {
                        searchVideosWithPrompt()
                    }
                }
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
