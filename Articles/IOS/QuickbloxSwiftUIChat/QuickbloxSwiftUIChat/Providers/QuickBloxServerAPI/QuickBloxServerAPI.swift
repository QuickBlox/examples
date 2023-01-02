//
//  QuickBloxServerAPI.swift
//  QuickbloxSwiftUIChat
//
//  Created by Injoit on 28.12.2022.
//

import Foundation
import Quickblox

enum QuickBloxServerError: Error {
    case someError
}

typealias DialogsFetchCompletion = (Result<[Dialog], Error>) -> Void

class QuickBloxServerAPI {
    
    //MARK: - Public Methods
    //MARK: - Dialogs
    func fetchDialogs(withCompletion completion: @escaping DialogsFetchCompletion) {
        let extendedParameters = ["sort_desc": "last_message_date_sent"]
        let responsePage = QBResponsePage(limit: 100)
        QBRequest.dialogs(for: responsePage,
                          extendedRequest: extendedParameters,
                          successBlock: { response,
            dialogs, dialogsUsersIDs, page in
            
            self.update(dialogs: dialogs) { updatedDialogs in
                                    completion(.success(updatedDialogs))
                                }
        }, errorBlock: { response in
            let error = response.error?.error ?? QuickBloxServerError.someError
            completion(.failure(error))
        })
    }
    
    //MARK: - Private Methods
    func update(dialogs: [QBChatDialog], completion: @escaping (([Dialog]) -> Void)) {
        for chatDialog in dialogs {
            
            if chatDialog.isValid == false {
                continue
            }
            
            let dialog = Dialog(dialog: chatDialog)
            ChatManager.instance.storage.dialogs[dialog.id] = dialog
            
            // Autojoin to the group chat
            if dialog.type == .private {
                continue
            }
            if dialog.isJoined {
                continue
            }
            dialog.joinWithCompletion { error in
                if let error = error {
                    debugPrint("[ChatStorage] dialog.join error: \(error.localizedDescription)")
                }
            }
        }
        completion(Array(ChatManager.instance.storage.dialogs.values))
    }
}
