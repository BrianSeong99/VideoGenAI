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
    
    @State private var AssetLibrary: [VideoResource] = []
    @State private var searchText: String = ""
    @State private var isEditing: Bool = false
    @State private var isFetchingMore = false
    @State private var selectedVideoIndexes: Set<Int> = []
    @State private var photosPickerSelections: [PhotosPickerItem] = []
    @StateObject private var uploadViewModel = UploadViewModel()
    @StateObject private var libraryListModel = LibraryListModel()

    @Environment(\.managedObjectContext) private var viewContext

    let searchControlller = UISearchController();
    
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
    
    private var uploadButton: some View {
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
                uploadViewModel.uploadVideos(video_list: video_list)
            }
        }
    }
    
    private var deleteButton: some View {
        Button(action: {
            var public_ids: [String] = []
            for index in selectedVideoIndexes {
                print(AssetLibrary[index])
                public_ids.append(AssetLibrary[index].public_id)
            }
            print(public_ids)
            libraryListModel.deleteSelectedVideos(deleteList: public_ids)
        }) {
            Image(systemName: "trash")
        }
    }
    
    private var trailingBarItems: some View {
        HStack {
            if isEditing {
                uploadButton
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

    private func loadMoreContentIfNeeded() {
        if (libraryListModel.next_cursor != nil) {
            guard !isFetchingMore, let _ = libraryListModel.next_cursor else { return }
            isFetchingMore = true
            libraryListModel.getAllVideoList(next_page: true)
        }
    }
    
    private func searchLibraryWithText() {
        print("Searching for: \(searchText)")
        libraryListModel.searchCloudinaryVideosWithText(text: searchText)
    }

    var body: some View {
        NavigationView {
            ZStack() {
                VStack() {
                    SearchBarComponent(text: $searchText, onSubmit: searchLibraryWithText)
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 70))], spacing: 2) {
                            ForEach(0..<AssetLibrary.count, id: \.self) { index in
                                VideoTileComponent(
                                    videoURL: Binding(
                                        get: { URL(string: AssetLibrary[index].secure_url)! },
                                        set: { _ in }
                                    ),
                                    isSelected: .constant(self.selectedVideoIndexes.contains(index))
                                )
                                .onTapGesture {
                                    if isEditing {
                                        if selectedVideoIndexes.contains(index) {
                                            selectedVideoIndexes.remove(index)
                                        } else {
                                            selectedVideoIndexes.insert(index)
                                            print(selectedVideoIndexes);
                                        }
                                    }
                                }
                                .onAppear {
                                    if index == AssetLibrary.count - 1 {
                                        print(index)
                                        loadMoreContentIfNeeded()
                                    }
                                }
                            }
                        }
                        .padding()
                        if isFetchingMore {
                            ProgressView()
                                .padding()
                        }
                    }
                    Spacer()
                }
                if uploadViewModel.isUploading {
                    // Overlay view to block interaction and show progress
                    ProgressView("Uploading...", value: uploadViewModel.uploadProgress, total: 1.0)
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
            .disabled(uploadViewModel.isUploading)
        }
        .onAppear {
            libraryListModel.getAllVideoList(next_page: false)
        }
        .onChange(of: libraryListModel.videos) { _, _ in
            self.AssetLibrary = libraryListModel.videos
            selectedVideoIndexes.removeAll()
            isFetchingMore = false
        }
    }
}

struct LibraryView_Previews: PreviewProvider {
    static var previews: some View {
        LibraryView()
    }
}
