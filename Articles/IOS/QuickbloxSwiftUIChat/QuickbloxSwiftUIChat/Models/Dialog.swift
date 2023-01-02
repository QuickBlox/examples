//
//  Dialog.swift
//  QuickbloxSwiftUIChat
//
//  Created by Injoit on 20.11.2022.
//

import UIKit
import Quickblox

struct Dialog: Identifiable {
    private var dialog: QBChatDialog!
    
    init(dialog: QBChatDialog) {
        self.dialog = dialog
    }
    
    //MARK - Properties
    var name: String {
        return dialog.name ?? ""
    }
    
    var userID: UInt {
        return dialog.userID
    }
    
    var unreadMessagesCount: UInt {
        return dialog.unreadMessagesCount
    }
    
    var lastMessageUserID: UInt {
        return dialog.lastMessageUserID
    }
    
    var id: String {
        return dialog.id!
    }
    
    var lastMessageText: String {
        return dialog.lastMessageText ?? ""
    }
    
    var occupantIDs: [NSNumber]? {
        return dialog.occupantIDs
    }
    
    var lastMessageDate: Date? {
        return dialog.lastMessageDate
    }
    
    var updatedAt: Date? {
        return dialog.updatedAt
    }
    
    var createdAt: Date? {
        return dialog.createdAt
    }
    
    var data: [String: Any] {
        return dialog.data ?? [:]
    }
    
    var type: QBChatDialogType {
        return dialog.type
    }
    
    var isJoined: Bool {
        return dialog.isJoined()
    }
    
    //MARK - Public Methods
    func send(_ chatMessage: QBChatMessage, completion:@escaping (_ error: Error?) -> Void) {
        dialog.send(chatMessage, completionBlock: { error in
            if let error = error {
                debugPrint("[Dialog] \(#function) error: \(error.localizedDescription)")
            }
            completion(error)
        })
    }
    
    func joinWithCompletion(_ completion:@escaping QBChatCompletionBlock) {
        if type != .private, dialog.isJoined() {
            completion(nil)
            return
        }
        dialog.join { error in
            if let error = error {
                debugPrint("error._code = \(error._code)")
                if error._code == -1006 {
                    completion(nil)
                    return
                }
                completion(error)
                return
            }
            completion(nil)
        }
    }
}

extension Dialog {
    var title: String {
        var text = dialog.name ?? "Dialog"
//        if dialog.type == .private {
//            if dialog.recipientID == -1 {
//                return "Dialog"
//            }
//            // Getting recipient from users.
//            if let recipient = ChatManager.instance.storage.user(withID: UInt(dialog.recipientID)) {
//                text = recipient.fullName ?? recipient.login!
//                return text
//            }
//        }
        return text
    }
    
    var unreadMessagesCounter: String? {
        var trimmedUnreadMessageCount = ""
        if dialog.unreadMessagesCount > 0 {
            if dialog.unreadMessagesCount > 99 {
                trimmedUnreadMessageCount = "99+"
            } else {
                trimmedUnreadMessageCount = String(format: "%d", dialog.unreadMessagesCount)
            }
            return trimmedUnreadMessageCount
        } else {
            return nil
        }
    }
    
    var avatarColor: UIColor {
        return UInt(dialog.createdAt!.timeIntervalSince1970).generateColor()
    }
    
    var avatarCharacter: String {
        return String(self.title.stringByTrimingWhitespace().capitalized.first ?? Character("C"))
    }
}
