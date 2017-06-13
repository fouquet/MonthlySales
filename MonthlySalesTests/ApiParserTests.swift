//
//  ApiParserTests.swift
//  MonthlySales
//
//  Created by René Fouquet on 13.06.17.
//  Copyright © 2017 René Fouquet. All rights reserved.
//

import XCTest
@testable import MonthlySales

class ApiParserTests: XCTestCase {
    
    let calendarMock = InternalCalendarMock()
    let formatters = Formatters()
    var SUT:ApiParser!
    
    override func setUp() {
        super.setUp()
        SUT = ApiParser(formatters: formatters)
        
        formatters.calendar = calendarMock
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testSalesParsing() {
        let apiMock = ApiMock(formatters: formatters)
        
        apiMock.getSalesDataFor(startDate: Date(), endDate: Date()) { [unowned self] (data: Data?) in
            let result = self.SUT.parseSalesData(data!)
            
            XCTAssertEqual(Decimal(541.28), result.first?.revenue)
        }
    }
    

}
