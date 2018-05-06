//
//  SwiftyScryptoStringTests.swift
//  SwiftyScryptoStringTests
//
//  Created by Perry Shalev on 06/05/2018.
//  Copyright © 2018 Perry Sh. All rights reserved.
//

import XCTest
@testable import SwiftyScryptoString

class SwiftyScryptoStringTests: XCTestCase {
    
    static let PHRASE_TO_TEST: String = "my secret string"
    static let PASSWORD_TO_TEST: String = "my secret password"

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        let encrypted = SwiftyScryptoStringTests.PHRASE_TO_TEST.encrypt(withPassword: SwiftyScryptoStringTests.PASSWORD_TO_TEST)
        let decrypted = SwiftyScryptoStringTests.PASSWORD_TO_TEST.decrypt(withPassword: encrypted)

        assert(decrypted == SwiftyScryptoStringTests.PHRASE_TO_TEST, "Error: the decrypted string is not identical to the original string!")
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
