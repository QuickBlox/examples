//
//  String+Extension.swift
//  QuickbloxSwiftUIChat
//
//  Created by Injoit.
//

import Foundation

extension String {
    func stringByTrimingWhitespace() -> String {
        let squashed = replacingOccurrences(of: "[ ]+",
                                            with: " ",
                                            options: .regularExpression)
        return squashed.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func isValid(regexes: [String]) -> Bool {
        for regex in regexes {
            let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
            if predicate.evaluate(with: self) == true {
                return true
            }
        }
        return false
    }
}
