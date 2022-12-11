//
//  OnBoardingView.swift
//  Social Setting
//
//  Created by Mettaworldj on 8/29/22.
//

import SwiftUI

struct OnBoardingView: View {
    
    @Environment(\.colorScheme) private var colorScheme
    
    @State private var path: [RootRoutes] = []
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                
                VStack {
                    Image("icon")
                        .resizable()
                        .frame(width: 30, height: 30, alignment: .center)
                    Text("Social Setting")
                        .padding(.bottom, 25)
                }
                
                VStack(spacing: 15) {
                    Text("Control your own\n Social Network.")
                        .font(.largeTitle)
                        .bold()
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Text("Keep in touch with your friends and\n share music or talk about the latest\n trends")
                        .multilineTextAlignment(.center)
                }
                .padding(.bottom, 35)
                
                
                VStack {
                    HorizontalFillButton {
                        self.path.append(.signup)
                    } label: {
                        Text("Sign Up")
                            .foregroundColor(.primary)
                            .bold()
                    }
                    
                    HorizontalFillButton(backgroundColor: .primary) {
                        self.path.append(.apple)
                    } label: {
                        let color = colorScheme == .dark ? Color.black : Color.white
                        
                        Image(systemName: "applelogo")
                            .foregroundColor(color)
                        
                        Text("Continue with Apple")
                            .foregroundColor(color)
                            .bold()
                    }
                    
                    Button {
                        self.path.append(.signin)
                    } label: {
                        Text("Log In")
                            .foregroundColor(.primary)
                            .bold()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.primary)
                    }
                    .padding()


                }
                .padding(.horizontal, 30)

            }
            .navigationDestination(for: RootRoutes.self) { route in
                switch route {
                case .signin: SignInView()
                case .signup: SignUpView()
                case .apple: EmptyView()
                case .signedout: OnBoardingView()
                }
            }
        }
    }
}

extension OnBoardingView {
    enum RootRoutes: String, CaseIterable, Hashable {
        case signup, signin, apple, signedout
    }
}

struct OnBoardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnBoardingView()
    }
}
