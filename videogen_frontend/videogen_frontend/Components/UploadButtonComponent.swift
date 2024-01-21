//
//  UploadButtonComponent.swift
//  videogen_frontend
//
//  Created by JIN WOO SEONG on 2024/1/20.
//

import SwiftUI

struct UploadButtonComponent: View {
    @Binding var isPickerPresented: Bool
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    isPickerPresented = true
                }, label: {
                    Image(systemName: "plus")
                        .font(.system(.largeTitle))
                        .frame(width: 70, height: 70)
                        .foregroundColor(Color.white)
                        .padding(.bottom, 0)
                })
                .background(Color.blue)
                .cornerRadius(38.5)
                .padding()
                .shadow(color: Color.black.opacity(0.3),
                        radius: 3,
                        x: 3,
                        y: 3)
            }
        }
    }
}

#Preview {
    UploadButtonComponent(isPickerPresented: .constant(true))
}
