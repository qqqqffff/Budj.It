//
//  Register.swift
//  Budj.It
//
//  Created by Apollo Rowe on 7/24/25.
//
import SwiftUI
import FormValidator

struct RegisterPanel: View {
    @State private var isAppleSignUp = false;
    @State private var isMicrosoftSignUp = false;
    @State private var isGoogleSignUp = false;
    @State private var displayMoreSignUpOptions = false;
    @State private var password = "";
    @State private var isSecure = true;
    
    @State private var isMinLength = false;
    @State private var upperChar = false;
    @State private var lowerChar = false;
    @State private var number = false;
    @State private var special = false;
    
    @ObservedObject var form = RegisterForm()
    
    var body: some View {
        NavigationView {
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
                        
                        ZStack(alignment: .trailing) {
                            if isSecure {
                                SecureField("Enter your password", text: $password)
                            } else {
                                TextField("Enter your password", text: $password)
                            }
                            
                            Button(action: {
                                isSecure.toggle()
                            }) {
                                Image(systemName: isSecure ? "eye.slash" : "eye")
                                    .foregroundColor(.secondary)
                            }
                            .padding(.trailing, 8)
                        }
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    
                    Button(action: {
                        handleAppleSignIn()
                    }) {
                        HStack {
                            Text("Sign up")
                                .font(.headline)
                                .fontWeight(.medium)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Color.blue)
                        .cornerRadius(12)
                    }
                    .disabled(isAppleSignUp)
                    .opacity(isAppleSignUp ? 0.6 : 1.0)
                }
                .padding(.horizontal, 24)
                
                Divider().padding(.vertical, 20)
                
                VStack(spacing: 16) {
                    // Apple Sign In
                    Button(action: {
                        handleAppleSignIn()
                    }) {
                        HStack {
                            Image(systemName: "apple.logo")
                                .font(.title3)
                            Text("Continue with Apple")
                                .font(.headline)
                                .fontWeight(.medium)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Color.black)
                        .cornerRadius(12)
                    }
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
                        .frame(height: 56)
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
                        .frame(height: 56)
                        .background(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                        .cornerRadius(12)
                    }
                    .disabled(isMicrosoftSignUp)
                    .opacity(isMicrosoftSignUp ? 0.6 : 1.0)
                }
                .padding(.horizontal, 24)
            }
        }
    }
    
    private func handleAppleSignIn() -> Void {
        
    }
    
    private func handleGoogleSignIn() ->  Void {
        
    }
    
    private func handleMicrosoftSignIn() -> Void {
        
    }
    
    private func isFormValid() -> Bool {
        return (
            form.manager.allValid &&
            isMinLength &&
            upperChar &&
            lowerChar &&
            number &&
            special
        )
    }
    
    private func validatePassword() {
        isMinLength = password.count >= 12
        upperChar = password.range(of: "[A-Z]", options: .regularExpression) != nil
        lowerChar = password.range(of: "[a-z]", options: .regularExpression) != nil
        number = password.range(of: "[0-9]", options: .regularExpression) != nil
        special = password.range(of: "[!@#$%^&*]", options: .regularExpression) != nil
    }
}



#Preview {
    RegisterPanel()
}
