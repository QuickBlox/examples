//
//  ChatManager.swift
//  sample-conference-videochat-swift
//
//  Created by Injoit on 1/28/19.
//  Copyright © 2019 Quickblox. All rights reserved.
//

import UIKit
import Quickblox

struct ChatManagerConstant {
    static let dialogsPageLimit:Int = 100
    static let messagesLimitPerDialog = 30
    static let usersLimit: UInt = 100
}

typealias DialogsPage = (_ page: QBResponsePage) -> Void
//typealias DialogsFetchCompletion = (_ response: QBResponse?, _ dialogs: [QBChatDialog]?) -> Void
typealias DialogCompletion = (_ error: String?, _ dialog: Dialog?) -> Void
typealias UsersPage = (_ page: QBGeneralResponsePage) -> Void
//typealias SendMessageCompletion = (_ error: Error?) -> Void

class ChatManager: NSObject {
    
    //MARK: - Properties
    var storage = ChatStorage()
    
    //MARK: - Life Cycle
    //Shared Instance
    static let instance: ChatManager = {
        let instance = ChatManager()
        return instance
    }()
    
    //MARK: - Public Methods
//    func updateStorage() {
//        if QBChat.instance.isConnected == false {
//            return
//        }
//        var message = ""
//        updateAllDialogs(withPageLimit: ChatManagerConstant.dialogsPageLimit,
//                         completion: { (response, dialogs) -> Void in
//            if let response = response {
//                message = response.error?.error?.localizedDescription ?? ""
//            }
//            if message.isEmpty, let updatedDialogs = dialogs {
//                self.storage.updateAllDialogs(updatedDialogs) {
////                    self.delegate?.chatManager(self, didUpdateStorage: "Completed")
//                }
//            } else {
////                self.delegate?.chatManager(self, didFailUpdateStorage: message)
//            }
//        })
//    }
    
    //MARK: - Users
//    func loadUser(_ id: UInt, completion: ((QBUUser?) -> Void)? = nil) {
//        QBRequest.user(withID: id, successBlock: { (response, user) in
//            self.storage.update(users: [user])
//            completion?(user)
//        }) { (response) in
//            debugPrint("[ChatManager] loadUser error: \(response.error?.error?.localizedDescription ?? "")")
//            completion?(nil)
//        }
//    }
//
//    func searchUsers(_ name: String,  currentPage: UInt, perPage: UInt, completion: @escaping (_ response: QBResponse?, _ objects: [QBUUser], _ cancel: Bool) -> Void) {
//        let page = QBGeneralResponsePage(currentPage: currentPage, perPage: perPage)
//        QBRequest.users(withFullName: name, page: page,
//                        successBlock: { (response, page, users) in
//            let cancel = users.count < page.perPage
//            completion(nil, users, cancel)
//        }, errorBlock: { response in
//            completion(response, [], false)
//            debugPrint("[ChatManager] searchUsers error: \(response.error?.error?.localizedDescription ?? "")")
//        })
//    }
//
//    func fetchUsers(currentPage: UInt, perPage: UInt, completion: @escaping (_ response: QBResponse?, _ objects: [QBUUser], _ cancel: Bool) -> Void) {
//        let page = QBGeneralResponsePage(currentPage: currentPage, perPage: perPage)
//        QBRequest.users(withExtendedRequest: ["order": "desc date last_request_at"],
//                        page: page,
//                        successBlock: { (response, page, users) in
//            let cancel = users.count < page.perPage
//            completion(nil, users, cancel)
//        }, errorBlock: { response in
//            completion(response, [], false)
//            debugPrint("[ChatManager] searchUsers error: \(response.error?.error?.localizedDescription ?? "")")
//        })
//    }
//
//    // MARK: - Dialogs
//    func createPrivateDialog(withOpponent opponent: QBUUser,
//                             completion: DialogCompletion? = nil) {
//        if opponent.id <= 0 {
//            debugPrint("[ChatManager] \(#function) error: Incorrect user ID")
//            return
//        }
//
//        if let dialog = storage.privateDialog(opponentID: opponent.id) {
//            completion?(nil, dialog)
//        } else {
//            let currentUser = Profile()
//            guard currentUser.isFull == true else {
//                return
//            }
//            let dialog = QBChatDialog(dialogID: nil, type: .private)
//            dialog.occupantIDs = [NSNumber(value: opponent.id)]
//            QBRequest.createDialog(dialog, successBlock: { response, createdDialog in
//                if createdDialog.isValid == false {
//                    completion
//                }
//                self.storage.update(dialog: createdDialog) { updatedDialog in
//                    guard let dialog = updatedDialog else {
//                        completion?(nil, updatedDialog)
//                    }
//                    let message = "created the private chat with " + (opponent.fullName ?? "QBUser")
////                    self.delegate?.chatManager(self, didUpdateStorage: message)
//                    completion?(nil, updatedDialog)
//                    //Notify carbon user about create new private dialog
////                    self.sendCreate(to: createdDialog)
//                }
//            }, errorBlock: { response in
//                debugPrint("[ChatManager] \(#function) error: \(response.error?.error?.localizedDescription ?? "")")
//                completion?(response.error?.error?.localizedDescription ?? "", nil)
//            })
//        }
//    }
//
//    func createGroupDialog(withName name: String,
//                           photo: String?,
//                           occupants: [QBUUser],
//                           completion: DialogCompletion? = nil) {
//
//
//        let chatDialog = QBChatDialog(dialogID: nil, type: .group)
//
//        chatDialog.name = name
//        chatDialog.occupantIDs = occupants.map({ NSNumber(value: $0.id) })
//
//        QBRequest.createDialog(chatDialog, successBlock: { response, dialog in
//            dialog.joinWithCompletion { error in
//                if let error = error {
//                    debugPrint("[ChatStorage] dialog.join error: \(error.localizedDescription)")
//                }
//                //Notify about create new dialog
////                self.sendCreate(to: dialog) { error in
////                    if let error = error {
////                        debugPrint("[ChatStorage] dialog.join error: \(error.localizedDescription)")
////                    }
//                    self.storage.update(dialog:dialog) {
//                        let message = "created the group chat " + dialog.name!
////                        self.delegate?.chatManager(self, didUpdateStorage: message)
//                        completion?(error?.localizedDescription, dialog)
//                    }
////                }
//            }
//        }, errorBlock: { response in
//            debugPrint("[ChatManager] createGroupDialog error: \(response.error?.error?.localizedDescription ?? "")")
//            completion?(response.error?.error?.localizedDescription ?? "", nil)
//        })
//    }
    
//    func leaveDialog(withID dialogId: String, completion: ((String?) -> Void)? = nil) {
//        let currentUser = Profile()
//        guard let dialog = storage.dialog(withID: dialogId), currentUser.isFull == true else {
//            completion?("Dialogue not found")
//            return
//        }
//
//        switch dialog.type {
//        case .private, .publicGroup: break
//        case .group:
//            sendLeave(dialog) { error in
//                dialog.pullOccupantsIDs = [(NSNumber(value: currentUser.ID)).stringValue]
//                QBRequest.update(dialog, successBlock: { (response, dialog) in
//                    self.storage.deleteDialog(withID: dialogId) {
//                        completion?(nil)
//                    }
//                }, errorBlock: { response in
//                    if (response.status == .notFound || response.status == .forbidden), dialog.type != .publicGroup {
//                        self.storage.deleteDialog(withID: dialogId) {
//                            completion?(nil)
//                        }
//                    }
//                    let errorMessage = self.errorMessage(response: response)
//                    self.delegate?.chatManager(self, didFailUpdateStorage: errorMessage ?? "")
//                    completion?(errorMessage)
//                })
//            }
//        @unknown default:
//            fatalError("unknown")
//        }
//    }
//
//    func loadDialog(withID dialogID: String, completion: @escaping (_ loadedDialog: QBChatDialog?) -> Void) {
//        let responsePage = QBResponsePage(limit: 1, skip: 0)
//        let extendedRequest = ["_id": dialogID]
//
//        QBRequest.dialogs(for: responsePage, extendedRequest: extendedRequest,
//                          successBlock: { response, dialogs, dialogsUsersIDs, page in
//            guard let chatDialog = dialogs.first else {
//                completion(nil)
//                return
//            }
//            self.loadUsers(dialogsUsersIDs.map({ $0.stringValue })) { response in
//                self.storage.update(dialogs:[chatDialog]) {
//                    completion(chatDialog)
//                }
//            }
//        }, errorBlock: { response in
//            completion(nil)
//            debugPrint("[ChatManager] loadDialog error: \(response.error?.error?.localizedDescription ?? "")")
//        })
//    }
    
//    private func prepareDialog(with dialogID: String, with message: QBChatMessage) {
//        let currentUser = Profile()
//        if let dialog = storage.dialog(withID: dialogID) {
//            dialog.updatedAt = message.dateSent
//            dialog.lastMessageDate = message.dateSent
//            dialog.lastMessageText = message.text
//            if currentUser.isFull == true,
//               message.senderID != currentUser.ID {
//                dialog.unreadMessagesCount = dialog.unreadMessagesCount + 1
//            }
//
//            if message.attachments?.isEmpty == false {
//                dialog.lastMessageText = "[Attachment]"
//            }
//            if let notificationType = message.customParameters["notification_type"] as? String {
//
//                switch(notificationType) {
//                case NotificationType.startConference.rawValue, NotificationType.startStream.rawValue:
//                    storage.update(dialogs:[dialog])
//                    delegate?.chatManager(self, didUpdateChatDialog: dialog)
//                case NotificationType.addUsersToGroupDialog.rawValue, NotificationType.createGroupDialog.rawValue:
//                    if let occupantIDs = dialog.occupantIDs,
//                       let strIDs = message.customParameters[Key.newOccupantsIds] as? String {
//                        let strArray: [String] = strIDs.components(separatedBy: ",")
//
//                        var newOccupantIDs: [NSNumber] = []
//                        var missingOccupantIDs: [NSNumber] = []
//                        for strID in strArray {
//                            if let uintID = UInt(strID) {
//                                if occupantIDs.contains(NSNumber(value: uintID)) == true {
//                                    continue
//                                }
//                                newOccupantIDs.append(NSNumber(value: uintID))
//                                if storage.user(withID: uintID) == nil {
//                                    missingOccupantIDs.append(NSNumber(value: uintID))
//                                }
//                            }
//                        }
//                        if newOccupantIDs.isEmpty == true {
//                            self.storage.update(dialogs: [dialog])
//                            break
//                        }
//                        if missingOccupantIDs.isEmpty == false {
//                            let missingOccupantIDStrArray = missingOccupantIDs.map({ $0.stringValue })
//                            QBRequest.users(withIDs: missingOccupantIDStrArray, page: nil, successBlock: { (response, page, newUsers) in
//                                self.storage.update(users: newUsers)
//                                dialog.occupantIDs = occupantIDs + newOccupantIDs
//                                dialog.occupantIDs = occupantIDs + newOccupantIDs
//                                self.storage.update(dialogs: [dialog]) {
//                                    self.delegate?.chatManager(self, didUpdateChatDialog: dialog)
//                                    self.postNotificationDidUpdateChatDialog(dialog.id)
//                                }
//                            }, errorBlock: { response in
//                                debugPrint("[ChatManager] loadUsers error: \(self.errorMessage(response: response) ?? "")")
//                            })
//                        } else {
//                            dialog.occupantIDs = occupantIDs + newOccupantIDs
//                            self.storage.update(dialogs: [dialog]) {
//                                self.delegate?.chatManager(self, didUpdateChatDialog: dialog)
//                                self.postNotificationDidUpdateChatDialog(dialog.id)
//                            }
//                        }
//                    }
//                case NotificationType.leaveGroupDialog.rawValue:
//                    if let occupantIDs = dialog.occupantIDs {
//                        if let index = occupantIDs.firstIndex(of: NSNumber(value: message.senderID)) {
//                            var occupants = occupantIDs
//                            occupants.remove(at: index)
//                            dialog.occupantIDs = occupants
//                            self.storage.update(dialogs: [dialog]) {
//                                self.delegate?.chatManager(self, didUpdateChatDialog: dialog)
//                                self.postNotificationDidUpdateChatDialog(dialog.id)
//                            }
//                        }
//                    }
//                default: break
//
//                }
//            } else {
//                self.storage.update(dialogs: [dialog]) {
//                    self.delegate?.chatManager(self, didUpdateChatDialog: dialog)
//                }
//            }
//        } else {
//            loadDialog(withID: dialogID, completion: { dialog in
//                guard let dialog = dialog else {
//                    return
//                }
//                if let notificationType = message.customParameters["notification_type"] as? String {
//                    if dialog.type == .private {
//                        return
//                    }
//                    switch(notificationType) {
//                    case NotificationType.createGroupDialog.rawValue: dialog.unreadMessagesCount = 1
//                    case NotificationType.addUsersToGroupDialog.rawValue:break
//                    case NotificationType.leaveGroupDialog.rawValue:break
//                    default: break
//                    }
//                }
//                dialog.lastMessageText = message.text
//                dialog.updatedAt = Date()
//                self.storage.update(dialogs: [dialog]) {
////                    self.delegate?.chatManager(self, didUpdateChatDialog: dialog)
//                }
//            })
//        }
//    }
//
//    func updateDialog(with dialogID: String, with message: QBChatMessage) {
//        if storage.user(withID: message.senderID) != nil {
//            prepareDialog(with: dialogID, with: message)
//        } else {
//            QBRequest.user(withID: message.senderID, successBlock: { response, user in
//                self.storage.update(users:[user])
//                self.prepareDialog(with: dialogID, with: message)
//            }, errorBlock: { response in
//                debugPrint("[ChatManager] updateDialog error: \(response.error?.error?.localizedDescription ?? "")")
//            })
//        }
//    }
    
    //MARK: - Messages
    //    func messages(withID dialogID: String,
    //                  extendedRequest extendedParameters: [String: String]? = nil,
    //                  skip: Int,
    //                  limit: Int,
    //                  successCompletion: MessagesCompletion? = nil,
    //                  errorHandler: MessagesErrorHandler? = nil ) {
    //
    //        let page = QBResponsePage(limit: limit, skip: skip)
    //        let extendedRequest = extendedParameters?.isEmpty == false ? extendedParameters : parametersForMessages()
    //        QBRequest.messages(withDialogID: dialogID,
    //                           extendedRequest: extendedRequest,
    //                           for: page,
    //                           successBlock: { response, messages, page in
    //            var sortedMessages = messages
    //            sortedMessages = Array(sortedMessages.reversed())
    //
    //            var cancel = false
    //            let numberOfMessages = sortedMessages.count
    //            cancel = numberOfMessages < page.limit ? true : false
    //
    //            successCompletion?(sortedMessages, cancel)
    //
    //        }, errorBlock: { response in
    //            // case where we may have deleted dialog from another device
    //            if response.status == .notFound || response.status.rawValue == 403 {
    //                self.storage.deleteDialog(withID: dialogID)
    //                errorHandler?(ChatManagerConstant.notFound)
    //                return
    //            }
    //            errorHandler?(self.errorMessage(response: response))
    //        })
    //    }
    //
    //
    //    func send(_ message: QBChatMessage, to dialog: QBChatDialog, completion: QBChatCompletionBlock?) {
    //        dialog.sendMessage(message) { error in
    //            if let error = error {
    //                completion?(error)
    //                return
    //            }
    //            dialog.updatedAt = Date()
    //            self.storage.update(dialogs: [dialog])
    //            self.delegate?.chatManager(self, didUpdateChatDialog: dialog)
    //            completion?(nil)
    //        }
    //    }
    //
    //    func  read(_ message: QBChatMessage,
    //               dialog: QBChatDialog,
    //               completion: QBChatCompletionBlock?) {
    //        let currentUser = Profile()
    //        if currentUser.isFull == false {
    //            completion?(nil)
    //            return
    //        }
    //        if   message.dialogID != dialog.id  {
    //            return
    //        }
    //
    //        if message.deliveredIDs?.contains(NSNumber(value: currentUser.ID)) == false {
    //            QBChat.instance.mark(asDelivered: message) { error in
    //            }
    //        }
    //        QBChat.instance.read(message) { error in
    //            if error == nil {
    //                // updating dialog
    //                if dialog.unreadMessagesCount > 0 {
    //                    dialog.unreadMessagesCount = dialog.unreadMessagesCount - 1
    //                }
    //                if UIApplication.shared.applicationIconBadgeNumber > 0 {
    //                    let badgeNumber = UIApplication.shared.applicationIconBadgeNumber
    //                    UIApplication.shared.applicationIconBadgeNumber = badgeNumber - 1
    //                }
    //                self.storage.update(dialogs: [dialog]) {
    //                    self.delegate?.chatManager(self, didUpdateChatDialog: dialog)
    //                }
    //                completion?(nil)
    //            }
    //        }
    //    }
    //
    //    func joinOccupants(withIDs ids: [NSNumber], to chatDialog: QBChatDialog,
    //                       completion: @escaping (_ response: QBResponse?, _ updatedDialog: QBChatDialog?) -> Void) {
    //        let pushOccupantsIDs = ids.map({ $0.stringValue })
    //        chatDialog.pushOccupantsIDs = pushOccupantsIDs
    //        QBRequest.update(chatDialog, successBlock: { response, updatedDialog in
    //            chatDialog.pushOccupantsIDs = []
    //            self.sendAdd(ids, to: updatedDialog) { error in
    //                if let error = error {
    //                    debugPrint("[ChatStorage] dialog.join error: \(error.localizedDescription)")
    //                }
    //                self.storage.update(dialogs:[updatedDialog]) {
    //                    completion(response, updatedDialog)
    //                }
    //            }
    //        }, errorBlock: { response in
    //            chatDialog.pushOccupantsIDs = []
    //            completion(response, nil)
    //        })
    //    }
    
    //MARK: - Connect/Disconnect
    //    func connect(completion: QBChatCompletionBlock? = nil) {
    //        let currentUser = Profile()
    //        guard currentUser.isFull == true else {
    //            completion?(NSError(domain: ChatManagerConstant.chatServiceDomain,
    //                                code: ChatManagerConstant.errorDomaimCode,
    //                                userInfo: [
    //                                    NSLocalizedDescriptionKey: "Please enter your login and username."
    //                                ]))
    //            return
    //        }
    //        if QBChat.instance.isConnected == true {
    //            completion?(nil)
    //        } else {
    //            QBChat.instance.connect(withUserID: currentUser.ID,
    //                                    password: currentUser.password,
    //                                    completion: completion)
    //        }
    //    }
    //
    //    func disconnect(completion: QBChatCompletionBlock? = nil) {
    //        if QBChat.instance.isConnected == true {
    //            QBChat.instance.disconnect(completionBlock: completion)
    //        } else {
    //            completion?(nil)
    //        }
    //    }
    
    //MARK: - Internal Methods
    
    //MARK: - Users
//    private func updateUsers(completion: @escaping (_ response: QBResponse?) -> Void) {
//        let firstPage = QBGeneralResponsePage(currentPage: 1, perPage: 100)
//        QBRequest.users(withExtendedRequest: ["order": "desc date last_request_at"],
//                        page: firstPage,
//                        successBlock: { (response, page, users) in
//            self.storage.update(users:users)
//            completion(response)
//        }, errorBlock: { response in
//            completion(response)
//            debugPrint("[ChatManager] updateUsers error: \(response.error?.error?.localizedDescription ?? "")")
//        })
//    }
//    
//    private func loadUsers(_ usersIDs: [String], completion: ((_ response: QBResponse?) -> Void)? = nil) {
//        var skip: UInt = 1
//        var t_request: UsersPage?
//        let request: UsersPage? = { usersPage in
//            QBRequest.users(withIDs: usersIDs,
//                            page: usersPage,
//                            successBlock: { (usersResponse, usersResponsePage, users) in
//                
//                self.storage.update(users: users)
//                
//                skip = skip + 1
//                let cancel = users.count < ChatManagerConstant.usersLimit ? true : false
//                if cancel == false {
//                    
//                    t_request?(QBGeneralResponsePage(currentPage: skip, perPage: ChatManagerConstant.usersLimit))
//                } else {
//                    completion?(usersResponse)
//                    t_request = nil
//                }
//            }, errorBlock: { response in
//                completion?(response)
//                debugPrint("[ChatManager] \(#function) error: \(response.error?.error?.localizedDescription ?? "")")
//                t_request = nil
//            })
//        }
//        t_request = request
//        request?(QBGeneralResponsePage(currentPage: skip, perPage: ChatManagerConstant.usersLimit))
//    }
    
    //MARK: - Dialogs
//    private func updateAllDialogs(withPageLimit limit: Int,
//                                  extendedParameters: [String: String]? = nil,
//                                  completion: @escaping DialogsFetchCompletion) {
//        var fedchetDialogs: [QBChatDialog] = []
//        var usersForUpdate = Set<NSNumber>()
//        let extendedRequest = extendedParameters?.isEmpty == false ?
//        extendedParameters : ["sort_desc": "last_message_date_sent"]
//        var t_request: DialogsPage?
//        let request: DialogsPage? = { responsePage in
//            QBRequest.dialogs(for: responsePage,
//                              extendedRequest: extendedRequest,
//                              successBlock: { response,
//                dialogs, dialogsUsersIDs, page in
//
//                fedchetDialogs = fedchetDialogs + dialogs
//
//                page.skip += dialogs.count
//                let cancel = page.totalEntries <= page.skip
//                usersForUpdate = usersForUpdate.union(dialogsUsersIDs)
//                if usersForUpdate.isEmpty == false {
//                    let usersIDs = usersForUpdate.map({ $0.stringValue })
//                    self.loadUsers(usersIDs)
//                }
//                if cancel == false {
//                    t_request?(page)
//                } else {
//                    completion(fedchetDialogs)
//                    t_request = nil
//                }
//            }, errorBlock: { response in
//                completion(fedchetDialogs)
//                debugPrint("[\(ChatManager.description())] \(#function) error: \(response.error?.error?.localizedDescription ?? "")")
//                t_request = nil
//            })
//        }
//        t_request = request
//        request?(QBResponsePage(limit: limit))
//    }
}
