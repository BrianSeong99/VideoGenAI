//
//  QueryView.swift
//  videogen_frontend
//
//  Created by JIN WOO SEONG on 2024/1/16.
//

import SwiftUI

struct BlockView: View {
    @State private var block_id: String
    @State private var promptString: String
    @State var blockIndex: Int
    @State var blockData: BlockData
    
    @StateObject var blockModel: BlockModel = BlockModel()
    
    init(blockIndex: Int, block_id: String?, promptString: String?, matches: [Match]?) {
        var _block_id: String
        var _promptString: String
        var _matches: [Match]
        if (block_id != nil && promptString != nil && matches != nil) {
            _block_id = block_id!
            _promptString = promptString!
            _matches = matches!
        }
        else {
            _block_id = UUID().uuidString
            _promptString = "Enter Prompt"
            _matches = []
        }
        self.block_id = _block_id
        self.promptString = _promptString
        self.blockIndex = blockIndex
        self.blockData = BlockData(
            block_id: _block_id,
            type: BlockType.Prompted,
            matches: _matches,
            prompt: _promptString
        )
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
            SearchBarComponent(text: $promptString, onSubmit: searchVideosWithPrompt)
            NavigationStack {
                List {
                    ForEach(blockModel.matches, id: \.id) { match in
                        PromptResultRowComponent(
                            videoURL: URL(string: match.metadata.url) ?? URL(string: "https://example.com")!,
                            score: Float(match.score)
                        )
                    }
                    .onDelete(perform: deleteRow)
                }
            }
            .padding(.top, 10)
            Spacer()
        }
    }
}

struct BlockView_Previews: PreviewProvider {
    static var previews: some View {
        let projectData: ProjectData = ProjectData(
            _id: "Test_ID", created_at: 0.0, updated_at: 0.0, project_title: "TEST_TITLE", thumbnail_url: "URL.jpg", blocks: [])
        BlockView(blockIndex: 0, block_id: UUID().uuidString, promptString: "Sunset beach", matches: []);
    }
}
