//
//  Error+Extension.swift
//  QuickbloxSwiftUIChat
//
//  Created by Injoit.
//

import Foundation

struct ErrorCode {
    static let alreadyConnectingCode = 1
    static let alreadyConnectedCode = -1000
    static let nodenameNorServnameProvided = 8
    static let socketIsNotConnected = 57
    static let socketClosedRemote = 7
    static let errorCodeTimeout = -1010
}

extension Error {
    var isNetworkError: Bool {
        let errors = [NSURLErrorNetworkConnectionLost,
                      NSURLErrorNotConnectedToInternet,
                      NSURLErrorDataNotAllowed,
                      NSURLErrorTimedOut,
                      ErrorCode.nodenameNorServnameProvided,
                      ErrorCode.socketIsNotConnected
        ]
        return errors.contains(self._code)
    }
}
