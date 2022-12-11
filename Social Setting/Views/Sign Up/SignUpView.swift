//
//  SignUpView.swift
//  Social Setting
//
//  Created by Mettaworldj on 8/30/22.
//

import SwiftUI

struct SignUpView: View {
    
    @StateObject private var viewModel: ViewModel = .init()
    @FocusState private var focusedField: FocusedField?
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack {
            
            VStack {
                HStack(spacing: 15) {
                    Image("icon")
                        .resizable()
                        .frame(width: 30, height: 30, alignment: .center)
                    Text("Social Setting")
                }
                
                Text("Create an Account")
                    .bold()
                    .font(.largeTitle)
                
                if !viewModel.errorMessage.isEmpty {
                    HorizontalFillButton(backgroundColor: .red.opacity(0.4)) {
                        
                    } label: {
                        Text(viewModel.errorMessage)
                            .foregroundColor(.primary)
                    }
                    .padding(.horizontal, 30)
                    .disabled(true)
                }
            }
            .padding(.bottom, 35)
            
            VStack {
                HStack {
                    HStack {
                        Text("Name")
                            .foregroundColor(Color.gray)
                        Spacer()
                    }
                    .frame(width: 100, alignment: .center)
                    
                    
                    TextField("Your Fancy Name", text: $viewModel.username)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .focused($focusedField, equals: .Name)
                    
                    Spacer()
                }
                .padding()
                .background(Color.gray.opacity(0.20))
                .cornerRadius(10)
                
                HStack {
                    HStack {
                        Text("Email")
                            .foregroundColor(Color.gray)
                        Spacer()
                    }
                    .frame(width: 100, alignment: .center)
                    
                    
                    TextField("Optional", text: $viewModel.email)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .focused($focusedField, equals: .Email)
                    
                    Spacer()
                }
                .padding()
                .background(Color.gray.opacity(0.20))
                .cornerRadius(10)
                
                HStack {
                    HStack {
                        Text("Password")
                            .foregroundColor(Color.gray)
                        Spacer()
                    }
                    .frame(width: 100, alignment: .center)
                    
                    
                    SecureField("Super Secret Password", text: $viewModel.password)
                        .autocapitalization(.none)
                        .focused($focusedField, equals: .Password)
                    
                    Spacer()
                }
                .padding()
                .background(Color.gray.opacity(0.20))
                .cornerRadius(10)
            }
            .padding(.horizontal, 30)
            
            HorizontalFillButton(backgroundColor: .accentColor) {
                viewModel.sendRequest()
            } label: {
                if viewModel.sendingData {
                    ProgressView()
                        .tint(.white)
                } else {
                    Text("Create")
                        .foregroundColor(.white)
                        .bold()
                }
            }
            .padding(.top, 30)
            .padding(.horizontal, 30)
            
            HStack {
                Button("Terms of Service") {
                    
                }
                
                Text("and")
                    .foregroundColor(.gray)
                
                Button("Privacy Policy") {
                    
                }
            }
            .font(.caption)
            .foregroundColor(.primary)
            .padding()

            
            Spacer()
        }
        .navigationBarTitleDisplayMode(.inline)
        .onSubmit(nextField)
    }
    
    private func nextField() {
        if focusedField == .Name {
            focusedField = .Email
        } else if focusedField == .Email {
            focusedField = .Password
        } else {
            focusedField = nil
            
        }
    }
    
}

extension SignUpView {
    class ViewModel: NetworkingViewModel {
        
        @Published var username = ""
        @Published var email = ""
        @Published var password = ""
        
        override init(network: INetworkManager = NetworkManager.shared) {
            super.init(network: network)
        }
        
        func sendRequest() {
            sendingData = true
            Task {
                do {
                    
                    let signUpObject = CreateUserRequest(email: email, username: username, password: password)
                    guard let encodedData = try? JSONEncoder().encode(signUpObject) else { return }
                    guard let url = URL(string: "http://localhost:5293/user/signup") else { return }
                    var urlRequest = URLRequest(url: url)
                    urlRequest.httpMethod = "POST"
                    urlRequest.httpBody = encodedData
                    
                    let token: TokenResponse = try await network.loadUnauthorized(
                        urlRequest,
                        decoder: .social_setting_decoder,
                        allowRetry: true
                    )
                    
                    _ = token.save()
                    await self.removeError()
                } catch NetworkError.BadDecoding(let data) {
                    if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data),
                       errorResponse.statusCode == 409 {
                        await displayError(errorMessage: "Username or Email already in use.")
                    } else {
                        await displayError(errorMessage: "Unknown Error.")
                    }
                } catch {
                    print(error)
                    await displayError(errorMessage: "Unknown Error.")
                }
            }
        }
    }
    
    enum FocusedField {
        case Name, Email, Password
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SignUpView()
        }
    }
}
