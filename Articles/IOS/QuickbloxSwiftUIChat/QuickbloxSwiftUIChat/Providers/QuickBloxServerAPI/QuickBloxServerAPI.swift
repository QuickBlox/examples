//
//  QuickBloxServerAPI.swift
//  QuickbloxSwiftUIChat
//
//  Created by Vladimir Nybozhinsky on 28.12.2022.
//

import Foundation
import Quickblox

enum QuickBloxServerError: Error {
    case someError
}

typealias DialogsFetchCompletion = (Result<[QBChatDialog]?, Error>) -> Void

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
            
            completion(.success(dialogs))
        }, errorBlock: { response in
            let error = response.error?.error ?? QuickBloxServerError.someError
            completion(.failure(error))
        })
    }
}
