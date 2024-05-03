//
//  FirebasePhoneAuthView.swift
//  PhoneNumberAuth
//
//  Created by Injoit on 02.05.2024.
//  Copyright © 2024 QuickBlox. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebasePhoneAuthUI


struct FirebasePhoneAuthView : UIViewControllerRepresentable {

    var dismiss : (_ projectID: String?,
                              _ accessToken: String?,
                              _ error: Error?) -> Void

    func makeCoordinator() -> FirebasePhoneAuthView.Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> UIViewController
    {
        let authUI = FUIAuth.defaultAuthUI()

        let providers : [FUIAuthProvider] = [
            FUIPhoneAuth(authUI: authUI!)
        ]

        authUI?.providers = providers
        authUI?.delegate = context.coordinator

        let authViewController = authUI?.authViewController()

        return authViewController!
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<FirebasePhoneAuthView>) {

    }

    //coordinator
    class Coordinator : NSObject, FUIAuthDelegate {
        var parent : FirebasePhoneAuthView

        init(_ firebasePhoneAuthView: FirebasePhoneAuthView) {
            self.parent = firebasePhoneAuthView
        }

        // MARK: FUIAuthDelegate
        func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
            if let error = error {
                parent.dismiss(nil, nil, error)
                return
            }
            
            if let authDataResult {
                authDataResult.user.getIDToken { [weak self] token, error in
                    if let error {
                        self?.parent.dismiss(nil, nil, error)
                        return
                    }
                    
                    if let token, let projectID = Auth.auth().app?.options.projectID {
                        self?.parent.dismiss(projectID, token, nil)
                    } else {
                        self?.parent.dismiss(nil, nil, error)
                    }
                }
            }
        }

        func authUI(_ authUI: FUIAuth, didFinish operation: FUIAccountSettingsOperationType, error: Error?) {
        }
    }
}
