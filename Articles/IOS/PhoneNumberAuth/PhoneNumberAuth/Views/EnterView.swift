//
//  EnterView.swift
//  PhoneNumberAuth
//
//  Created by Injoit on 30.04.2024.
//  Copyright © 2024 QuickBlox. All rights reserved.
//

import SwiftUI

enum AuthState {
    case authorized
    case unAuthorized
}

struct EnterView: View {
    
    @State var authState: AuthState = .unAuthorized
    @State var qbUserName: String = ""
    
    var body: some View {
        ZStack {
            Color.blue.ignoresSafeArea()
            
            switch authState {
                
            case .unAuthorized:
                
                FirebasePhoneAuthView(dismiss: { projectID, accessToken, error in
                    guard let projectID, let accessToken else {
                        if let error {
                            print("Firebase Phone Auth Error: \(error.localizedDescription)")
                        }
                        return
                    }
                    
                    logInToQuickbloxWithFirebase(projectID, accessToken: accessToken)
                    
                }).edgesIgnoringSafeArea(.all)
                
            case .authorized:
                
                Text("Hello, \(qbUserName)!")
                .padding()
            }
        }
    }
    
    private func logInToQuickbloxWithFirebase(_ projectID: String,
                                             accessToken: String) {
        let api =  QuickbloxAPI()
        api.logInWithFirebase(projectID, accessToken: accessToken) { user, error in
            guard let user else {
                if let error {
                    print("Quickblox Auth Error: \(error.localizedDescription)")
                }
                return
            }
            qbUserName = user.fullName ?? user.login!
            authState = .authorized
        }
    }
}
