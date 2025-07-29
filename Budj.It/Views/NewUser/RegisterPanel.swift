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
    @State private var isSignUp = false;
    @State private var isAppleSignUp = false;
    @State private var isMicrosoftSignUp = false;
    @State private var isGoogleSignUp = false;
    @State private var displayMoreSignUpOptions = false;
    @State private var password = "";
    @State private var passwordFocused = false
    
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
                        
                        CustomSecureField(
                            placeholder: "Enter your password",
                            text: $password,
                            isFocused: $passwordFocused
                        )
                    }
                    .onChange(of: password) {
                        validatePassword()
                    }
                    
                    if !password.isEmpty && passwordFocused {
                        VStack(alignment: .leading) {
                            Text("Your password must include:")
                                .font(.subheadline)
                                .padding(EdgeInsets(top: -10, leading: 0, bottom: 3, trailing: 0))
                            HStack(alignment: .top, spacing: 10){
                                VStack(alignment: .leading, spacing: 2) {
                                    PasswordRequirementComponent(text: "At least 8 characters", isValid: isMinLength)
                                    PasswordRequirementComponent(text: "One number", isValid: number)
                                }
                                VStack(alignment: .leading, spacing: 2) {
                                    PasswordRequirementComponent(text: "One uppercase letter", isValid: upperChar)
                                    PasswordRequirementComponent(text: "One lowercase letter", isValid: lowerChar)
                                }
                                Spacer()
                            }
                            PasswordRequirementComponent(text: "One special character i.e: '!@#$%^&*'", isValid: special)
                        }
                    }
                    
                    Button(action: {
                        isSignUp = true
                        Task {
                            await handleSignUp()
                        }
                    }) {
                        HStack {
                            if !isSignUp {
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
                    .disabled(!isFormValid() || isSignUp)
                    .opacity(!isFormValid() || isSignUp ? 0.6 : 1.0)
                }
                .padding(.horizontal, 24)
                
                Divider().padding(.vertical, 20)
                
                VStack(spacing: 16) {
                    // Apple Sign In
                    SignInWithAppleButton(
                        .signUp,
                        onRequest: { request in
                            request.requestedScopes = [.fullName, .email]
                            isAppleSignUp.toggle()
                        },
                        onCompletion: { result in
                            switch result {
                            case .success(let authorization):
                                handleAppleSignUp(authorization: authorization)
                            default:
                                //TODO: do something with the failure
                                break
                            }
                        }
                    )
                    .signInWithAppleButtonStyle(.black)
                    .frame(height: 56)
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
    
    private func handleAppleSignUp(authorization: ASAuthorization) async throws -> Void {
        if let appleIdCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let userId = appleIdCredential.user
            let fullName = appleIdCredential.fullName
            let email = appleIdCredential.email
            
            print("User ID: \(userId)")
            print("Full Name: \(String(describing: fullName))")
            print("Email: \(String(describing: email))")
            
            
            guard let token = appleIdCredential.identityToken
            else {
                throw AuthError.missingIdentityToken
            }
            
            appleFederateToIdentityPool(with: token)
        }
    }
    
    private func handleGoogleSignIn() ->  Void {
        
    }
    
    private func handleMicrosoftSignIn() -> Void {
        
    }
    
    private func handleSignUp() async -> Void {
        let userAttributes = [
            AuthUserAttribute(.email, value: form.email)
        ]
        let options = AuthSignUpRequest.Options(userAttributes: userAttributes)
        
        do {
            let signUpResult = try await Amplify.Auth.signUp(
                username: form.email,
                password: password,
                options: options
            )
            
            if case let .confirmUser(deliveryDetails, _, userId) = signUpResult.nextStep {
                print("Delivery details \(String(describing: deliveryDetails)) for userId: \(String(describing: userId))")
            }
            else {
                print("Signup Complete")
            }
        } catch let error as AuthError {
            print("An error occured during user registration \(error)")
        } catch {
            print("Unexpected error: \(error)")
        }
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
        isMinLength = password.count >= 8
        upperChar = password.range(of: "[A-Z]", options: .regularExpression) != nil
        lowerChar = password.range(of: "[a-z]", options: .regularExpression) != nil
        number = password.range(of: "[0-9]", options: .regularExpression) != nil
        special = password.range(of: "[!@#$%^&*]", options: .regularExpression) != nil
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
    RegisterPanel()
}
