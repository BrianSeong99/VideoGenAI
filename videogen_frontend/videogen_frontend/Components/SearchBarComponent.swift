//
//  SearchBarComponent.swift
//  videogen_frontend
//
//  Created by JIN WOO SEONG on 2024/1/18.
//

import SwiftUI

struct SearchBarComponent: View {
    @Binding var text: String
    var onSubmit: () -> Void = {}

    var body: some View {
        HStack {
            TextField("Search with Keywords", text: $text)
                .padding(8)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, lineWidth: 1)
                )
                .submitLabel(.search) // Opt-in to use the search submit label on iOS 15+
                .onSubmit(of: .text, onSubmit) // Use the onSubmit modifier
        }
        .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
    }
}
