//
//  ContentView.swift
//  videogen_frontend
//
//  Created by JIN WOO SEONG on 2024/1/9.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            TabView {
                // Tab 1
                NavigationView {
                    SearchView()
                }
                .tabItem {
                    Image(systemName: "sparkle.magnifyingglass")
                    Text("Search Tab")
                }

                // Tab 2
                NavigationView {
                    TimelineView()
                }
                .tabItem {
                    Image(systemName: "calendar.day.timeline.left")
                    Text("Timeline Tab")
                }
                
                // Tab 2
                NavigationView {
                    TimelineView()
                }
                .tabItem {
                    Image(systemName: "person.crop.circle")
                    Text("Profile Tab")
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView();
    }
}

//#Preview {
//    ContentView()
//}
