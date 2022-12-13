//
//  SubSettingItem.swift
//  Social Setting
//
//  Created by Mettaworldj on 12/11/22.
//

import SwiftUI
import CoreData

struct SubSettingItem: View {
    
    @Environment(\.managedObjectContext) var moc
    
    var id: String = ""
    
    var title: String = ""
    
    @State var isFavorite: Bool
    
    @State var subSettingEntity: SubSettingEntity? = nil
    
    private var favoriteIconColor: Color {
        if let subSettingEntity = subSettingEntity, subSettingEntity.favorite {
            return Color.blue
        } else if isFavorite {
            return Color.blue
        } else {
            return Color.gray.opacity(0.2)
        }
    }
    
    init(id: String, title: String, isFavorite: Bool) {
        self.id = id
        self.title = title
        self.isFavorite = isFavorite
    }
    
    init(subSettingResponse: SubSettingResponse) {
        self.init(id: subSettingResponse.id, title: subSettingResponse.name, isFavorite: subSettingResponse.isFavorite ?? false)
    }
    
    init(subSettingEntity: SubSettingEntity) {
        self.init(id: subSettingEntity.id ?? "", title: subSettingEntity.title ?? "", isFavorite: subSettingEntity.favorite)
        self.subSettingEntity = subSettingEntity
        self.isFavorite = subSettingEntity.favorite
    }
    
    init() {
        self.isFavorite = false
    }
    
    var body: some View {
        HStack {
            Circle()
                .fill(Color.gray.opacity(0.5))
                .frame(width: 25)
            
            Text(title)
            
            Spacer()
            
            Button {
                toggleFavorite()
            } label: {
                Image(systemName: "star.fill")
                    .foregroundColor(favoriteIconColor)
            }
            .buttonStyle(.plain)

        }
    }
    
    func toggleFavorite() {
        withAnimation {
            self.isFavorite.toggle()
        }
        if self.subSettingEntity == nil {
            if isFavorite {
                let newSubSetting = SubSettingEntity(context: moc)
                newSubSetting.id = self.id
                newSubSetting.title = self.title
                newSubSetting.favorite = self.isFavorite
                self.subSettingEntity = newSubSetting
            } else {
                let fetchRequest: NSFetchRequest<SubSettingEntity> = SubSettingEntity.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "id == %@", id)
                if let array = try? moc.fetch(fetchRequest) {
                    self.subSettingEntity = array.first
                }
            }
        } else {
            self.subSettingEntity?.favorite = self.isFavorite
        }
        
        if !isFavorite {
            if let subSettingEntity = subSettingEntity {
                moc.delete(subSettingEntity)
                self.subSettingEntity = nil
            }
        }
        
        try? moc.save()
    }
}

struct SubSettingItem_Previews: PreviewProvider {
    static var previews: some View {
        SubSettingItem(id: "", title: "Apple", isFavorite: false)
    }
}
