//
//  SignInView.swift
//  Social Setting
//
//  Created by Mettaworldj on 9/6/22.
//

import SwiftUI

struct SignInView: View {
    
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
                
                Text("Welcome Back!")
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
                    
                    
                    TextField("Your Fancy Username", text: $viewModel.username)
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
                    Text("Log In")
                        .foregroundColor(.white)
                        .bold()
                }
            }
            .padding(.top, 30)
            .padding(.horizontal, 30)
            .disabled(viewModel.sendingData)
            
            HStack {
                Button("Terms of Service") {
                    Task {
                        do {
                            let users: [UserResponse] = try await viewModel.getUsers()
                            print(users)
                        } catch {
                            print(error)
                        }
                    }
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
            focusedField = .Password
        } else {
            focusedField = nil
        }
    }
}

extension SignInView {
    class ViewModel: NetworkingViewModel {
        
        @Published var username = ""
        @Published var email = ""
        @Published var password = ""
        
        override init(network: INetworkManager = NetworkManager.shared) {
            super.init(network: network)
        }
        
        func sendRequest() {
            self.sendingData = true
            Task {
                let signUpObject = LogInUserRequest(username: username, password: password)
                let data = try? JSONEncoder().encode(signUpObject)
                let request = Request(url: URL(string: "http://localhost:5293/user/signin"), data: data, method: .POST)
                guard let urlRequest = request.urlRequest else { return }
                
                do {
                    let token: TokenResponse = try await network.loadUnauthorized(
                        urlRequest,
                        decoder: .social_setting_decoder,
                        allowRetry: true
                    )
                    guard token.save() else { throw AuthManager.AuthError.UnsavedToken }
                    print(token)
                    await removeError()
                    await MainActor.run {
                        withAnimation {
                            AppManager.Authenticated.send(true)
                        }
                    }
                } catch NetworkError.BadDecoding(let data) {
                    if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data),
                       errorResponse.statusCode == 401 {
                        await displayError(errorMessage: "Invalid Username or Password.")
                    } else {
                        await displayError(errorMessage: "Unknown Error.")
                    }
                } catch AuthManager.AuthError.UnsavedToken {
                    await displayError(errorMessage: "Unable to save token.")
                } catch {
                    print(error)
                    await displayError(errorMessage: "Unknown Error.")
                }
            }
        }
        
        func getUsers() async throws -> [UserResponse] {
            return try await network.loadAuthorized(URL(string: "http://localhost:5293/user")!, decoder: .social_setting_decoder, allowRetry: true)
        }
    }
    
    enum FocusedField {
        case Name, Email, Password
    }
    
    enum SignInError: Error {
        
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
