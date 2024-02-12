//
//  SearchView.swift
//  videogen_frontend
//
//  Created by JIN WOO SEONG on 2024/1/9.
//

import SwiftUI
import CoreData
import PhotosUI
import Combine

struct SearchView: View {
    
    init() {
        AssetLibrary = [
            URL(string: "https://res.cloudinary.com/demtzsiln/video/upload/e_preview:duration_12:max_seg_2:min_seg_dur_1/v1704760797/l2sc5xsrwrimyldyx9nt")!,
            URL(string: "https://res.cloudinary.com/demtzsiln/video/upload/e_preview:duration_12:max_seg_2:min_seg_dur_1/v1704760797/l2sc5xsrwrimyldyx9nt")!,
            URL(string: "https://res.cloudinary.com/demtzsiln/video/upload/e_preview:duration_12:max_seg_2:min_seg_dur_1/v1704760797/l2sc5xsrwrimyldyx9nt")!,
            URL(string: "https://res.cloudinary.com/demtzsiln/video/upload/e_preview:duration_12:max_seg_2:min_seg_dur_1/v1704760797/l2sc5xsrwrimyldyx9nt")!,
            URL(string: "https://res.cloudinary.com/demtzsiln/video/upload/e_preview:duration_12:max_seg_2:min_seg_dur_1/v1704760797/l2sc5xsrwrimyldyx9nt")!,
            URL(string: "https://res.cloudinary.com/demtzsiln/video/upload/e_preview:duration_12:max_seg_2:min_seg_dur_1/v1704760797/l2sc5xsrwrimyldyx9nt")!,
            URL(string: "https://res.cloudinary.com/demtzsiln/video/upload/e_preview:duration_12:max_seg_2:min_seg_dur_1/v1704760797/l2sc5xsrwrimyldyx9nt")!,
            URL(string: "https://res.cloudinary.com/demtzsiln/video/upload/e_preview:duration_12:max_seg_2:min_seg_dur_1/v1704760797/l2sc5xsrwrimyldyx9nt")!,
            URL(string: "https://res.cloudinary.com/demtzsiln/video/upload/e_preview:duration_12:max_seg_2:min_seg_dur_1/v1704760797/l2sc5xsrwrimyldyx9nt")!,
            URL(string: "https://res.cloudinary.com/demtzsiln/video/upload/e_preview:duration_12:max_seg_2:min_seg_dur_1/v1704760797/l2sc5xsrwrimyldyx9nt")!,
            URL(string: "https://res.cloudinary.com/demtzsiln/video/upload/e_preview:duration_12:max_seg_2:min_seg_dur_1/v1704760797/l2sc5xsrwrimyldyx9nt")!,
            URL(string: "https://res.cloudinary.com/demtzsiln/video/upload/e_preview:duration_12:max_seg_2:min_seg_dur_1/v1704760797/l2sc5xsrwrimyldyx9nt")!,
            URL(string: "https://res.cloudinary.com/demtzsiln/video/upload/e_preview:duration_12:max_seg_2:min_seg_dur_1/v1704760797/l2sc5xsrwrimyldyx9nt")!,
            URL(string: "https://res.cloudinary.com/demtzsiln/video/upload/e_preview:duration_12:max_seg_2:min_seg_dur_1/v1704760797/l2sc5xsrwrimyldyx9nt")!,
            URL(string: "https://res.cloudinary.com/demtzsiln/video/upload/e_preview:duration_12:max_seg_2:min_seg_dur_1/v1704760797/l2sc5xsrwrimyldyx9nt")!,
            URL(string: "https://res.cloudinary.com/demtzsiln/video/upload/e_preview:duration_12:max_seg_2:min_seg_dur_1/v1704760797/l2sc5xsrwrimyldyx9nt")!,
            URL(string: "https://res.cloudinary.com/demtzsiln/video/upload/e_preview:duration_12:max_seg_2:min_seg_dur_1/v1704760797/l2sc5xsrwrimyldyx9nt")!,
            URL(string: "https://res.cloudinary.com/demtzsiln/video/upload/e_preview:duration_12:max_seg_2:min_seg_dur_1/v1704760797/l2sc5xsrwrimyldyx9nt")!,
            URL(string: "https://res.cloudinary.com/demtzsiln/video/upload/e_preview:duration_12:max_seg_2:min_seg_dur_1/v1704760797/l2sc5xsrwrimyldyx9nt")!,
            URL(string: "https://res.cloudinary.com/demtzsiln/video/upload/e_preview:duration_12:max_seg_2:min_seg_dur_1/v1704760797/l2sc5xsrwrimyldyx9nt")!,
            URL(string: "https://res.cloudinary.com/demtzsiln/video/upload/e_preview:duration_12:max_seg_2:min_seg_dur_1/v1704760797/l2sc5xsrwrimyldyx9nt")!,
            URL(string: "https://res.cloudinary.com/demtzsiln/video/upload/e_preview:duration_12:max_seg_2:min_seg_dur_1/v1704760797/l2sc5xsrwrimyldyx9nt")!,
            URL(string: "https://res.cloudinary.com/demtzsiln/video/upload/e_preview:duration_12:max_seg_2:min_seg_dur_1/v1704760797/l2sc5xsrwrimyldyx9nt")!,
            URL(string: "https://res.cloudinary.com/demtzsiln/video/upload/e_preview:duration_12:max_seg_2:min_seg_dur_1/v1704760797/l2sc5xsrwrimyldyx9nt")!,
            
        ]
    }
    
    @State private var searchText: String = ""
    @State private var selectedVideoIndexs: [Int] = []
    @State private var isPickerPresented: Bool = false
    @State private var isEditing: Bool = false
    @State private var selectedVideoIndexes: Set<Int> = []



    @Environment(\.managedObjectContext) private var viewContext

    let searchControlller = UISearchController();
    var AssetLibrary: [URL];
    
    // Edit button view
    private var editButton: some View {
        Button(action: {
            isEditing.toggle()
            if !isEditing {
                // Perform delete or cancel operation here
                // For example, clear selectedVideoIndexes if canceling
                selectedVideoIndexes.removeAll()
            }
        }) {
            Text(isEditing ? "Done" : "Edit")
        }
    }
    
    private var deleteButton: some View {
        Button(action: {
            // Handle delete action
            // For example, remove selected videos from AssetLibrary and clear selected indexes
            // This is a placeholder for your delete logic
            print("Delete selected items")
        }) {
            Image(systemName: "trash")
        }
    }
    
    private var trailingBarItems: some View {
        HStack {
            if isEditing {
                deleteButton
            }
            editButton
        }
    }

    var body: some View {
        NavigationView {
            ZStack() {
                VStack() {
                    SearchBarComponent(text: $searchText)
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 70))], spacing: 20) {
                            ForEach(0..<AssetLibrary.count, id: \.self) { index in
                                VideoTileComponent(videoURL: AssetLibrary[index], isSelected: .constant(self.selectedVideoIndexes.contains(index)))
                                    .onTapGesture {
                                        if isEditing {
                                            print("isEditing")
                                            // Toggle selection
                                            if selectedVideoIndexes.contains(index) {
                                                selectedVideoIndexes.remove(index)
                                            } else {
                                                selectedVideoIndexes.insert(index)
                                                print(selectedVideoIndexes);
                                            }
                                        }
                                    }
                            }
                        }
                        .padding()
                    }
                    Spacer()
                }
                UploadButtonComponent(isPickerPresented: $isPickerPresented)
            }
            .navigationBarTitle("Library", displayMode: .inline)
            .navigationBarItems(
                trailing: trailingBarItems
            )
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
