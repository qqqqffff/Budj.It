//
//  Register.swift
//  Budj.It
//
//  Created by Apollo Rowe on 7/24/25.
//
import SwiftUI
import FormValidator
import Amplify
import AuthenticationServices

struct RegisterPanel: View {
    @EnvironmentObject var authManager: AuthManager
    @StateObject var form = AuthInputForm()
    
    @State private var isAppleSignUp = false;
    @State private var isMicrosoftSignUp = false;
    @State private var isGoogleSignUp = false;
    
    @State private var error: String?
    
    var body: some View {
        VStack(spacing: 0) {
            AuthWelcomeHeader()
            
            AuthInputItems()
                .environmentObject(form)
                .environmentObject(authManager)
            
            Divider().padding(.vertical, 20)
            
            ExpandableButtonDropdown(
                title: "More signup options",
                content: {
                    SignInWithAppleButton(
                        .signUp,
                        onRequest: { request in
                            request.requestedScopes = [.fullName, .email]
                            isAppleSignUp.toggle()
                        },
                        onCompletion: { result in
                            switch result {
                            case .success(let authorization):
                                authManager.handleAppleSignUp(authorization: authorization)
                            default:
                                //TODO: do something with the failure
                                break
                            }
                            isAppleSignUp.toggle()
                        }
                    )
                    .signInWithAppleButtonStyle(.black)
                    .frame(height: 48)
                    .disabled(isAppleSignUp)
                    .opacity(isAppleSignUp ? 0.6 : 1.0)
                    
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
                    .disabled(isGoogleSignUp)
                    .opacity(isGoogleSignUp ? 0.6 : 1.0)
                    
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
                    .disabled(isMicrosoftSignUp)
                    .opacity(isMicrosoftSignUp ? 0.6 : 1.0)
                },
                mainPadding: EdgeInsets(top: 0, leading: 32, bottom: 0, trailing: 32),
                innerPadding: EdgeInsets(top: 24, leading: 16, bottom: 0, trailing: 16)
            )
            Spacer()
            NavigationLink(destination: LoginPanel().environmentObject(authManager)) {
                Text("Already Have an Account?")
            }
            .padding(.bottom, 16)
        }
        .navigationBarBackButtonHidden()
    }
    
    private func handleGoogleSignIn() ->  Void {
        
    }
    
    private func handleMicrosoftSignIn() -> Void {
        
    }
}

struct PasswordRequirementComponent: View {
    let text: String
    let isValid: Bool
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: isValid ? "checkmark.circle.fill" : "circle")
                .foregroundColor(isValid ? .green : .gray)
            Text(text)
                .font(.caption)
                .foregroundColor(isValid ? .green : .gray)
        }
    }
}



#Preview {
    @Previewable @StateObject var manager = AuthManager()
    @Previewable @StateObject var service = UserProfileService()
    
    NavigationStack {
        RegisterPanel()
            .environmentObject(manager)
            .environmentObject(service)
    }
}
