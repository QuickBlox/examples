//
//  LoginTextField.swift
//  QuickbloxSwiftUIChat
//
//  Created by Injoit.
//

import SwiftUI

struct LoginTextField : View {
    
    @State private var login: String = "" {
        didSet {
            isValidLogin = login.isValid(regexes: [Regex.login, Regex.email].compactMap { "\($0.rawValue)" })
            loginHint = isValidLogin ? "" : Hint.login.rawValue
        }
    }
    @State private var loginHint: String = ""
    @Binding var isValidLogin: Bool
    @Binding var isFocused: Bool?
    
    var body: some View {
        return VStack(alignment: .leading, spacing: 11) {
            TextFieldName(name: "Login")
            
            TextField("", text: $login, onEditingChanged: {isEdit in
                isFocused = isEdit
            })
            .accentColor(.blue)
            .onChange(of: login, perform: { newValue in
                self.login = newValue
            })
            .font(.system(size: 17, weight: .thin))
            .foregroundColor(.primary)
            .disableAutocorrection(true)
            .autocapitalization(.none)
            .frame(height: 44)
            .padding(.horizontal, 12)
            .background(Color.white)
            .cornerRadius(4.0)
            .shadow(color: isFocused == true ? .blue.opacity(0.2) : .blue.opacity(0.1),
                    radius: 4, x: 0, y: 8)
            
            TextFieldHint(hint: loginHint)
        }
    }
}
