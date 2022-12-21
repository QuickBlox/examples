//
//  ChatStorage.swift
//  sample-conference-videochat-swift
//
//  Created by Injoit on 1/28/19.
//  Copyright © 2019 Quickblox. All rights reserved.
//

import UIKit
import Quickblox

class ChatStorage {
    //MARK: - Properties
    var dialogs: [Dialog] = []
    var users: [QBUUser] = []
    
    // MARK: - Public Methods
    func clear() {
        dialogs = []
        users = []
    }
    
    func privateDialog(opponentID: UInt) -> Dialog? {
        let dialogs = self.dialogs.filter({
            guard let occupantIDs = $0.occupantIDs else {
                return false
            }
            let isPrivate = $0.type == .private
            let withOpponent = occupantIDs.contains(NSNumber(value: opponentID))
            return isPrivate && withOpponent
        })
        return dialogs.first
    }
    
    func dialog(withID dialogID: String) -> Dialog? {
        guard let dialog = dialogs.filter({ $0.id == dialogID }).first else {
            return nil
        }
        return dialog
    }
    
    func dialogsSortByUpdatedAt() -> [Dialog] {
        return dialogs.sorted(by: {
            guard let firstUpdateAt = $0.updatedAt, let lastUpdate = $1.updatedAt else {
                return false
            }
            return firstUpdateAt > lastUpdate
        })
    }
    
    func dialogsSortByLastMessage() -> [Dialog] {
        return dialogs.sorted(by: {
            guard let firstUpdateAt = $0.lastMessageDate, let lastUpdate = $1.lastMessageDate else {
                return false
            }
            return firstUpdateAt > lastUpdate
        })
    }
    
    func updateAllDialogs(_ dialogs: [QBChatDialog], completion: (() -> Void)? = nil) {
        var updatedDialogs: [Dialog] = []
        for chatDialog in dialogs {
            if chatDialog.isValid == false {
                debugPrint("[ChatStorage] Chat Dialog is not valid")
                continue
            }
            let dialog = Dialog(dialog: chatDialog)
            updatedDialogs.append(dialog)
            
            // Autojoin to the group chat
            if dialog.isJoined || dialog.type == .private {
                continue
            }
            
            dialog.joinWithCompletion { error in
                if let error = error {
                    debugPrint("[ChatStorage] dialog.join error: \(error.localizedDescription)")
                }
            }
        }
        //        self.dialogs = []
        self.dialogs = updatedDialogs
        completion?()
    }
    
    func update(dialog: QBChatDialog, completion: ((Dialog?) -> Void)? = nil) {
        if dialog.isValid == false {
            debugPrint("[ChatStorage] Chat Dialog is not valid")
            completion?(nil)
        }
        
        let dialogModel = update(dialog:dialog)
        
        // Autojoin to the group chat
        if dialogModel.isJoined || dialogModel.type == .private {
            completion?(dialogModel)
        }
        
        dialogModel.joinWithCompletion { error in
            if let error = error {
                debugPrint("[ChatStorage] dialog.join error: \(error.localizedDescription)")
            }
        }
        completion?(dialogModel)
    }
    
    func deleteDialog(withID ID: String, completion: (() -> Void)? = nil) {
        guard let index = dialogs.firstIndex(where: { $0.id == ID }) else {
            completion?()
            return
        }
        dialogs.remove(at: index)
        completion?()
    }
    
    func user(withID ID: UInt) -> QBUUser? {
        guard let user = users.filter({ $0.id == ID }).first else {
            return nil
        }
        return user
    }
    
    func update(users: [QBUUser]) {
        for chatUser in users {
            update(user:chatUser)
        }
    }
    
    func updateSearch(users: [QBUUser]) {
        for chatUser in users {
            update(user:chatUser)
        }
    }
    
    func users(with dialogID: String) -> [QBUUser] {
        var users: [QBUUser] = []
        guard let dialog = dialog(withID: dialogID), let occupantIDs = dialog.occupantIDs  else {
            return users
        }
        for ID in occupantIDs {
            if let user = self.user(withID: ID.uintValue) {
                users.append(user)
            }
        }
        return sorted(users: users)
    }
    
    func users(withIDs userIDs: [NSNumber]) -> [QBUUser] {
        var users: [QBUUser] = []
        for ID in userIDs {
            if let user = self.user(withID: ID.uintValue) {
                users.append(user)
            }
        }
        return sorted(users: users)
    }
    
    func sortedAllUsers() -> [QBUUser] {
        let sortedUsers = users.sorted(by: {
            guard let firstUpdatedAt = $0.lastRequestAt, let secondUpdatedAt = $1.lastRequestAt else {
                return false
            }
            return firstUpdatedAt > secondUpdatedAt
        })
        return sortedUsers
    }
    
    func existingUsersIDs() -> Set<NSNumber> {
        if users.isEmpty == true {
            return Set()
        }
        let usersIDs = users.map({ NSNumber(value: $0.id) })
        return Set(usersIDs)
    }
    
    //MARK: - Internal Methods
    private func markMessagesAsDelivered(forDialogID dialogID: String) {
        QBRequest.markMessages(asDelivered: nil, dialogID: dialogID, successBlock: { response in
            debugPrint("[ChatStorage] dialog.markMessages as Delivered success!!!")
        }, errorBlock: { response in
            if let error = response.error?.error {
                debugPrint("[ChatStorage] dialog.markMessages as Delivered error: \(error.localizedDescription)")
            }
        })
    }
    
    private func update(dialog: QBChatDialog) -> Dialog {
        if let index = dialogs.firstIndex(where: { $0.id == dialog.id }) {
            dialogs.remove(at: index)
        }
        let dialogModel = Dialog(dialog: dialog)
        dialogs.append(dialogModel)

        return dialogModel
    }
    
    private func sorted(users: [QBUUser]) -> [QBUUser] {
        let sortedUsers = users.sorted(by: {
            guard let firstUpdatedAt = $0.lastRequestAt, let secondUpdatedAt = $1.lastRequestAt else {
                return false
            }
            return firstUpdatedAt < secondUpdatedAt
        })
        return sortedUsers
    }
    
    private func update(user: QBUUser) {
        if let localUser = users.filter({ $0.id == user.id }).first {
            //Update local User
            localUser.fullName = user.fullName
            localUser.lastRequestAt = user.lastRequestAt
            return
        }
        users.append(user)
    }
}
