//
//  QBChatDialog+Extension.swift
//  sample-conference-videochat-swift
//
//  Created by Injoit on 27.03.2022.
//  Copyright © 2022 QuickBlox. All rights reserved.
//

import UIKit
import Quickblox

extension QBChatDialog {
    
    var isValid: Bool {
        if type.rawValue < 1 {
            debugPrint("[ChatStorage] Chat type is not defined")
            return false
        }
        if id == nil || id?.isEmpty == true {
            debugPrint("[ChatStorage] Chat ID is not defined")
            return false
        }
        return true
    }
    
    func joinWithCompletion(_ completion:@escaping QBChatCompletionBlock) {
        if type != .private, isJoined() {
            completion(nil)
            return
        }
        join { error in
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
    
    func sendMessage(_ message:QBChatMessage, completion:@escaping QBChatCompletionBlock) {
        joinWithCompletion { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                debugPrint("dialog.join error: \(error.localizedDescription)")
            }
            self.send(message, completionBlock: { error in
                if let error = error {
                    debugPrint("[ChatManager] \(#function) error: \(error.localizedDescription)")
                }
                completion(error)
            })
        }
    }
}
