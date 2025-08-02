//
//  AuthContainer.swift
//  Budj.It
//
//  Created by Rowe, Apollinari on 7/31/25.
//

import SwiftUI

struct AuthContainer: View {
    @State private var showSignIn = false
    
    var body: some View {
        NavigationView {
            VStack(){
                Text("Welcome to Budj.It")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Spacer()
                VStack(spacing: 24) {
                    NavigationLink(destination: RegisterPanel()) {
                        Text("Register")
                            .font(.title2)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.blue)
                            .foregroundColor(.white)
                            .cornerRadius(20)
                    }
                    NavigationLink(destination: LoginPanel()) {
                        Text("Login")
                            .font(.title2)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.green)
                            .foregroundColor(.white)
                            .cornerRadius(20)
                    }
                }
                .padding(.horizontal)
            }
            .padding(EdgeInsets(top: 40, leading: 0, bottom: 40, trailing: 0))
            
        }
    }
}


#Preview {
    AuthContainer()
}
