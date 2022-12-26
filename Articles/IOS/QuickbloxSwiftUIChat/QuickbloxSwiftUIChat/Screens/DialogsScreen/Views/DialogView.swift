//
//  DialogView.swift
//  QuickbloxSwiftUIChat
//
//  Created by Vladimir Nybozhinsky on 26.12.2022.
//

import SwiftUI
import Quickblox

struct DialogView: View {
    
    @State var dialog: Dialog
    
    var body: some View {
        return HStack(spacing: 9) {
            DialogAvatarView(dialog: $dialog)
            
            VStack(alignment: .leading, spacing: 0) {
                DialogTitleView(dialog: $dialog)
                DialogLastMessageView(dialog: $dialog)
            }
            .padding(.trailing, 24)
            
            VStack(alignment: .trailing, spacing: 0) {
                DialogLastMessageDateView(dialog: $dialog)
                DialogUnreadMessagesCounterView(dialog: $dialog)
            }
        }
        .frame(height: 40)
    }
}

struct DialogAvatarView: View {
    
    @Binding var dialog: Dialog
    
    var body: some View {
        return Text(dialog.avatarCharacter)
            .foregroundColor(.white)
            .font(.system(size: 17, weight: .medium))
            .frame(width: 40, height: 40, alignment: .center)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .circular)
                    .fill(Color(dialog.avatarColor))
            )
    }
}

struct DialogTitleView: View {
    
    @Binding var dialog: Dialog
    
    var body: some View {
        return Text(dialog.title)
            .font(.system(size: 17))
            .lineLimit(1)
            .frame(height: 20, alignment: .bottom)
    }
}

struct DialogLastMessageView: View {
    
    @Binding var dialog: Dialog
    
    var body: some View {
        return Text(dialog.lastMessageText)
            .foregroundColor(.secondary)
            .font(.system(size: 15, weight: .light))
            .lineLimit(1)
            .frame(height: 20, alignment: .top)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct DialogLastMessageDateView: View {
    
    @Binding var dialog: Dialog
    
    var body: some View {
        return Text(dialog.lastMessageDate?.formatString() ?? "")
            .font(.system(size: 12, weight: .light))
            .foregroundColor(.secondary)
            .frame(height: 16, alignment: .top)
    }
}

struct DialogUnreadMessagesCounterView: View {
    
    @Binding var dialog: Dialog
    
    var body: some View {
        return Text(dialog.unreadMessagesCounter ?? "99+")
            .font(.system(size: 12, weight: .light))
            .padding(3)
            .foregroundColor(.white)
            .frame(height: 24)
            .frame(minWidth: 24)
            .background(
                Capsule()
                    .fill(.green)
                    .opacity(dialog.unreadMessagesCounter == nil ? 0.0 : 1.0)
            )
    }
}
