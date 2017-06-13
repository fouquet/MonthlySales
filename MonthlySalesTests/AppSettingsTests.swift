//
//  AppSettingsTests.swift
//  MonthlySalesTests
//
//  Created by René Fouquet on 12.06.17.
//  Copyright © 2017 René Fouquet. All rights reserved.
//

import XCTest
@testable import MonthlySales

class AppSettingsTests: XCTestCase {
    
    let SUT = AppSettings()
    let defaultsMock = DefaultsMock()
    
    override func setUp() {
        super.setUp()

        SUT.userDefaults = defaultsMock
    }
    
    override func tearDown() {
        super.tearDown()
        
        defaultsMock.key = nil
        defaultsMock.resultString = nil
    }
    
    func testSetString() {
        SUT.setString("Test", for: .username)
        
        XCTAssertEqual(defaultsMock.resultString, "Test")
        XCTAssertEqual(defaultsMock.key, Setting.username.rawValue)
    }
    
    func testGetString() {
        defaultsMock.resultString = "GetTest"
        
        let result = SUT.getStringFor(key: .username)
        
        XCTAssertEqual(result, "GetTest")
    }
}
