//
//  ContentView.swift
//  Budj.It
//
//  Created by Apollo Rowe on 7/13/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @StateObject private var userProfileService = UserProfileService()
    @StateObject private var authManager = AuthManager()
    
    var body: some View {
        if authManager.isLoading {
            VStack {
                ProgressView()
                    .scaleEffect(1.5)
                Text("Loading...")
                    .padding(.top)
            }
        } else if authManager.isSignedIn {
            HomeContainer()
                .environmentObject(authManager)
                .environmentObject(userProfileService)
        } else {
            AuthContainer()
                .environmentObject(authManager)
                .environmentObject(userProfileService)
        }
    }
}

#Preview {
    ContentView()
}
