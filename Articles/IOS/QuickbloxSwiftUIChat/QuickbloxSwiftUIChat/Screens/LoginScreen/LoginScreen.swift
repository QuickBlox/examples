//
//  LoginScreen.swift
//  QuickbloxSwiftUIChat
//
//  Created by Injoit.
//

import SwiftUI

enum Hint: String {
    case login = "Use your email or alphanumeric characters in a range from 3 to 50. First character must be a letter."
    case password = "Use alphanumeric characters in a range from 8 to 12. First character must be a letter."
}

enum Regex: String {
    case login = "^[a-zA-Z][a-zA-Z0-9]{2,49}$"
    case email = "^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,49}$"
    case password = "^[a-zA-Z][a-zA-Z0-9]{7,11}$"
}

struct LoginScreen: View {
    
    @State private var isValidLogin: Bool = false
    @State private var isValidPassword: Bool = false
    @State private var isFocused: Bool?
    
    init() {
        setupNavigationBarAppearance(titleColor: UIColor.white, barColor: UIColor(.blue))
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 28) {
                
                InfoText().padding(.top, 44)
                
                LoginTextField(isValidLogin: $isValidLogin, isFocused: $isFocused)
                
                PasswordTextField(isValidPassword: $isValidPassword, isFocused: $isFocused)
                
                LoginButton(isValidLogin: $isValidLogin, isValidPassword: $isValidPassword)
                
                Spacer()
            }
            .padding()
            .background(.secondary.opacity(0.1))
            .navigationBarTitle("Enter to chat", displayMode: .inline)
        }
    }
}

struct LoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreen()
    }
}

struct InfoText: View {
    var body: some View {
        return Text("Enter your login and password")
            .font(.system(size: 16, weight: .light))
            .foregroundColor(.primary)
    }
}
