////
////  UnitTests.swift
////  Task Assistant
////
////  Created by Victor S Melo on 25/06/17.
////  Copyright © 2017 Victor S Melo. All rights reserved.
////
//
//import XCTest
//
//class UnitTests: XCTestCase {
//    
//    var user = User!
//    var dave = Dave!
//    var userProjects: [Project] = []
//    
//    override func setUp() {
//        super.setUp()
//        
//        dave = Dave()
//        user = User(name: "Victor", contexts: ["Main"])
//        
//        var dateComponents = DateComponents()
//        dateComponents.year = 2017
//        dateComponents.month = 6
//        dateComponents.day = 28
//        dateComponents.timeZone = TimeZone(abbreviation: "UTC") // Japan Standard Time
//        dateComponents.hour = 10
//        dateComponents.minute = 34
//        
//        // Create date from components
//        let userCalendar = Calendar.current // user calendar
//        let someDateTime = userCalendar.date(from: dateComponents)
//        
//        userProjects.append(Project(title: "1", estimatedTime: 36000, priority: 1, startDate: Date(), endDate: userCalendar.date(from: dateComponents)))
//            
//        dateComponents.day = 26
//        let date1 = userCalendar.date(from: dateComponents)
//        
//        dateComponents.day = 30
//        let date2 = userCalendar.date(from: dateComponents)
//
//        userProjects.append(Project(title: "1", estimatedTime: 36000, priority: 1, startDate: date1, endDate: date2))
//        
//        // Put setup code here. This method is called before the invocation of each test method in the class.
//    }
//    
//    override func tearDown() {
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//        super.tearDown()
//    }
//    
//    func algorithmTest(){
//        
//        for project in userProjects{
//            
//            print(project.title)
//            print("begin: \(project.startDate)")
//            print("end: \(project.endDate)")
//            print("------------------------")
//        }
//        
//    }
//    
//    func testExample() {
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//    }
//    
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
//    
//}
