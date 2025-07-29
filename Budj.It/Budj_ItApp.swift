//
//  Budj_ItApp.swift
//  Budj.It
//
//  Created by Apollo Rowe on 7/13/25.
//

import SwiftUI
import SwiftData
import Amplify
import Authenticator
import AWSAPIPlugin
import AWSCognitoAuthPlugin
import AuthenticationServices

@main
struct Budj_ItApp: App {
    init() {
        let appleIdProvider = ASAuthorizationAppleIDProvider()
        appleIdProvider.getCredentialState(forUserID: KeychainItem.currentUserIdentifier) { (credentialState, error) in
            switch credentialState {
                case .authorized:
                    break
                case .revoked, .notFound:
                    //TODO: reroute to login screen
                    break
                default:
                    //TODO: do something
                    break
            }
        }
        let awsApiPlugin = AWSAPIPlugin(modelRegistration: AmplifyModels())
    
        do {
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            try Amplify.add(plugin: awsApiPlugin)
            try Amplify.configure(with: .amplifyOutputs)
        } catch {
            print("Unable to configure Amplify \(error)")
        }
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
