//
//  HomeView.swift
//  Social Setting
//
//  Created by Mettaworldj on 11/26/22.
//

import SwiftUI
import KeychainAccess

struct HomeView: View {
    
    @State var searchText = ""
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 30) {
                    ForEach(1...10, id: \.self) { i in
                        PostItem()
                            .padding(.horizontal, 21)
                        Divider()
                            .padding(.bottom)
                    }
                }
                .padding(.top)
                .padding(.bottom, 30)
            }
            .background(Color.gray.opacity(0.15))
            .navigationTitle("Home")
            .searchable(text: $searchText)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        withAnimation {
                            _ = AppManager.logout()
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                    }

                }
            }
        }
    }
    
    func getAllUsers() {
        let network = NetworkManager.shared
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
