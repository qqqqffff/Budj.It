//
//  IdentityPoolFederation.swift
//  Budj.It
//
//  Created by Rowe, Apollinari on 7/28/25.
//

import Amplify
import Foundation
import AWSCognitoAuthPlugin

enum AuthError: Error {
    case missingIdentityToken;
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
