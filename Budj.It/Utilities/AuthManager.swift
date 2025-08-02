//
//  IdentityPoolFederation.swift
//  Budj.It
//
//  Created by Rowe, Apollinari on 7/28/25.
//

import Amplify
import Foundation
import AWSCognitoAuthPlugin
import SwiftUI

class AuthManager: ObservableObject {
    @Published var isSignedIn = false
    @Published var authUser: AuthUser?
    @Published var isLoading = true
    
    @EnvironmentObject var userProfileService: UserProfileService
    
    init() {
        checkAuthStatus()
    }
    
    
    func checkAuthStatus() {
        Task {
            do {
                let session = try await Amplify.Auth.fetchAuthSession()
                
                await MainActor.run {
                    self.isSignedIn = session.isSignedIn
                }
                
                if session.isSignedIn {
                    await fetchCurrentUser()
                }
            } catch {
                print("Failed to fetch auth session \(error)")
            }
        }
        self.isLoading = false
    }
    
    @MainActor
    func fetchCurrentUser() async {
        do {
            let user = try await Amplify.Auth.getCurrentUser()
            self.authUser = user
            await userProfileService.getUserProfile(owner: user.userId)
        } catch {
            print("Failed to fetch current user \(error)")
        }
    }
    
    func signUp(email: String, password: String, firstName: String, lastName: String) async throws -> AuthSignUpResult {
        let userAttributes = [
            AuthUserAttribute(.email, value: email),
            AuthUserAttribute(.familyName, value: lastName),
            AuthUserAttribute(.givenName, value: firstName),
        ]
        
        let options = AuthSignUpRequest.Options(userAttributes: userAttributes)
        
        let signUpResult = try await Amplify.Auth.signUp(
            username: email,
            password: password,
            options: options
        )
        
        return signUpResult
    }
    
    func confirmSignUp(username: String, confirmationCode: String) async throws -> AuthSignUpResult {
        let confirmSignUpResult = try await Amplify.Auth.confirmSignUp(
            for: username,
            confirmationCode: confirmationCode
        )
        
        
        return confirmSignUpResult
    }
    
    func signIn(username: String, password: String) async throws -> AuthSignInResult? {
        let signInResult = try await Amplify.Auth.signIn(
            username: username,
            password: password
        )
        
        if signInResult.isSignedIn {
            await fetchCurrentUser()
            await MainActor.run {
                self.isSignedIn = true
            }
            
            return nil
        }
        else {
            return signInResult
        }
    }
    
    func signOut() async throws {
        _ = await Amplify.Auth.signOut()
        
        await MainActor.run {
            self.isSignedIn = false
            self.authUser = nil
            userProfileService.userProfile = nil
        }
    }
    
    func appleFederateToIdentityPool(with token: Data) {
        guard
            let tokenString = String(data: token, encoding: .utf8),
            let plugin = try? Amplify.Auth.getPlugin(for: "awsCognitoAuthPlugin") as? AWSCognitoAuthPlugin
        else {
            return
        }

        Task {
            do {
                let result = try await plugin.federateToIdentityPool(
                    withProviderToken: tokenString,
                    for: .apple,
                )
                print(result)
            } catch {
                print(error)
            }
        }
    }
}
