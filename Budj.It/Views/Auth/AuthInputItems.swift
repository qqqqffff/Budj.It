//
//  InputItems.swift
//  Budj.It
//
//  Created by Rowe, Apollinari on 9/10/25.
//

import SwiftUI
import Amplify

struct AuthInputItems: View {
    @EnvironmentObject var form: AuthInputForm
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var errorMessage: ErrorObject
    
    @State private var isMinLength = false;
    @State private var upperChar = false;
    @State private var lowerChar = false;
    @State private var number = false;
    @State private var special = false;
    
    @State private var passwordFocused = false
    
    @FocusState private var emailFocused: Bool
    
    @State private var navigateToHome = false
    
    let login: Bool
    
    
    init(
        login: Bool = false
    ) {
        self.login = login
    }
    
    var body: some View {
        ZStack {
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
                        .focused($emailFocused)
                        .onChange(of: emailFocused) {
                            if !emailFocused {
                                let _ = form.emailManager.triggerValidation()
                            }
                        }
                }
                
                // Password Field
                VStack(alignment: .leading, spacing: 4) {
                    Text("Password")
                        .font(.headline)
                        .fontWeight(.medium)
                        .padding(.leading, 5)
                    
                    CustomSecureField(
                        placeholder: "Enter your password",
                        text: $form.password,
                        isFocused: $passwordFocused
                    )
                }
                .onChange(of: form.password) {
                    validatePassword()
                }
                
                if !form.password.isEmpty && passwordFocused && !login {
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
                
                if login {
                    Button(action: {
                        Task {
                            do {
                                let result = try await authManager.signIn(
                                    username: form.email,
                                    password: form.password
                                )
                                
                                guard let signInResult = result
                                else {
                                    //TODO: do something with error
                                    return
                                }
                                
                                if signInResult.isSignedIn {
                                    
                                } else {
                                    let signInStep = signInResult.nextStep
                                    //TODO: handle different cases in switch case
                                    switch  signInStep{
                                    case .confirmSignInWithCustomChallenge(let additionalInfo):
                                        print(additionalInfo ?? "No Aditional Info")
                                        break
                                    case .confirmSignInWithPassword:
                                        break
                                    case .confirmSignInWithOTP(let deliveryDetails):
                                        print(deliveryDetails)
                                        break
                                    case .confirmSignInWithNewPassword(let additionalInfo):
                                        print(additionalInfo ?? "No Aditional Info")
                                        break
                                    case .confirmSignInWithSMSMFACode(let deliveryDetails, let additionalInfo):
                                        print(additionalInfo ?? "No Aditional Info")
                                        print(deliveryDetails)
                                        break
                                    default:
                                        break
                                    }
                                }
                            } catch let error as AuthError {
                                print(error)
                                
                                switch error.errorDescription.localizedLowercase {
                                default:
                                    errorMessage.message = "Unexpected Error Occurred\nTry again later."
                                    break
                                }
                            }
                        }
                    }) {
                        HStack {
                            Text("Login")
                                .font(.headline)
                                .fontWeight(.medium)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .background(Color.blue)
                        .cornerRadius(12)
                    }
                    .disabled(!isFormValid())
                    .opacity(!isFormValid() ? 0.6 : 1.0)
                }
                else {
                    NavigationLink(destination: {
                        RegisterNameView()
                            .environmentObject(form)
                            .environmentObject(authManager)
                    }) {
                        HStack {
                            Text("Sign Up")
                                .font(.headline)
                                .fontWeight(.medium)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .background(Color.blue)
                        .cornerRadius(12)
                    }
                    .disabled(!isFormValid())
                    .opacity(!isFormValid() ? 0.6 : 1.0)
                }
            }
            .padding(.horizontal, 24)
        }
        .navigationDestination(
            isPresented: $navigateToHome,
            destination: {
                HomeContainer()
                    .environmentObject(authManager)
            }
        )
    }
    
    private func isFormValid() -> Bool {
        return (
            form.emailManager.allValid &&
            isMinLength &&
            upperChar &&
            lowerChar &&
            number &&
            special
        )
    }
    
    private func validatePassword() {
        isMinLength = form.password.count >= 8
        upperChar = form.password.range(of: "[A-Z]", options: .regularExpression) != nil
        lowerChar = form.password.range(of: "[a-z]", options: .regularExpression) != nil
        number = form.password.range(of: "[0-9]", options: .regularExpression) != nil
        special = form.password.range(of: "[!@#$%^&*]", options: .regularExpression) != nil
    }
}

#Preview {
    @Previewable @StateObject var manager = AuthManager()
    @Previewable @StateObject var form = AuthInputForm()
    @Previewable @StateObject var errorObject = ErrorObject()
    
    NavigationStack {
        AuthInputItems(login: true)
            .environmentObject(manager)
            .environmentObject(form)
            .environmentObject(errorObject)
    }
}
