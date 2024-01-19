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
            SearchView()
            .tabItem {
                Image(systemName: "sparkle.magnifyingglass")
                Text("Search Tab")
            }

            TimelineView()
            .tabItem {
                Image(systemName: "calendar.day.timeline.left")
                Text("Timeline Tab")
            }
            
            TimelineView()
            .tabItem {
                Image(systemName: "person.crop.circle")
                Text("Profile Tab")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView();
    }
}
