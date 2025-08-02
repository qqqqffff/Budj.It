//
//  VerificationCodeInput.swift
//  Budj.It
//
//  Created by Rowe, Apollinari on 8/1/25.
//

import SwiftUI

struct VerificationCodeInput: View {
    @Binding var code: String
    let digitCount: Int = 6
    @State private var digits: [String]
    @FocusState private var focusedField: Int?
    
    init(code: Binding<String>) {
        self._code = code
        self._digits = State(initialValue: Array(repeating: "", count: 6))
    }
    
    var body: some View {
        HStack(spacing: 12) {
            ForEach(0..<digitCount, id: \.self) { index in
                TextField("", text: $digits[index])
                    .frame(width: 45, height: 55)
                    .multilineTextAlignment(.center)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(digits[index].isEmpty ? Color.gray.opacity(0.3) : Color.blue, lineWidth: 2)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(.systemGray6))
                            )
                    )
                    .keyboardType(.numberPad)
                    .focused($focusedField, equals: index)
                    .onChange(of: digits[index]) {
                        handleDigitChange(at: index, newValue: digits[index])
                    }
                    .onTapGesture {
                        focusedField = index
                    }
            }
        }
        .onAppear {
            focusedField = 0
        }
    }
    
    private func handleDigitChange(at index: Int, newValue: String) {
        if newValue.count > 1 {
            let fill = newValue.split(separator: "", maxSplits: digitCount - index)
            
            fill.enumerated().forEach { jindex, char in
                digits[index + jindex] = char.base
            }
            
        } else if newValue.count == 1 && newValue.isNumber {
            digits[index] = newValue
            
            if index < digitCount - 1 {
                focusedField = index + 1
            } else {
                focusedField = nil
            }
        } else if newValue.isEmpty {
            digits[index] = ""
            
            if index > 0 {
                focusedField = index - 1
            }
        }
        
        code = digits.joined()
    }
}

extension String {
    var isNumber: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
}

#Preview {
    @Previewable @State var code = ""
    VerificationCodeInput(code: $code)
}
