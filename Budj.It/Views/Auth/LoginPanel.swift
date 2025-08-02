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
    
    @State private var isSignIn = false;
    @State private var isAppleSignIn = false;
    @State private var isMicrosoftSignIn = false;
    @State private var isGoogleSignIn = false;
    @State private var displayMoreSignInOptions = false;
    @State private var password = "";
    @State private var passwordFocused = false
    
    @ObservedObject var form = AuthForm()
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 16) {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 80)
                    .foregroundColor(.blue)
                
                Text("Create Account")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Sign up to get started")
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            .padding(.top, 20)
            .padding(.bottom, 25)
            
            VStack(spacing: 20) {
                // Email Field
                VStack(alignment: .leading, spacing: 4) {
                    Text("Email")
                        .font(.headline)
                        .fontWeight(.medium)
                        .padding(.leading, 5)
                    
                    TextField("Enter your email", text: $form.email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .validation(form.emailValidation)
                }
                
                // Password Field
                VStack(alignment: .leading, spacing: 4) {
                    Text("Password")
                        .font(.headline)
                        .fontWeight(.medium)
                        .padding(.leading, 5)
                    
                    CustomSecureField(
                        placeholder: "Enter your password",
                        text: $password,
                        isFocused: $passwordFocused
                    )
                }
                
                
                Button(action: handleSignIn) {
                    HStack {
                        if !isSignIn {
                            Text("Sign up")
                                .font(.headline)
                                .fontWeight(.medium)
                        }
                        else {
                            ProgressView()
                                .scaleEffect(0.8)
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        }
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(Color.blue)
                    .cornerRadius(12)
                }
                .disabled(!isFormValid() || isSignIn)
                .opacity(!isFormValid() || isSignIn ? 0.6 : 1.0)
            }
            .padding(.horizontal, 24)
            
            Divider().padding(.vertical, 20)
            
            VStack(spacing: 16) {
                // Apple Sign In
                SignInWithAppleButton(
                    .signIn,
                    onRequest: { request in
                        request.requestedScopes = [.fullName, .email]
                        isAppleSignIn.toggle()
                    },
                    onCompletion: { result in
                        switch result {
                        case .success(let authorization):
                            do {
                                try handleAppleSignIn(authorization: authorization)
                                //TODO: do something after
                            } catch {
                                print(error)
                            }
                        default:
                            //TODO: do something with the failure
                            break
                        }
                        isAppleSignIn.toggle()
                    }
                )
                .signInWithAppleButtonStyle(.black)
                .frame(height: 56)
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
                    .frame(height: 56)
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
                    .frame(height: 56)
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                    .cornerRadius(12)
                }
                .disabled(isMicrosoftSignIn)
                .opacity(isMicrosoftSignIn ? 0.6 : 1.0)
            }
            .padding(.horizontal, 24)
        }
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
