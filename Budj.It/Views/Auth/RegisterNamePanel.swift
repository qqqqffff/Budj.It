//
//  SignUpNameView.swift
//  Budj.It
//
//  Created by Rowe, Apollinari on 7/31/25.
//

import SwiftUI
import Amplify

struct RegisterNameView: View {
    @EnvironmentObject var form: AuthInputForm
    @EnvironmentObject var authManager: AuthManager
    
    @State private var isLoading = false
    @State private var navigateToVerification = false
    @State private var navigateToLogin = false
    @State private var errorMessage: String?
    @State private var signUpResult: AuthSignUpResult?
    
    var currentScreen: Binding<AuthScreen>
        
    var body: some View {
        NavigationStack {
            ZStack {
                if errorMessage != nil {
                    VStack {
                        ErrorMessage(message: errorMessage!, onDismiss: {
                            withAnimation(.easeOut(duration: 0.3)) {
                                errorMessage = nil
                            }
                        })
                        .transition(.move(edge: .top).combined(with: .opacity))
                        
                        Spacer()
                    }
                    .zIndex(1)
                }
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
                        HStack {
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
                    }
                    .disabled(!isFormValid())
                    .opacity(!isFormValid() ? 0.6 : 1.0)
                }
                .navigationDestination(
                    isPresented: $navigateToVerification,
                    destination: {
                        VerificationPanel()
                            .environmentObject(form)
                            .environmentObject(authManager)
                    }
                )
                .navigationDestination(
                    isPresented: $navigateToLogin,
                    destination: {
                        LoginPanel(currentScreen: currentScreen)
                    }
                )
            }
        }
        .animation(.easeInOut(duration: 0.3), value: errorMessage != nil)
        .navigationBarBackButtonHidden()
        .padding(EdgeInsets(top: 0, leading: 20, bottom: 60, trailing: 20))
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
                // if sign up is complete attempt to auto sign in
                if result.isSignUpComplete {
                    let signInResult = try await authManager.signIn(
                        username: form.email,
                        password: form.password
                    )
                    
                    guard let res = signInResult
                    else {
                        errorMessage = "Failed to automatically login login, please try again."
                        navigateToLogin = true
                        return
                    }
                    
                    //if sigined in no action needed
                    if res.isSignedIn {
                        await MainActor.run {
                            isLoading = false
                        }
                        return
                    }
                    //else go to verification
                    else {
                        await MainActor.run {
                            isLoading = false
                            navigateToVerification = true
                        }
                    }
                }
                else {
                    await MainActor.run {
                        navigateToVerification = true
                    }
                }
            } catch let error as AuthError {
                switch error.errorDescription.lowercased() {
                    case "username is required to signup":
                        errorMessage = "Email is required for registration."
                        break;
//                    case "Unexpected error occurred with message: Received unknown error from service":
//                        errorMessage = "Unexpected Error Occurred. Please try again later."
//                        break;
                    default:
                        errorMessage = "Unexpected Error Occurred. Please try again later."
                        break;
                }
                print(error.errorDescription)
            } catch {
                print(error)
            }
        }
        
        isLoading = false
    }
}

#Preview {
    @Previewable @StateObject var form = AuthInputForm()
    @Previewable @StateObject var manager = AuthManager()
    @Previewable @StateObject var service = UserProfileService()
    @Previewable @State var currentScreen: AuthScreen = .register
    
    RegisterNameView(currentScreen: $currentScreen)
        .environmentObject(form)
        .environmentObject(manager)
        .environmentObject(service)
}
