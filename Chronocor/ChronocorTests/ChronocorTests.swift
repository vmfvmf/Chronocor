//
//  ChronocorTests.swift
//  ChronocorTests
//
//  Created by Vinicius Martins Ferraz on 18/11/17.
//  Copyright © 2017 Vinicius Martins Ferraz. All rights reserved.
//

import XCTest
import EventKit

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
    
    func testCheckCalendarAuthorizationStatus() {
        let status = EKEventStore.authorizationStatus(for: EKEntityType.event)
        
        switch (status) {
        case EKAuthorizationStatus.notDetermined:
            // This happens on first-run
            NSLog("Indeterminado")
        case EKAuthorizationStatus.authorized:
            // Things are in line with being able to show the calendars in the table view
            NSLog("Autorizado")
        case EKAuthorizationStatus.restricted, EKAuthorizationStatus.denied:
            // We need to help them give us permission
            NSLog("Não autorizado")
        }
    }
    
    func testRequestAccessToCalendar() {
        let eventStore = EKEventStore()
        eventStore.requestAccess(to: EKEntityType.event, completion: {
            (accessGranted: Bool, error: Error?) in
            if accessGranted {
                NSLog("Autorizado")
            } else {
                assertionFailure("Não autorizado")
            }
            if(error != nil){
                assertionFailure((error?.localizedDescription)!)
            }
        })
    }
    
    func testCreateCalendar(){
        let eventStore = EKEventStore()
        let calendar = EKCalendar(for: .event, eventStore: eventStore)
        calendar.title = "Chronocor"
        calendar.source = eventStore.sources.filter{
                (source: EKSource) -> Bool in
                source.sourceType.rawValue == EKSourceType.local.rawValue
            }.first!
        do {
            try eventStore.saveCalendar(calendar, commit: true)
        }catch {
            assertionFailure("Erro ao salvar calendário" + (error as NSError).localizedDescription)
        }
    }
    
    func testChronocorExists(){
        if(getChronocor() == nil) {
            assertionFailure("chronocor não existe")
        }else {
            NSLog("Chronocor existe")
        }
    }
    
    func getChronocor() -> EKCalendar?{
        let eventStore = EKEventStore()
        for calendar in eventStore.calendars(for: .event){
            if calendar.title == "Chronocor" {
                return calendar
            }
        }
        return nil
    }
    
    func testCreateEventInCalendar(){
        let eventStore = EKEventStore()
        let newEvent = EKEvent(eventStore: eventStore)
        
        for calendar in eventStore.calendars(for: .event){
            //NSLog("Calendário:" + calendar.title)
            if calendar.title == "Chronocor" {
                newEvent.calendar = calendar
                newEvent.title = "TRABALHO"
                newEvent.startDate = Calendar.current.date(byAdding: .day, value: -30, to: NSDate() as Date!)
                newEvent.endDate = Calendar.current.date(byAdding: .hour, value: 1, to: newEvent.startDate)
                do {
                    try eventStore.save(newEvent, span: .thisEvent, commit: true)
                } catch {
                    assertionFailure("Erro ao salvar calendário" + (error as NSError).localizedDescription)
                }
                return
            }
        }
        assertionFailure("Calendário não localizado.")
    }
    
    
    
    func testGetEventsOfPeriod(){
        let eventStore = EKEventStore()
        let calendars = eventStore.calendars(for: .event)
        for calendar in calendars {
            if calendar.title == "Chronocor" {
                NSLog("Calendario Chronocor")
                let inicio = Calendar.current.date(byAdding: DateComponents(day: -10), to: NSDate() as Date)!
                NSLog("Inicio: " + inicio.description)
                let fim = Calendar.current.date(byAdding: DateComponents(day: 10), to: inicio)!
                NSLog("Fim: " + fim.description)
                let predicate = eventStore.predicateForEvents(
                    withStart: inicio,
                    end: fim,
                    calendars: [calendar])
                NSLog("Qtd: " + eventStore.events(matching: predicate).count.description)
                for event in eventStore.events(matching: predicate){
                //eventStore.enumerateEvents(matching: predicate){ (event, stop) in
                    NSLog("Evento: " + event.title + event.startDate.description)
                }
            }
        }
    }
}

extension Date {
    public func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
}
