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
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal)
                .submitLabel(.search)
                .onSubmit(of: .text, onSubmit)
        }
    }
}
