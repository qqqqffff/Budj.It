//
//  ButtonDropdown.swift
//  Budj.It
//
//  Created by Rowe, Apollinari on 9/10/25.
//

import SwiftUI

struct ExpandableButtonDropdown<Content: View>: View {
    @State private var isExpanded = false
    
    let title: String
    let content: () -> Content
    let mainPadding: EdgeInsets
    let innerSpacing: CGFloat
    let innerPadding: EdgeInsets
    
    init(
        title: String = "Menu",
        @ViewBuilder content: @escaping () -> Content,
        mainPadding: EdgeInsets = EdgeInsets(top: 0, leading: 24, bottom: 0, trailing: 24),
        innerSpacing: CGFloat = 12,
        innerPadding: EdgeInsets = EdgeInsets(top: 12, leading: 32, bottom: 0, trailing: 32)
    ) {
        self.title = title
        self.content = content
        self.mainPadding = mainPadding
        self.innerSpacing = innerSpacing
        self.innerPadding = innerPadding
    }
    
    
    var body: some View {
        VStack(spacing: 0) {
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    isExpanded.toggle()
                }
            }) {
                HStack(spacing: 32) {
                    Text(title)
                        .font(.headline)
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .rotationEffect(.degrees(isExpanded ? -90 : 0))
                        .animation(.easeInOut(duration: 0.3), value: isExpanded)
                }
                .foregroundColor(.black)
                .padding(mainPadding)
                .background(Color.white)
                .padding(.leading, 50)
            }
            .padding(EdgeInsets(top: 8, leading: 4, bottom: 8, trailing: 4))
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke()
                    .background(.white)
            )
            .zIndex(1)
            if isExpanded {
                VStack(spacing: innerSpacing) {
                    content()
                }
                .padding(innerPadding)
                .transition(.opacity.combined(with: .move(edge: .top)))
                .zIndex(-1)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(mainPadding)
    }
}

#Preview {
    ExpandableButtonDropdown(
        title: "More Signup Options",
        content: {
            Button(action: {
                print("Test 1")
            }) {
                HStack {
                    Image(systemName: "square.grid.2x2.fill")
                        .font(.title3)
                        .foregroundColor(.blue)
                    Text("Test 1")
                        .font(.headline)
                        .fontWeight(.medium)
                        .foregroundColor(.black)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 48)
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
                .cornerRadius(12)
            }
            Button(action: {
                print("Test 2")
            }) {
                HStack {
                    Image(systemName: "square.grid.2x2.fill")
                        .font(.title3)
                        .foregroundColor(.blue)
                    Text("Test 2")
                        .font(.headline)
                        .fontWeight(.medium)
                        .foregroundColor(.black)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 48)
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
                .cornerRadius(12)
            }
            Button(action: {
                print("Test 3")
            }) {
                HStack {
                    Image(systemName: "square.grid.2x2.fill")
                        .font(.title3)
                        .foregroundColor(.blue)
                    Text("Test 3")
                        .font(.headline)
                        .fontWeight(.medium)
                        .foregroundColor(.black)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 48)
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
                .cornerRadius(12)
            }
        },
        mainPadding: EdgeInsets(top: 0, leading: 32, bottom: 0, trailing: 32),
    )
}
