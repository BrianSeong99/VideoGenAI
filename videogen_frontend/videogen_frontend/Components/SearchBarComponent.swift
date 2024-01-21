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
                .padding(8)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, lineWidth: 1)
                )
            
            Button(action: {
                onSearchButtonTap()
            }) {
                Image(systemName: "magnifyingglass")
                    .padding(8)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipShape(Circle())
            }
        }
        .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
    }
}
