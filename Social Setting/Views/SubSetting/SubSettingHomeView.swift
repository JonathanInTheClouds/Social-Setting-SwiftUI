//
//  SubSettingHomeView.swift
//  Social Setting
//
//  Created by Mettaworldj on 12/12/22.
//

import SwiftUI

struct SubSettingHomeView: View {
    
    @State private var post: [PostResponse] = [PostResponse]()
    
    @State private var searchText = ""
    
    @Environment(\.managedObjectContext) private var moc
    
    var subSetting: SubSettingResponse
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(post, id: \.id) { post in
//                        PostItem(post: post)
//                            .padding(.horizontal, 21)
                        ArticleItem(post: post)
                            .padding(.horizontal, 25)
                            .padding(.vertical)
                        Rectangle()
                            .frame(height: 4)
                            .background(Color.red)
                    }
                }
                .padding(.top)
                .padding(.bottom, 30)
            }
            .background(Color.gray.opacity(0.15))
            .navigationTitle(subSetting.name)
            .navigationBarTitleDisplayMode(NavigationBarItem.TitleDisplayMode.inline)
            .searchable(text: $searchText)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        withAnimation {
                            _ = AppManager.logout()
                        }
                    } label: {
                        Image(systemName: "person.fill.xmark")
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        
                    } label: {
                        Image(systemName: "ellipsis")
                    }
                }
            }
            .task {
                await self.post.append(contentsOf: getPostsFromSubSetting())
            }
        }
    }
    
    private func getPostsFromSubSetting() async -> [PostResponse] {
        let network = NetworkManager.shared
        guard let url = URL(string: "http://localhost:5293/setting/\(subSetting.id)/post/") else { return [] }
        let request = Request(url: url, data: nil, method: .GET)
        guard let request = request.urlRequest else { return [] }
        guard let posts: [PostResponse] = try? await network.loadAuthorized(request) else { return [] }
        return posts
    }
    
    private func searchSubSetting() {
        let network = NetworkManager.shared
        Task {
            print("http://localhost:5293/setting/\(subSetting.id)/post/")
            guard let url = URL(string: "http://localhost:5293/setting/\(subSetting.id)/post/") else { return }
            let request = Request(url: url, data: nil, method: .GET)
            guard let request = request.urlRequest else { return }
            do {
                let posts: [PostResponse] = try await network.loadAuthorized(request)
                print(posts)
                await MainActor.run {
                    withAnimation {
                        
                    }
                }
            } catch {
                print(error)
            }
        }
    }
    
    
}

struct SubSettingHomeView_Previews: PreviewProvider {
    static var previews: some View {
        SubSettingHomeView(subSetting: .init(id: "49f5470d-c246-44db-87de-4348ed7d4528", name: "Software Engineering"))
    }
}
