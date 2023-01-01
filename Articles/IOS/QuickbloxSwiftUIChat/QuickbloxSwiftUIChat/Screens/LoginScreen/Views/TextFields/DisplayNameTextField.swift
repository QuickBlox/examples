//
//  DisplayNameTextField.swift
//  QuickbloxSwiftUIChat
//
//  Created by Injoit on 06.11.2022.
//

import SwiftUI

struct DisplayNameTextField : View {
    
    @Binding var displayName: String
    @Binding var isValidDisplayName: Bool
    
    var body: some View {
        return BaseTextField(isSecure: false,
                             textFieldName: "Display Name",
                             invalidTextHint: Hint.displayName.rawValue,
                             regexes: [Regex.displayName],
                             text: $displayName,
                             isValidText: $isValidDisplayName)
    }
}
