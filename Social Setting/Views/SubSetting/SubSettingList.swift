//
//  SubSettingList.swift
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

struct SubSettingList: View {
    
    @State private var searchText = ""
    
    @Environment(\.managedObjectContext) private var moc
    
    @FetchRequest(
        sortDescriptors: [],
        predicate: NSPredicate(format: "favorite = %d", true)
    )
    private var favoriteSubSettings: FetchedResults<SubSettingEntity>
    
    @FetchRequest(
        sortDescriptors: [],
        predicate: NSPredicate(format: "favorite = %d", false)
    )
    private var subSettings: FetchedResults<SubSettingEntity>
    
    @State private var subSettingSearchResults = [SubSettingResponse]()
    
    @StateObject private var searchBarViewModel = SearchBarViewModel()
    
    @State private var shouldPresent = false
    
    private var filteredFavoriteSubSettings: [SubSettingEntity] {
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
                                SubSettingHomeView(subSetting: .init(id: subSetting.id ?? "", name: subSetting.title ?? ""))
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
            .onReceive(
                searchBarViewModel.$text
                    .debounce(for: .seconds(0.8), scheduler: DispatchQueue.main)
            ) {
                guard !$0.isEmpty else { return }
                print(">> searching for: \($0)")
                searchSubSetting(text: $0)
            }
            .autocorrectionDisabled()
            .navigationTitle("Sub Settings")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        self.shouldPresent = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
    
    private func searchSubSetting(text: String) {
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
    
    private func getAllUsers() {
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
        SubSettingList()
    }
}
