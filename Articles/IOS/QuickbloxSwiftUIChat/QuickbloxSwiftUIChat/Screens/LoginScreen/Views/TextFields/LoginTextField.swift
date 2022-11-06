//
//  LoginTextField.swift
//  QuickbloxSwiftUIChat
//
//  Created by Injoit.
//

import SwiftUI

struct LoginTextField : View {
    
    @State var login: String = ""
    @Binding var isValidLogin: Bool
    
    var body: some View {
        return BaseTextField(isSecure: false,
                             textFieldName: "Login",
                             invalidTextHint: Hint.login.rawValue,
                             regexes: [Regex.login, Regex.email],
                             text: $login,
                             isValidText: $isValidLogin)
    }
}
