//
//  SearchBarComponent.swift
//  videogen_frontend
//
//  Created by JIN WOO SEONG on 2024/1/18.
//

import SwiftUI

struct SearchBarComponent: View {
    @Binding var text: String
    var onSearchButtonTap: () -> Void = {}

    var body: some View {
        HStack {
            TextField("Search", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button(action: {
                // Perform search or clear search text
                onSearchButtonTap()
            }) {
                Image(systemName: "magnifyingglass")
            }
        }
        .padding()
    }
}
