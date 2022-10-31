//
//  PasswordTextField.swift
//  QuickbloxSwiftUIChat
//
//  Created by Injoit.
//

import SwiftUI

struct PasswordTextField : View {
    
    @State private var password: String = "" {
        didSet {
            isValidPassword = password.isValid(regexes: [Regex.password].compactMap { "\($0.rawValue)" })
            passwordHint = isValidPassword ? "" : Hint.password.rawValue
        }
    }
    @State private var passwordHint: String = ""
    @Binding var isValidPassword: Bool
    @Binding var isFocused: Bool?
    
    var body: some View {
        return VStack(alignment: .leading, spacing: 11) {
            TextFieldName(name: "Password")
            
            SecureField("", text: $password)
                .onChange(of: password, perform: { newValue in
                    self.password = newValue
                })
                .font(.system(size: 17, weight: .thin))
                .foregroundColor(.primary)
                .disableAutocorrection(true)
                .autocapitalization(.none)
                .frame(height: 44)
                .padding(.horizontal, 12)
                .background(Color.white)
                .cornerRadius(4.0)
                .shadow(color: isFocused == false ? .blue.opacity(0.2) : .blue.opacity(0.1),
                        radius: 4, x: 0, y: 8)
            
            TextFieldHint(hint: passwordHint)
        }
    }
}
