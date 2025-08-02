//
//  UserProfileService.swift
//  Budj.It
//
//  Created by Rowe, Apollinari on 7/28/25.
//

import Amplify
import Foundation

class UserProfileService: ObservableObject {
    @Published var userProfile: UserProfile?
    
    //TODO: do something with the errors
    func getUserProfile(owner: String) async {
        do {
            let result = try await Amplify.API.query(
                request: .get(UserProfile.self, byId: owner)
            )
            switch result {
                case .success(let profile):
                    guard let userProfile = profile else {
                        print("Could not find userprofile")
                        break;
                    }
                    self.userProfile = userProfile
                    break;
                case .failure(let error):
                    print("Got failed result with \(error)")
                    break;
            }
        } catch let error as APIError {
            print("Failed to query user profile: \(error)")
        } catch {
            print("Unexpected error: \(error)")
        }
    }
}
