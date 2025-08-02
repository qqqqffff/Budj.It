//
//  SignUpNameView.swift
//  Budj.It
//
//  Created by Rowe, Apollinari on 7/31/25.
//

import SwiftUI
import Amplify

struct RegisterNameView: View {
    @EnvironmentObject var form: AuthForm
    @EnvironmentObject var authManager: AuthManager
    
    @State private var isLoading = false
    @State private var navigateToVerification = false
    @State private var navigateToLogin = false
    @State private var errorMessage = ""
    @State private var signUpResult: AuthSignUpResult?
    
    @State private var authError: AuthError?
    @State private var unexpectedError: Error?
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 5) {
                Image(systemName: "lock.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 80)
                    .foregroundColor(.blue)
                Text("Authentication")
                    .font(.title)
                    .fontWeight(.bold)
                Text("For authentication purposes we require your\nlegal first and last name")
                    .font(.footnote)
                    .italic()
                    .multilineTextAlignment(.center)
            }
            .padding(.bottom, 15)
            VStack(alignment: .leading, spacing: 4) {
                Text("First Name")
                    .font(.headline)
                    .fontWeight(.medium)
                    .padding(.leading, 5)
                
                TextField("Enter your legal first name", text: $form.firstName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.default)
                    .autocapitalization(.words)
                    .disableAutocorrection(true)
                    .validation(form.firstNameValidation)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Last Name")
                    .font(.headline)
                    .fontWeight(.medium)
                    .padding(.leading, 5)
                
                TextField("Enter your legal last name", text: $form.lastName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.default)
                    .autocapitalization(.words)
                    .disableAutocorrection(true)
                    .validation(form.lastNameValidation)
            }
            .padding(.bottom, 20)
            
            Button(action: {
                handleSignUp()
            }) {
                if isLoading {
                    ProgressView()
                        .scaleEffect(0.8)
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                }
                else {
                    Text("Continue")
                        .font(.headline)
                        .fontWeight(.medium)
                }
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .background(Color.blue)
            .cornerRadius(12)
            .disabled(!isFormValid())
            .opacity(!isFormValid() ? 0.6 : 1.0)
            .navigationDestination(
                isPresented: $navigateToVerification,
                destination: {
                    VerificationPanel()
                        .environmentObject(form)
                }
            )
            .navigationDestination(
                isPresented: $navigateToLogin,
                destination: {
                    LoginPanel()
                }
            )
        }
        .padding(EdgeInsets(top: 0, leading: 20, bottom: 60, trailing: 20))
        .navigationBarBackButtonHidden()
    }
    
    func isFormValid() -> Bool {
        return (
            form.nameManager.allValid
        )
    }
    
    private func handleSignUp() {
        isLoading = true
        Task {
            do {
                signUpResult = try await authManager.signUp(
                    email: form.email,
                    password: form.password,
                    firstName: form.firstName,
                    lastName: form.lastName
                )
                guard let result = signUpResult
                else {
                    errorMessage = "Registration failed, please try again."
                    return
                }
                
                if result.isSignUpComplete {
                    let signInResult = try await authManager.signIn(
                        username: form.email,
                        password: form.password
                    )
                    
                    guard let res = signInResult
                    else {
                        errorMessage = "Failed to login, please try again."
                        return
                    }
                    
                    if res.isSignedIn {
                        await MainActor.run {
                            isLoading = false
                            navigateToVerification = true
                        }
                    }
                    else {
                        //TODO: do something
                    }
                    
                }
            } catch let error as AuthError {
                authError = error
            } catch {
                unexpectedError = error
            }
        }
        
        
    }
}

#Preview {
    @Previewable @StateObject var form = AuthForm()
//    @Previewable @StateObject var manager = AuthManager()
    
    RegisterNameView()
        .environmentObject(form)
//        .environmentObject(manager)
}
