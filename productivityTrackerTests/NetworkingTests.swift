//
//  NetworkingTests.swift
//  productivityTrackerTests
//
//  Created by Eri on 6/11/18.
//  Copyright © 2018 Eri. All rights reserved.
//

import XCTest
@testable import productivityTracker

class NetworkingTests: XCTestCase {
    var groupUnderTest: Group!
    
    override func setUp() {
        super.setUp()
        
        groupUnderTest = Group()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        groupUnderTest = nil
        super.tearDown()
    }
    
    func testFractionOfTaskCompleted() {
        // given
        let task1 = Task()
        let task2 = Task()
        task2.isComplete = true
        groupUnderTest.task.append(task1)
        groupUnderTest.task.append(task2)
        groupUnderTest.numTasksCompleted += 1
        
        // when
        let progress = groupUnderTest.fractionOfTaskCompleted()
        
        // then
        XCTAssertEqual(progress, 0.5, accuracy: 0.0001, "Progess computed for group is wrong")
    }
    
    //    func testPerformanceExample() {
    //        // This is an example of a performance test case.
    //        self.measure {
    //            // Put the code you want to measure the time of here.
    //        }
    //    }
    
}
