//
//  FormattersTests.swift
//  MonthlySalesTests
//
//  Created by René Fouquet on 12.06.17.
//  Copyright © 2017 René Fouquet. All rights reserved.
//

import XCTest
@testable import MonthlySales

class FormattersTests: XCTestCase {
    
    let SUT = Formatters()
    let calendarMock = InternalCalendarMock()
    let dateFormatter = DateFormatter()

    override func setUp() {
        super.setUp()
        
        dateFormatter.dateFormat = "yyyy-MM-dd"

        SUT.calendar = calendarMock
    }
    
    override func tearDown() {
        super.tearDown()
        
        calendarMock.resetMock()
    }
    
    func testToDate() {
        let testDateString = "2017-06-13"
        
        let result = SUT.toDate(testDateString)
        
        let expected = dateFormatter.date(from: testDateString)

        XCTAssertEqual(result, expected)
    }
    
    func testFromDate() {
        let expected = "2017-06-13"

        let testDate = dateFormatter.date(from: expected)
        
        let result = SUT.fromDate(testDate!)
        
        XCTAssertEqual(result, expected)
    }
    
    func testPrettyFromDate() {
        let expected = "6/13/17"
        
        let testDate = dateFormatter.date(from: "2017-06-13")
        
        let result = SUT.prettyFromDate(testDate!)
        
        XCTAssertEqual(result, expected)
    }
    
    func testCurrency() {
        let expected = "$1,234.45"
        
        let testAmount = Decimal(1234.45)
        
        let result = SUT.currency(value: testAmount, symbol: "$")
        
        XCTAssertEqual(result, expected)
    }
    
    func testToday() {
        let expected = dateFormatter.date(from: "2017-06-13")

        calendarMock.todayDate = expected!
        
        let result = SUT.today()
        
        XCTAssertEqual(result, expected)
    }
    
    func testIsDateToday() {
        calendarMock.isDateToday = true
        
        let result = SUT.isDateToday(Date())
        
        XCTAssertTrue(result)
    }
    
    func testIsDateYesterday() {
        calendarMock.isDateYesterday = true
        
        let result = SUT.isDateYesterday(Date())
        
        XCTAssertTrue(result)
    }
}
