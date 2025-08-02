//
//  ContentView.swift
//  Budj.It
//
//  Created by Apollo Rowe on 7/13/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @StateObject private var authManager = AuthManager()
    @StateObject private var userProfileService = UserProfileService()
    
    var body: some View {
        Group {
            if authManager.isLoading {
                VStack {
                    ProgressView()
                        .scaleEffect(1.5)
                    Text("Loading...")
                        .padding(.top)
                }
            } else if authManager.isSignedIn {
                HomeContainer()
            } else {
                AuthContainer()
            }
        }
    }
}

#Preview {
    ContentView()
}
