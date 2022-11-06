//
//  TextFieldName.swift
//  QuickbloxSwiftUIChat
//
//  Created by Injoit.
//

import SwiftUI

struct TextFieldName: View {
    let name: String
    var body: some View {
        return Text(name)
            .font(.system(size: 13, weight: .light))
            .foregroundColor(.secondary)
            .frame(height: 15, alignment: .leading)
    }
}
