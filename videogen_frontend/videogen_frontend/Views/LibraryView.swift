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

struct LibraryView: View {
    
    init() {
        AssetLibrary = [
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
    @State private var photosPickerSelections: [PhotosPickerItem] = []
    @StateObject private var viewModel = UploadViewModel()

    @Environment(\.managedObjectContext) private var viewContext

    let searchControlller = UISearchController();
    var AssetLibrary: [URL];
    
    private var editButton: some View {
        Button(action: {
            isEditing.toggle()
            if !isEditing {
                selectedVideoIndexes.removeAll()
            }
        }) {
            Text(isEditing ? "Done" : "Edit")
        }
    }
    
    private var deleteButton: some View {
        Button(action: {
            print("Delete selected items")
        }) {
            Image(systemName: "trash")
        }
    }
    
    private var trailingBarItems: some View {
        HStack {
            if isEditing {
                PhotosPicker(selection: $photosPickerSelections, maxSelectionCount: 4, matching: .videos) {
                    Label("Add Item", systemImage: "plus")
                }
                .onChange(of: photosPickerSelections) { _, _ in
                    print("changed")
                    Task {
                        print("here")
                        var video_list: [Data] = [];
                        for photosPickerItem in photosPickerSelections {
                            if let data = try? await photosPickerItem.loadTransferable(type: Data.self) {
                                video_list.append(data)
                                print("here1")
                            }
                        }
                        print("video_list len:", video_list)
                        viewModel.uploadVideos(video_list: video_list)
                    }
                }
                deleteButton
            }
            Button(action: {
                isEditing.toggle()
                if !isEditing {
                    selectedVideoIndexes.removeAll()
                }
            }) {
                Text(isEditing ? "Done" : "Edit")
            }
        }
    }

    var body: some View {
        NavigationView {
            ZStack() {
                VStack() {
                    SearchBarComponent(text: $searchText)
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 70))], spacing: 2) {
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
                if viewModel.isUploading {
                    // Overlay view to block interaction and show progress
                    ProgressView("Uploading...", value: viewModel.uploadProgress, total: 1.0)
                        .progressViewStyle(LinearProgressViewStyle())
                        .frame(width: 200)
                        .padding()
                        .background(Color.secondary.colorInvert().opacity(0.8))
                        .foregroundColor(.primary)
                        .cornerRadius(10)
                        .shadow(radius: 10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.primary, lineWidth: 2)
                        )
                }
            }
            .navigationBarTitle("Library", displayMode: .inline)
            .navigationBarItems(
                trailing: trailingBarItems
            )
            .disabled(viewModel.isUploading)
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        LibraryView()
    }
}
