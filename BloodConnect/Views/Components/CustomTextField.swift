//
//  CustomTextField.swift
//  BloodConnect
//
//  Created by Sanidhya Pandey on 14/03/2025.
//

import SwiftUI

struct CustomTextField: View {
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    var icon: String? = nil
    
    @State private var isShowingPassword: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(placeholder)
                .font(Typography.caption)
                .fontWeight(.medium)
                .foregroundColor(.gray)
            
            HStack {
                // Leading icon
                if let iconName = icon {
                    Image(systemName: iconName)
                        .foregroundColor(.gray)
                        .padding(.leading, 12)
                }
                
                // Text field
                if isSecure && !isShowingPassword {
                    SecureField("", text: $text)
                        .placeholder(when: text.isEmpty) {
                            Text(placeholder).foregroundColor(.gray.opacity(0.6))
                        }
                        .padding(.vertical, 16)
                } else {
                    TextField("", text: $text)
                        .placeholder(when: text.isEmpty) {
                            Text(placeholder).foregroundColor(.gray.opacity(0.6))
                        }
                        .padding(.vertical, 16)
                }
                
                // Toggle password visibility for secure fields
                if isSecure {
                    Button(action: {
                        isShowingPassword.toggle()
                    }) {
                        Image(systemName: isShowingPassword ? "eye.fill" : "eye.slash.fill")
                            .foregroundColor(.gray)
                    }
                    .padding(.trailing, 12)
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
            )
        }
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
        
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        CustomTextField(placeholder: "Email", text: .constant(""), icon: "envelope.fill")
        CustomTextField(placeholder: "Password", text: .constant(""), isSecure: true, icon: "lock.fill")
    }
    .padding()
}
