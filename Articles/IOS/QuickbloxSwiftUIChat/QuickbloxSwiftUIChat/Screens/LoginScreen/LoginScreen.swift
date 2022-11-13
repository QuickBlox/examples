//
//  LoginScreen.swift
//  QuickbloxSwiftUIChat
//
//  Created by Injoit.
//

import SwiftUI
import Quickblox

struct LoginConstant {
    static let enterToChat = "Enter to chat"
    static let fullNameDidChange = "Full Name Did Change"
    static let signUp = "Signg up ..."
    static let intoChat = "Login into chat ..."
    static let withCurrentUser = "Login with current user ..."
    static let enterUsername = "Enter your login and display name"
    static let noInternetConnection = "No Internet Connection"
}

enum Hint: String {
    case login = "Use your email or alphanumeric characters in a range from 3 to 50. First character must be a letter."
    case displayName = "Use alphanumeric characters and spaces in a range from 3 to 20. Cannot contain more than one space in a row."
    case password = "Use alphanumeric characters in a range from 8 to 12. First character must be a letter."
}

enum Regex: String {
    case login = "^[a-zA-Z][a-zA-Z0-9]{2,49}$"
    case email = "^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,49}$"
    case displayName = "^(?=.{3,20}$)(?!.*([\\s])\\1{2})[\\w\\s]+$"
    case password = "^[a-zA-Z][a-zA-Z0-9]{7,11}$"
}

struct LoginScreen: View {
    
    @State private var login: String = ""
    @State private var password: String = ""
    @State private var displayName: String = ""
    
    @State private var isValidLogin: Bool = false
    @State private var isValidPassword: Bool = false
    @State private var isValidDisplayName: Bool = false
    
    @State private var loginInfo = LoginConstant.enterUsername
    @State private var isLoggedSuccess: Bool = false
    
    private let authModule = AuthModule()
    
    init() {
        setupNavigationBarAppearance(titleColor: UIColor.white, barColor: UIColor(.blue))
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 18) {
                
                InfoText(loginInfo: $loginInfo).padding(.top, 44)
                
                LoginTextField(login: $login,
                               isValidLogin: $isValidLogin)
                
                DisplayNameTextField(displayName: $displayName,
                                     isValidDisplayName: $isValidDisplayName)
                
                PasswordTextField(password: $password,
                                  isValidPassword: $isValidPassword)
                
                LoginButton(isValidLogin: $isValidLogin,
                            isValidPassword: $isValidPassword,
                            isValidDisplayName: $isValidDisplayName,
                            onTapped: {
                    authModule.enterToChat(fullName: displayName,
                                           login: login,
                                           password: password) { error in
                        if let error = error {
                            self.handleError(error)
                            return
                        }
                        //did Login action
                        self.isLoggedSuccess = true
                    }
                })
                
                NavigationLink(isActive: $isLoggedSuccess) {
                    DialogsView()
                } label: {}.hidden()
                
                Spacer()
            }
            .padding()
            .background(.secondary.opacity(0.1))
            .navigationBarTitle(LoginConstant.enterToChat, displayMode: .inline)
        }
    }
    
    //MARK: - Internal Methods
    private func defaultConfiguration() {
        displayName = ""
        login = ""
        password = ""
        isValidLogin = false
        isValidPassword = false
        isValidDisplayName = false
        loginInfo = LoginConstant.enterUsername
        isLoggedSuccess = false
    }
    
    private func handleError(_ error: Error) {
        var infoText = error.localizedDescription
        if error._code == QBResponseStatusCode.unAuthorized.rawValue {
            defaultConfiguration()
        } else if error.isNetworkError == true {
            infoText = LoginConstant.noInternetConnection
        }
        loginInfo = infoText
    }
}

struct LoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreen()
    }
}

struct InfoText: View {
    
    @Binding var loginInfo: String
    
    var body: some View {
        return Text(loginInfo)
            .font(.system(size: 16, weight: .light))
            .foregroundColor(.primary)
    }
}
