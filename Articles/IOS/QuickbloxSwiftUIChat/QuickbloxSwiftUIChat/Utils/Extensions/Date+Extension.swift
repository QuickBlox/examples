//
//  Date+Extension.swift
//  QuickbloxSwiftUIChat
//
//  Created by Vladimir Nybozhinsky on 26.12.2022.
//

import Foundation

extension Date {
    func formatString(dateStyle: DateFormatter.Style = .short) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = dateStyle
        
        let daysBetween = daysBetween(date: Date())
        
        if daysBetween == 0 {
            return "Today"
        } else if daysBetween == 1 {
            return "Yesterday"
        } else if daysBetween < 5 {
            let weekdayIndex = Calendar.current.component(.weekday, from: self) - 1
            return formatter.weekdaySymbols[weekdayIndex]
        }
        return formatter.string(from: self)
    }
    
    private func daysBetween(date: Date) -> Int {
        let calendar = Calendar.current
        let date1 = calendar.startOfDay(for: self)
        let date2 = calendar.startOfDay(for: date)
        if let daysBetween = calendar.dateComponents([.day], from: date1, to: date2).day {
            return daysBetween
        }
        return 0
    }
}
