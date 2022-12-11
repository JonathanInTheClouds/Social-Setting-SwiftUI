//
//  RouterView.swift
//  Social Setting
//
//  Created by Mettaworldj on 11/26/22.
//

import SwiftUI

struct RouterView: View {
    
    @State var isAuthenticated = AppManager.IsAuthenticated()
    
    var body: some View {
        ZStack {
            if isAuthenticated {
                MainTabView()
            } else {
                OnBoardingView()
            }
        }
        .onReceive(AppManager.Authenticated) { output in
            isAuthenticated = output
        }
    }
}

struct RouterView_Previews: PreviewProvider {
    static var previews: some View {
        RouterView()
    }
}
