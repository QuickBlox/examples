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
                
                Button {
                    signUp(fullName: displayName, login: login, password: password)
                } label: {
                    Text("Login")
                        .foregroundColor(.white)
                        .font(.system(size: 18))
                        .frame(width: 215, height: 44, alignment: .center)
                }
                .disabled((isValidLogin && isValidPassword && isValidDisplayName) == false)
                .background((isValidLogin && isValidPassword && isValidDisplayName) == true ? .blue : .secondary)
                .cornerRadius(4)
                .shadow(color: (isValidLogin && isValidPassword && isValidDisplayName) == true ? .blue.opacity(0.7) : .clear,
                        radius: 14, x: 0, y: 9)
                .padding(.top, 36)
                
                NavigationLink(isActive: $isLoggedSuccess) {
                    DialogsView()
                } label: {
                    
                }.hidden()
                
                Spacer()
            }
            .padding()
            .background(.secondary.opacity(0.1))
            .navigationBarTitle(LoginConstant.enterToChat, displayMode: .inline)
        }
    }
    
    //MARK: - Internal Methods
    private func signUp(fullName: String, login: String, password: String) {
        loginInfo = LoginConstant.signUp
        let newUser = QBUUser()
        newUser.login = login
        newUser.fullName = fullName
        newUser.password = password
        QBRequest.signUp(newUser, successBlock: { response, user in

            self.login(fullName: fullName, login: login, password: password)
            
        }, errorBlock: { response in
            
            if response.status == QBResponseStatusCode.validationFailed {
                // The user with existent login was created earlier
                self.login(fullName: fullName, login: login, password: password)
                return
            }
            if let error = response.error?.error {
                self.handleError(error)
            }
        })
    }
    
    private func login(fullName: String, login: String, password: String) {
        QBRequest.logIn(withUserLogin: login,
                        password: password,
                        successBlock: { response, user in
            
            user.password = password
            if user.fullName != fullName {
                self.updateFullName(fullName: fullName, login: login, password: password)
            } else {
                self.connectToChat(userID: user.id, password: password)
            }
            
        }, errorBlock: {  response in
            if let error = response.error?.error {
                self.handleError(error)
            }
        })
    }
    
    private func updateFullName(fullName: String, login: String, password: String) {
        loginInfo = LoginConstant.fullNameDidChange
        let updateUserParameter = QBUpdateUserParameters()
        updateUserParameter.fullName = fullName
        QBRequest.updateCurrentUser(updateUserParameter, successBlock: {  response, user in
            
            self.connectToChat(userID: user.id, password: password)
            
        }, errorBlock: {  response in
            if let error = response.error?.error {
                self.handleError(error)
            }
        })
    }
    
    private func connectToChat(userID: UInt, password: String) {
        loginInfo = LoginConstant.intoChat
        QBChat.instance.connect(withUserID: userID,
                                password: password,
                                completion: { error in
            if let error = error, error._code != -1000, error._code != 1 {
                self.handleError(error)
            } else {
                //did Login action
                self.displayName = ""
                self.login = ""
                self.password = ""
                self.isLoggedSuccess = true
            }
        })
    }
    
    // MARK: - Handle errors
    private func handleError(_ error: Error) {
        var infoText = error.localizedDescription
        if error._code == QBResponseStatusCode.unAuthorized.rawValue {
//            Profile.clear()
            //            self.defaultConfiguration()
        } else if error._code == NSURLErrorNotConnectedToInternet {
//            infoText = ConnectionConstant.noInternetConnection
        }
        //        inputEnabled = true
        //        loginButton.hideLoading()
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
