//
//  VerificationPanel.swift
//  Budj.It
//
//  Created by Rowe, Apollinari on 8/1/25.
//

import SwiftUI
import Amplify

struct VerificationPanel: View {
    @State private var verificationCode = ""
    @State private var isLoading = false
    @State private var showSuccess = false
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var form: AuthInputForm
    @State private var errorMessage: String?
    
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                VStack(spacing: 5) {
                    Image(systemName: showSuccess ? "checkmark.circle" : "lock.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 80, height: 80)
                        .foregroundColor(showSuccess ? .green : .blue)
                        .contentTransition(
                            .symbolEffect(
                                .replace.magic(fallback: .upUp.byLayer),
                                options: .nonRepeating,
                            ),
                        )
                    if showSuccess {
                        Text("Account Verified!")
                            .font(.title)
                            .fontWeight(.bold)
                    } else {
                        Text("Verify Your Account")
                            .font(.title)
                            .fontWeight(.bold)
                        Text("A verification code was sent to:\n\(form.email)")
                            .font(.callout)
                            .italic()
                            .multilineTextAlignment(.center)
                    }
                }
                .padding(.bottom, 10)
                
                VerificationCodeInput(code: $verificationCode)
                    .padding(.bottom, 10)
                
                Button(action: {
                    confirmSignUp()
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
                .padding(.horizontal, 16)
            }
            .padding(EdgeInsets(top: 0, leading: 20, bottom: 60, trailing: 20))
            .navigationBarBackButtonHidden()
            .onChange(of: verificationCode) {
                if verificationCode.count == 6 && !isLoading {
                    confirmSignUp()
                }
            }
            
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
        }
        .animation(.easeInOut(duration: 0.3), value: errorMessage != nil)
    }
    
    func isFormValid() -> Bool {
        return (
            verificationCode.count == 6
        )
    }
    
    func confirmSignUp() -> Void {
        isLoading = true
        
        Task {
            do {
                let confirmResult = try await authManager.confirmSignUp(
                    username: form.email,
                    confirmationCode: verificationCode
                )
                print(confirmResult)
            } catch let error as AuthError {
                //TODO: error handle
                switch error.errorDescription {
                    case "Username is required to signUp":
                        errorMessage = "Email is required for sign up"
                        break
                    default:
                        errorMessage = "Unexpected Error Occured.\nPlease try again later."
                        break
                }
                print(error)
            }
        }
        
        isLoading = false
    }
    
}

#Preview {
    @Previewable @StateObject var form = ({
        var form = AuthInputForm()
        form.email = "test@test.com"
        return form
    })()
    @Previewable @StateObject var service = UserProfileService()
    @Previewable @StateObject var auth = AuthManager()
    
    VerificationPanel()
        .environmentObject(form)
        .environmentObject(auth)
        .environmentObject(service)
}
