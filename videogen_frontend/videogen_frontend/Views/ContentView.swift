//
//  ContentView.swift
//  videogen_frontend
//
//  Created by JIN WOO SEONG on 2024/1/9.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            LibraryView()
            .tabItem {
                Image(systemName: "sparkle.magnifyingglass")
                Text("Search Tab")
            }

            ProjectsView()
            .tabItem {
                Image(systemName: "folder")
                Text("Projects")
            }
            
            TimelineView()
            .tabItem {
                Image(systemName: "person.crop.circle")
                Text("Profile Tab")
            }
        }
//        .environment(\.colorScheme, .dark)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView();
    }
}
