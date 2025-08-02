//
//  VerificationPanel.swift
//  Budj.It
//
//  Created by Rowe, Apollinari on 8/1/25.
//

import SwiftUI
import Amplify

//TODO: add a source router
struct VerificationPanel: View {
    @State private var verificationCode = ""
    @State private var isLoading = false
    @State private var showSuccess = false
    @State private var navigateToHome = false
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var form: AuthForm
    
    var body: some View {
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
                Text("Complete")
                    .font(.headline)
                    .fontWeight(.medium)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .background(Color.blue)
            .cornerRadius(12)
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
                if confirmResult.isSignUpComplete {
                    await MainActor.run {
                        isLoading = false
                    }
                }
            } catch {
                //TODO: do something with the errors
            }
        }
    }
}

#Preview {
    @Previewable @StateObject var form = AuthForm()
    
    VerificationPanel().environmentObject(form)
}
