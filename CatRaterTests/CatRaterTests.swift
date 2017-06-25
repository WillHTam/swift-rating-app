//
//  CatRaterTests.swift
//  CatRaterTests
//
//  Created by William on 21/6/17.
//  Copyright © 2017 William T. All rights reserved.
//

import XCTest
@testable import CatRater

// Two kinds of tests
// Functional test to check that everything is producing the values expected
// Performance tests to check that the code is performing quickly enough
// Test cases are simply methods that the system automatically runs as part of your unit test. To create a test case, create a method whose name starts with the word 'test'.

class CatRaterTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
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
    
    //MARK: Cat Class Tests
    
    // Confirm that the Cat initializer returns a Cat object when passed valid parameters
    func testCatInitializationSucceeds() {
        // Will automatically run when the unit tests are run
        // XCTAssertNotNil checks that the returned Cat object is not nil
        // Tests a Zero rating
        let zeroRatingCat = Cat.init(name: "Zero", photo: nil, rating: 0)
        XCTAssertNotNil(zeroRatingCat)
        
        // Tests the Highest rating
        let positiveRatingCat = Cat.init(name: "Positive", photo: nil, rating: 5)
        XCTAssertNotNil(positiveRatingCat)
        
        // These calls should fail and thus XCTAssertNil should confirm
        // Negative rating
        let negativeRatingCat = Cat.init(name: "Negative", photo: nil, rating: -1)
        XCTAssertNil(negativeRatingCat)
        
        // Rating exceeds maximum
        let largeRatingCat = Cat.init(name: "Large", photo: nil, rating:6)
        XCTAssertNil(largeRatingCat)
        
        // Empty String
        let emptyStringCat = Cat.init(name: "", photo: nil, rating: 0)
        XCTAssertNil(emptyStringCat)
    }
    
    
}
