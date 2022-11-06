//
//  PasswordTextField.swift
//  QuickbloxSwiftUIChat
//
//  Created by Injoit.
//

import SwiftUI

struct PasswordTextField : View {
    
    @State var password: String = ""
    @Binding var isValidPassword: Bool
    
    var body: some View {
        return BaseTextField(isSecure: true,
                             textFieldName: "Password",
                             invalidTextHint: Hint.password.rawValue,
                             regexes: [Regex.password],
                             text: $password,
                             isValidText: $isValidPassword)
    }
}
