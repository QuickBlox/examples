//
//  QuickbloxAPI.swift
//  PhoneNumberAuth
//
//  Created by Injoit on 02.05.2024.
//  Copyright © 2024 QuickBlox. All rights reserved.
//

import Foundation
import Quickblox

struct QuickbloxAPI {
    
    func logInWithFirebase(_ projectID: String,
                           accessToken: String,
                           completion: @escaping (_ user: QBUUser?, _ error: Error?) -> Void) {
        
        QBRequest.logIn(withFirebaseProjectID: projectID, accessToken: accessToken, successBlock: { response, qbUser in
            guard let password = QBSession.current.sessionDetails?.token else {
                completion(nil, response.error?.error)
                return
            }
            qbUser.password = password
            completion(qbUser, nil)
        }, errorBlock: { response in
            completion(nil, response.error?.error)
        })
    }
    
    func connect(withUserID userId: UInt, completion: @escaping (Bool) -> Void) {
        guard let token = QBSession.current.sessionDetails?.token else {
            completion(false)
            return
        }
        QBChat.instance.connect(withUserID: userId, password: token) { error in
            if error != nil {
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    func disconnect(_ completion: @escaping (Error?) -> Void) {
        QBChat.instance.disconnect() {_ in
            QBRequest.logOut(successBlock: { response in
                completion(nil)
            }) { response in
                guard let error = response.error?.error else {
                    completion(nil)
                    return
                }
                completion(error)
            }
        }
    }
    
    func configure() {
        Quickblox.initWithApplicationId(0, // Your_Application_ID
                                authKey: "", // Your_Authorization_Key
                                authSecret: "", // Your_Authorization_Secret
                                accountKey: "") // Your_Account_Key
        
        QBSettings.carbonsEnabled = true
        QBSettings.autoReconnectEnabled = true
    }
}
