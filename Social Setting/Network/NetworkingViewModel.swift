//
//  NetworkingViewModel.swift
//  Social Setting
//
//  Created by Mettaworldj on 9/7/22.
//

import SwiftUI

class NetworkingViewModel: ObservableObject {
    @Published var sendingData = false
    @Published var errorMessage = ""
    
    let network: INetworkManager
    
    init(network: INetworkManager = NetworkManager.shared) {
        self.network = network
    }
    
    func displayError(errorMessage: String) async {
        await MainActor.run {
            withAnimation {
                self.errorMessage = errorMessage
                self.sendingData = false
            }
        }
    }
    
    func removeError() async {
        await MainActor.run {
            withAnimation {
                self.errorMessage = ""
                self.sendingData = false
            }
        }
    }
}
