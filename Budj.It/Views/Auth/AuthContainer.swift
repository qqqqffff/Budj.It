//
//  AuthContainer.swift
//  Budj.It
//
//  Created by Rowe, Apollinari on 7/31/25.
//

import SwiftUI

enum AuthScreen {
    case welcome
    case register
    case login
}

struct AuthContainer: View {
    @EnvironmentObject private var authManager: AuthManager
    @EnvironmentObject private var userProfileService: UserProfileService
    @State private var currentScreen: AuthScreen = .welcome
    
    var body: some View {
        ZStack {
            Group {
                switch currentScreen {
                case .welcome:
                    VStack(){
                        Text("Welcome to Budj.It")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Spacer()
                        VStack(spacing: 24) {
                            Button(action: { currentScreen = .register }) {
                                Text("Register")
                                    .font(.title2)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 10)
                                    .background(.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(20)
                            }
                            Button (action: { currentScreen = .login }) {
                                Text("Login")
                                    .font(.title2)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 10)
                                    .background(.green.opacity(0.9))
                                    .foregroundColor(.white)
                                    .cornerRadius(20)
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(EdgeInsets(top: 40, leading: 0, bottom: 40, trailing: 0))
                    .transition(.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .trailing)))
                case .register:
                    RegisterPanel(currentScreen: $currentScreen)
                        .environmentObject(authManager)
                        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                case .login:
                    LoginPanel(currentScreen: $currentScreen)
                        .environmentObject(authManager)
                        .environmentObject(userProfileService)
                        .transition(.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .trailing)))
                }
            }
            .animation(.easeInOut(duration: 0.3), value: currentScreen)
        }
    }
}


#Preview {
    @Previewable @StateObject var manager = AuthManager()
    AuthContainer()
        .environmentObject(manager)
}
