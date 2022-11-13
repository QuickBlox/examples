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
    
    var onTapped: (() -> Void)

    var body: some View {
        return Button {
            onTapped()
        } label: {
            Text("Login")
                .foregroundColor(.white)
                .font(.system(size: 18))
                .frame(width: 215, height: 44, alignment: .center)
        }
        .disabled(isValid == false)
        .background(isValid ? .blue : .secondary)
        .cornerRadius(4)
        .shadow(color: isValid ? .blue.opacity(0.7) : .clear,
                radius: 14, x: 0, y: 9)
        .padding(.top, 36)
    }
    
    private var isValid: Bool {
        return isValidLogin && isValidPassword && isValidDisplayName
    }
}
