//
//  LoginPanel.swift
//  Budj.It
//
//  Created by Rowe, Apollinari on 7/31/25.
//

import SwiftUI
import AuthenticationServices

struct LoginPanel: View {
    @EnvironmentObject var authManager: AuthManager
    
    @State private var isAppleSignIn = false;
    @State private var isMicrosoftSignIn = false;
    @State private var isGoogleSignIn = false;
    
    @StateObject var form = AuthInputForm()
    @StateObject var errorObject = ErrorObject()
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                AuthWelcomeHeader(login: true)
                
                AuthInputItems(login: true)
                    .environmentObject(form)
                    .environmentObject(authManager)
                    .environmentObject(errorObject)
                
                
                Divider().padding(.vertical, 20)
                
                ExpandableButtonDropdown(
                    title: "More login options",
                    content: {
                        SignInWithAppleButton(
                            .signIn,
                            onRequest: { request in
                                request.requestedScopes = [.fullName, .email]
                                isAppleSignIn.toggle()
                            },
                            onCompletion: { result in
                                switch result {
                                case .success(let authorization):
                                    authManager.handleAppleSignUp(authorization: authorization)
                                default:
                                    //TODO: do something with the failure
                                    break
                                }
                                isAppleSignIn.toggle()
                            }
                        )
                        .signInWithAppleButtonStyle(.black)
                        .frame(height: 48)
                        .disabled(isAppleSignIn)
                        .opacity(isAppleSignIn ? 0.6 : 1.0)
                        
                        // Google Sign In
                        Button(action: {
                            handleGoogleSignIn()
                        }) {
                            HStack (alignment: .center) {
                                Image(systemName: "globe")
                                    .font(.title3)
                                    .foregroundColor(.red)
                                
                                Text("Continue with Google")
                                    .font(.headline)
                                    .fontWeight(.medium)
                                    .foregroundColor(.black)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                            .background(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                            .cornerRadius(12)
                        }
                        .disabled(isGoogleSignIn)
                        .opacity(isGoogleSignIn ? 0.6 : 1.0)
                        
                        // Microsoft Sign In
                        Button(action: {
                            handleMicrosoftSignIn()
                        }) {
                            HStack {
                                Image(systemName: "square.grid.2x2.fill")
                                    .font(.title3)
                                    .foregroundColor(.blue)
                                Text("Continue with Microsoft")
                                    .font(.headline)
                                    .fontWeight(.medium)
                                    .foregroundColor(.black)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                            .background(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                            .cornerRadius(12)
                        }
                        .disabled(isMicrosoftSignIn)
                        .opacity(isMicrosoftSignIn ? 0.6 : 1.0)
                    },
                    mainPadding: EdgeInsets(top: 0, leading: 32, bottom: 0, trailing: 32),
                    innerPadding: EdgeInsets(top: 24, leading: 16, bottom: 0, trailing: 16)
                )
                Spacer()
                NavigationLink(destination: RegisterPanel().environmentObject(authManager)) {
                    Text("Don't have an account?")
                }
                .padding(.bottom, 16)
            }
            
            if errorObject.message != nil {
                VStack {
                    ErrorMessage(message: errorObject.message ?? "Unknown Error Occured\nPlease Try Again Later.", onDismiss: {
                        withAnimation(.easeOut(duration: 0.3)) {
                            errorObject.message = nil
                        }
                    })
                    .transition(.move(edge: .top).combined(with: .opacity))
                    
                    Spacer()
                }
                .zIndex(1)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: errorObject.message)
        .navigationBarBackButtonHidden()
    }
        
    func isFormValid() -> Bool {
        return false
    }
    
    func handleSignIn() {
        
    }
    
    func handleAppleSignIn(authorization: ASAuthorization) throws {
        
    }
    
    func handleGoogleSignIn() {
        
    }
    
    func handleMicrosoftSignIn() {
        
    }
}

#Preview {
    @Previewable @StateObject var manager = AuthManager()
    @Previewable @StateObject var service = UserProfileService()
    
    NavigationStack {
        LoginPanel()
            .environmentObject(manager)
            .environmentObject(service)
    }
}
