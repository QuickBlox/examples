//
//  LoginButton.swift
//  QuickbloxSwiftUIChat
//
//  Created by Injoit.
//

import SwiftUI

struct LoginButton : View {

    @Binding var isValidLogin: Bool
    @Binding var isValidPassword: Bool
    @Binding var isValidDisplayName: Bool

    var body: some View {
        return Button {
            debugPrint("Login Button Tapped!")
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
    }
}
