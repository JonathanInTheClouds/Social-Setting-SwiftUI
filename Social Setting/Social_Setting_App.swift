//
//  Social_Setting_App.swift
//  Social Setting
//
//  Created by Mettaworldj on 8/29/22.
//

import SwiftUI

@main
struct Social_Setting_App: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            RouterView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
