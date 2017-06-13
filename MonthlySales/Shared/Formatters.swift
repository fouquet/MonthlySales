//
//  Formatters.swift
//  MonthlySales
//
//  Created by René Fouquet on 11.06.17.
//  Copyright © 2017 René Fouquet. All rights reserved.
//

import Foundation

protocol InternalCalendarProtocol {
    func isDateInToday(_ date: Date) -> Bool
    func isDateInYesterday(_ date: Date) -> Bool
    func numberOfDaysBetween(firstDate: Date, secondDate: Date) -> Int
    func today() -> Date
}

final class InternalCalendar: InternalCalendarProtocol {
    func isDateInToday(_ date: Date) -> Bool {
        return Calendar.current.isDateInToday(date)
    }
    
    func isDateInYesterday(_ date: Date) -> Bool {
        return Calendar.current.isDateInYesterday(date)
    }
    
    func numberOfDaysBetween(firstDate: Date, secondDate: Date) -> Int {
        let date1 = Calendar.current.startOfDay(for: firstDate)
        guard let date2 = Calendar.current.date(byAdding: .day, value: 1, to: Calendar.current.startOfDay(for: secondDate)) else { return 0 }
        
        if let days = Calendar.current.dateComponents([.day], from: date1, to: date2).day {
            return days
        }
        return 0
    }
    
    func today() -> Date {
        return Date()
    }
}

protocol FormattersProtocol {
    func toDate(_ string: String) -> Date
    func fromDate(_ date: Date) -> String
    func prettyFromDate(_ date: Date) -> String
    func currency(value: Decimal, symbol: String) -> String
    func today() -> Date
    func isDateToday(_ date: Date) -> Bool
    func isDateYesterday(_ date: Date) -> Bool
}

final class Formatters: FormattersProtocol {
    private let simpleDateFormatter = DateFormatter()
    private let prettyDateFormatter = DateFormatter()
    private let currencyFormatter = NumberFormatter()
    var calendar: InternalCalendarProtocol = InternalCalendar()

    init() {
        simpleDateFormatter.dateFormat = "yyyy-MM-dd"
        prettyDateFormatter.dateFormat = "yyyy-MM-dd"
        prettyDateFormatter.dateStyle = .short
        currencyFormatter.locale = Locale.current
        currencyFormatter.numberStyle = .currency
    }

    func toDate(_ string: String) -> Date {
        if let stringFromDate = simpleDateFormatter.date(from:string) {
            return stringFromDate
        } else {
            fatalError("Wrong date string")
        }
    }

    func fromDate(_ date: Date) -> String {
        return simpleDateFormatter.string(from: date)
    }

    func prettyFromDate(_ date: Date) -> String {
        return prettyDateFormatter.string(from: date)
    }

    func currency(value: Decimal, symbol: String) -> String {
        currencyFormatter.currencySymbol = symbol

        if let string = currencyFormatter.string(from: value as NSNumber) {
            return string
        } else {
            return "Error"
        }
    }
    
    func isDateToday(_ date: Date) -> Bool {
        return calendar.isDateInToday(date)
    }
    
    func isDateYesterday(_ date: Date) -> Bool {
        return calendar.isDateInYesterday(date)
    }
    
    func today() -> Date {
        return calendar.today()
    }
}
