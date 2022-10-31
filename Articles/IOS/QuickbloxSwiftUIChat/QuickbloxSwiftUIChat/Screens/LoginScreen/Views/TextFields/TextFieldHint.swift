//
//  TextFieldHint.swift
//  QuickbloxSwiftUIChat
//
//  Created by Injoit.
//

import SwiftUI

struct TextFieldHint: View {
    let hint: String
    var body: some View {
        return Text(hint)
            .font(.system(size: 12, weight: .light))
            .foregroundColor(.secondary)
            .frame(height: hint.isEmpty ? 0 : 29)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}
