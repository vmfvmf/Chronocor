//
//  ChronocorTests.swift
//  ChronocorTests
//
//  Created by Vinicius Martins Ferraz on 18/11/17.
//  Copyright © 2017 Vinicius Martins Ferraz. All rights reserved.
//

import XCTest
@testable import Chronocor

class ChronocorTests: XCTestCase {
    
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
    
    func testCreateCalendar(){
        
    }
    
    func testCreateEventInCalendar(){
        let newEvent = EKEvent(eventStore: eventStore)
        
        newEvent.calendar = calendarForEvent
        newEvent.title = self.eventNameTextField.text ?? "Some Event Name"
        newEvent.startDate = Date
        newEvent.endDate = Date
        do {
            try eventStore.saveEvent(newEvent, span: .ThisEvent, commit: true)
            delegate?.eventDidAdd()
            
            self.dismissViewControllerAnimated(true, completion: nil)
        } catch {
            let alert = UIAlertController(title: "Event could not save", message: (error as NSError).localizedDescription, preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alert.addAction(OKAction)
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
}
