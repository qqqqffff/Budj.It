//
//  HomeContainer.swift
//  Budj.It
//
//  Created by Rowe, Apollinari on 7/28/25.
//

import SwiftUI

struct HomeContainer: View {
    @EnvironmentObject var profileService: UserProfileService
    @EnvironmentObject var authManager: AuthManager
    
    var body: some View {
        Text("Hello World")
            .navigationBarBackButtonHidden()
    }
}

#Preview {
    HomeContainer()
}
