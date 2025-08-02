//
//  CustomSecureField.swift
//  Budj.It
//
//  Created by Rowe, Apollinari on 7/25/25.
//

import SwiftUI

struct CustomSecureField: View {
    let placeholder: String
    @Binding var text: String
    @State var showText: Bool = false
    
    private enum Focus {
        case secure, text
    }
    
    @FocusState private var focus: Focus?
    @Binding var isFocused: Bool
    
    @Environment(\.scenePhase)
    var scenePhase
    
    var body: some View {
        HStack {
            ZStack(alignment: .trailing) {
                Group {
                    SecureField(placeholder, text: $text)
                        .focused($focus, equals: .secure)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .opacity(showText ? 0 : 1)
                    TextField(placeholder, text: $text)
                        .focused($focus, equals: .text)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .opacity(showText ? 1 : 0)
                }
                .textFieldStyle(RoundedBorderTextFieldStyle())
                Button(action: {
                    showText.toggle()
                }) {
                    Image(systemName: showText ? "eye.slash" : "eye")
                        .foregroundStyle(.black.opacity(0.7))
                }
                .padding(.trailing, 8)
            }
        }
        .onChange(of: focus) {
            if focus != nil {
                focus = showText ? .text : .secure
            }
            isFocused = focus != nil
        }
        .onChange(of: scenePhase) {
            if scenePhase != .active {
                showText = false
            }
        }
        .onChange(of: showText) {
            if focus != nil {
                DispatchQueue.main.async {
                    focus = showText ? .text : .secure
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var password = ""
    @Previewable @State var focused = false
    
    CustomSecureField(
        placeholder: "Enter your password",
        text: $password,
        isFocused: $focused
    )
}
