//
//  Mocks.swift
//  MonthlySales
//
//  Created by René Fouquet on 12.06.17.
//  Copyright © 2017 René Fouquet. All rights reserved.
//

import Foundation
@testable import MonthlySales

final class ApiMock: ApiMethodsProtocol {
    init(formatters: FormattersProtocol) {}
    
    func getSalesDataFor(startDate: Date, endDate: Date, completion: @escaping (Data?) -> Void) {
        if let filePath = Bundle.main.path(forResource: "MockData", ofType: "json"), let jsonData = try? Data(contentsOf: URL(fileURLWithPath: filePath), options: .mappedIfSafe) {
            completion(jsonData)
        }
    }
    
    func fetchUserInfo(completion: @escaping ((user: String?, currencySymbol: String?)) -> Void) {
        completion((user: nil, currencySymbol: nil))
    }
}

final class DefaultsMock: DefaultsProtocol {
    var resultString: String?
    var key: String?
    
    func set(_ string: String, forKey: String) {
        resultString = string
        key = forKey
    }
    
    func string(forKey: String) -> String? {
        return resultString
    }
}

final class InternalCalendarMock: InternalCalendarProtocol {
    var isDateToday = false
    var isDateYesterday = false
    var numberOfDays = 0
    var todayDate = Date()
    
    func isDateInToday(_ date: Date) -> Bool {
        return isDateToday
    }
    
    func isDateInYesterday(_ date: Date) -> Bool {
        return isDateYesterday
    }
    
    func numberOfDaysBetween(firstDate: Date, secondDate: Date) -> Int {
        return numberOfDays
    }
    
    func today() -> Date {
        return todayDate
    }

    func resetMock() {
        isDateToday = false
        isDateYesterday = false
        numberOfDays = 0
        todayDate = Date()
    }
}
