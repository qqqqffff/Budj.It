//
//  WelcomeHeader.swift
//  Budj.It
//
//  Created by Rowe, Apollinari on 9/10/25.
//

import SwiftUI

struct AuthWelcomeHeader: View {
    let login: Bool
    
    init(
        login: Bool = false
    ) {
        self.login = login
    }
    
    var body: some View {
        VStack {
            Image(systemName: "person.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80, height: 80)
                .foregroundColor(.blue)
                .padding(.bottom, 16)
            
            Text(login ? "Welcome Back" : "Create Account")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 8)
            
            Text(login ? "Login to continue" : "Register to get started")
                .font(.body)
                .foregroundColor(.secondary)
        }
        .padding(.top, 32)
        .padding(.bottom, 25)
    }
}
