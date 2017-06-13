
//
//  ExtensionsTests.swift
//  MonthlySales
//
//  Created by René Fouquet on 13.06.17.
//  Copyright © 2017 René Fouquet. All rights reserved.
//

import Foundation
import XCTest
@testable import MonthlySales

class DateExtensionsTests: XCTestCase {
    
    let SUT = Date()
    let dateFormatter = DateFormatter()
    
    override func setUp() {
        super.setUp()
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testIsBetween() {
        let testDate = "2017-06-14"
        let date1 = "2017-06-13"
        let date2 = "2017-06-15"
        
        let result = dateFormatter.date(from: testDate)!.isBetween(firstDate: dateFormatter.date(from: date1)!, lastDate: dateFormatter.date(from: date2)!)
        
        XCTAssertTrue(result)
    }
    
    func testIsNotBetween() {
        let testDate = "2017-07-14"
        let date1 = "2017-06-13"
        let date2 = "2017-06-15"
        
        let result = dateFormatter.date(from: testDate)!.isBetween(firstDate: dateFormatter.date(from: date1)!, lastDate: dateFormatter.date(from: date2)!)
        
        XCTAssertFalse(result)
    }

}
