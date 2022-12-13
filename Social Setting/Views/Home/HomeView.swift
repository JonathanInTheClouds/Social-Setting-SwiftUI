//
//  HomeView.swift
//  Social Setting
//
//  Created by Mettaworldj on 11/26/22.
//

import SwiftUI
import KeychainAccess
import Combine

class SearchBarViewModel: ObservableObject {
    @Published var text: String = ""
}

struct HomeView: View {
    
//    var body: some View {
//        NavigationStack {
//            ScrollView {
//                LazyVStack(spacing: 30) {
//                    ForEach(1...10, id: \.self) { i in
//                        PostItem()
//                            .padding(.horizontal, 21)
//                        Divider()
//                            .padding(.bottom)
//                    }
//                }
//                .padding(.top)
//                .padding(.bottom, 30)
//            }
//            .background(Color.gray.opacity(0.15))
//            .navigationTitle("Home")
//            .searchable(text: $searchText)
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    Button {
//                        withAnimation {
//                            _ = AppManager.logout()
//                        }
//                    } label: {
//                        Image(systemName: "person.fill.xmark")
//                    }
//                }
//
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    Button {
//                        getAllUsers()
//                    } label: {
//                        Image(systemName: "ellipsis")
//                    }
//                }
//            }
//        }
//    }
    
    @State var searchText = ""
    
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest(
        sortDescriptors: [],
        predicate: NSPredicate(format: "favorite = %d", true)
    )
    var favoriteSubSettings: FetchedResults<SubSettingEntity>
    
    @FetchRequest(
        sortDescriptors: [],
        predicate: NSPredicate(format: "favorite = %d", false)
    )
    var subSettings: FetchedResults<SubSettingEntity>
    
    @State var subSettingSearchResults = [SubSettingResponse]()
    
    @StateObject var searchBarViewModel = SearchBarViewModel()
    
    var filteredFavoriteSubSettings: [SubSettingEntity] {
        if searchBarViewModel.text.isEmpty {
            return []
        }
        let filter = favoriteSubSettings.filter {
            ($0.title ?? "").localizedCaseInsensitiveContains(searchBarViewModel.text)
        }
        return filter
    }
    
    var body: some View {
        NavigationStack {
            List {
                if !searchBarViewModel.text.isEmpty {
                    Section("Search Results") {
                        ForEach(subSettingSearchResults, id: \.id) { subSetting in
                            NavigationLink {
                                
                            } label: {
                                SubSettingItem(subSettingResponse: subSetting)
                            }
                        }
                        .onDelete { indexSet in
                            for index in indexSet {
                                subSettingSearchResults.remove(at: index)
                            }
                        }
                    }
                }

                if !favoriteSubSettings.isEmpty {
                    Section("Favorites") {
                        ForEach(favoriteSubSettings, id: \.id) { subSetting in
                            NavigationLink {

                            } label: {
                                SubSettingItem(subSettingEntity: subSetting)
                            }
                        }
                        .onDelete { indexSet in
                            for index in indexSet {
                                moc.delete(favoriteSubSettings[index])
                            }
                            try? moc.save()
                        }
                    }
                }

                ForEach(subSettings, id: \.id) { subSetting in
                    NavigationLink {

                    } label: {
                        SubSettingItem(subSettingEntity: subSetting)
                    }
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        moc.delete(subSettings[index])
                    }
                    try? moc.save()
                }

            }
            .searchable(text: $searchBarViewModel.text.animation())
            .autocorrectionDisabled()
            .navigationTitle("Sub Settings")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {} label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .onReceive(
                searchBarViewModel.$text
                    .debounce(for: .seconds(0.8), scheduler: DispatchQueue.main)
            ) {
                guard !$0.isEmpty else { return }
                print(">> searching for: \($0)")
                searchSubSetting(text: $0)
            }
        }
    }
    
    func searchSubSetting(text: String) {
        let network = NetworkManager.shared
        let ids = Set(self.favoriteSubSettings.compactMap { $0.id })
        Task {
            guard let url = URL(string: "http://localhost:5293/setting/search/\(text)") else { return }
            let request = Request(url: url, data: nil, method: .GET)
            guard let request = request.urlRequest else { return }
            do {
                let subSettings: [SubSettingResponse] = try await network.loadAuthorized(request)
                await MainActor.run {
                    withAnimation {
                        self.subSettingSearchResults = subSettings.map{ subSettingResponse in
                            SubSettingResponse(id: subSettingResponse.id, name: subSettingResponse.name, isFavorite: ids.contains(subSettingResponse.id))
                        }
                    }
                }
            } catch {
                print(error)
            }
        }
    }
    
    func getAllUsers() {
        let network = NetworkManager.shared
        Task {
            guard let url = URL(string: "http://localhost:5293/user") else { return }
            let request = Request(url: url, data: nil, method: .GET)
            guard let request = request.urlRequest else { return }
            do {
                let users: [UserResponse] = try await network.loadAuthorized(request)
                print(users)
            } catch {
                print(error)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
