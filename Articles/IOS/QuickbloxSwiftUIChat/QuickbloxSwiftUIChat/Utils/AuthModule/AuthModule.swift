//
//  AuthModule.swift
//  QuickbloxSwiftUIChat
//
//  Created by Injoit
//

import Foundation
import Quickblox

class AuthModule {
    //MARK: - Properties
    func enterToChat(fullName: String,
                     login: String,
                     password: String,
                     completion: @escaping (_ error: Error?) -> Void) {
        signUp(fullName: fullName, login: login, password: password) { error in
            if let error = error {
                completion(error)
                return
            }
            completion(nil)
        }
    }
    
    private func signUp(fullName: String,
                        login: String,
                        password: String,
                        completion: @escaping (_ error: Error?) -> Void) {
        let newUser = QBUUser()
        newUser.login = login
        newUser.fullName = fullName
        newUser.password = password
        QBRequest.signUp(newUser, successBlock: { response, user in
            self.login(fullName: fullName, login: login, password: password) { error in
                if let error = error {
                    completion(error)
                    return
                }
                completion(nil)
            }
        }, errorBlock: { response in
            if response.status == QBResponseStatusCode.validationFailed {
                // The user with existent login was created earlier
                self.login(fullName: fullName, login: login, password: password) { error in
                    if let error = error {
                        completion(error)
                        return
                    }
                    completion(nil)
                }
            } else {
                completion(response.error?.error)
            }
        })
    }
    
    private func login(fullName: String,
                       login: String,
                       password: String,
                       completion: @escaping (_ error: Error?) -> Void) {
        QBRequest.logIn(withUserLogin: login,
                        password: password,
                        successBlock: { response, user in
            self.connectToChat(userID: user.id, password: password) { error in
                if let error = error {
                    completion(error)
                    return
                }
                completion(nil)
            }
        }, errorBlock: {  response in
            completion(response.error?.error)
        })
    }
    
    private func connectToChat(userID: UInt,
                               password: String,
                               completion: @escaping (_ error: Error?) -> Void) {
        QBChat.instance.connect(withUserID: userID,
                                password: password,
                                completion: { error in
            if let error = error,
               error._code != ErrorCode.alreadyConnectedCode,
               error._code != ErrorCode.alreadyConnectingCode {
                completion(error)
                return
            }
            completion(nil)
        })
    }
}
