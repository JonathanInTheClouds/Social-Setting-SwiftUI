//
//  MainTabView.swift
//  Social Setting
//
//  Created by Mettaworldj on 11/26/22.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "doc.text.image")
                        .environment(\.symbolVariants, .none)
                }
            
            HomeView()
                .tabItem {
                    Label("Inbox", systemImage: "envelope")
                        .environment(\.symbolVariants, .fill)
                }
            
            HomeView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                        .environment(\.symbolVariants, .none)
                }
            
            HomeView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                        .environment(\.symbolVariants, .none)
                }
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
