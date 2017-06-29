//
//  TimeBlock.swift
//  Task Assistant
//
//  Created by Victor S Melo on 19/06/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

import Foundation

extension Date{
    
    func isAfter(dateToCompare: Date) -> Bool {
        
        if self.compare(dateToCompare) == ComparisonResult.orderedDescending{
            
            return true
            
        }
        
        return false
        
    }
    
    func isBefore(dateToCompare: Date) -> Bool {
        
        if self.compare(dateToCompare) == ComparisonResult.orderedAscending{
            
            return true
            
        }
        
        return false
        
    }
    
    func isEqual(dateToCompare: Date) -> Bool {
        
        if self.compare(dateToCompare) == ComparisonResult.orderedSame{
            
            return true
            
        }
        
        return false
        
    }
    
    func isDayAfter(dateToCompare: Date) -> Bool{
        
        return self.compareDay(dateToCompare) == ComparisonResult.orderedDescending ? true : false
        
    }
    
    func isDayBefore(dateToCompare: Date) -> Bool{
        
        return self.compareDay(dateToCompare) == ComparisonResult.orderedAscending ? true : false
        
    }
    
    func isDaySame(dateToCompare: Date) -> Bool{
        
        return self.compareDay(dateToCompare) == ComparisonResult.orderedSame ? true : false
        
    }
    
    /**
 
 
        - returns: .orderedAscending if self day is before than parameter day.
        - returns: .orderedDescending if self day is after than parameter day.
        - returns: .orderedSame if self day is equal than parameter day.
    */
    func compareDay(_ date: Date) -> ComparisonResult {
        
        
        let calendar = Calendar.current
        
        
        let selfComponents = calendar.dateComponents([.day,.month,.year], from: self)
        let selfDate = calendar.date(from: selfComponents)

        let paramComponents = calendar.dateComponents([.day , .month, .year ], from: date)
        let paramDate = calendar.date(from: paramComponents)

        if selfDate == nil || paramDate == nil{
            
            print("[Error] TimeBlock - Date extension - compareDay: selfDate or paramDate is nil")
            
        }
        return selfDate!.compare(paramDate!)
        
    }
    
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }

    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    
    func getWeekday()->Int {
        
        return Calendar.current.component(.weekday, from: self)
        
    }
    
}

class TimeBlock {
    
    private var projects: [Project]
    private var startingDate: Date
    private var endingDate: Date
    private var userAvailableDays: [AvailableDay]
    
    init(startingDate: Date, endingDate: Date, userAvailableDays: [AvailableDay], projects : [Project] = []) {
        self.startingDate = startingDate
        self.endingDate = endingDate
        self.projects = projects
        self.userAvailableDays = userAvailableDays

    }
    
    func getAvailableTimeInHours() -> Int {
        
        //de userAvailableDays, armazena apenas os horarios relacionados com este TimeBlock
        
        //loop entre dias a partir do startingDate ate endingDate
        //para cada dia, soma o tempo do availableDay correspondente em availableTime
        
        var availableTime: Int = 0
        
        let calendar = Calendar.current
        var iDate = startingDate
        while(iDate.compareDay(endingDate) != .orderedDescending){ //while iDate.day <= endingDate.day
            
            let iDateWeekDay = iDate.getWeekday()
            
            var availableDay: AvailableDay?
            
            for day in userAvailableDays{
                
                if day.weekday == iDateWeekDay{
                    
                    availableDay = day
                    break
                }
                
            }
            
            if let day = availableDay {
                
                if let startTime = day.startTime, let endTime = day.endTime {
                    
                    availableTime += endTime - startTime

                }else{
                    
                    print("[Error] TimeBlock.init - startTime or endTime not found")
                    
                }
                
            }
            
            if let newDate = calendar.date(byAdding: .day, value: 1, to: iDate){
                
                iDate = newDate
                
            }else{
                print("[Error] TimeBlock.init - newDate not found")
                
            }
           
            
        }
        
        for project in projects{
            
            availableTime -= Int(project.estimatedTime)/3600
            
        }
        
        return availableTime
        
    }
    
    func add(project: Project){
        
        self.projects.append(project)
        
    }
    
    func getProjects() -> [Project]{
        
        return self.projects
        
    }
    
    func getStartingDate() -> Date{
        
        return startingDate
        
    }
    
    func getEndingDate() -> Date{
        
        return endingDate

    }
    
    func isIntersecting(timeBlock: TimeBlock) -> Bool{
        
        let timeBlockParameterStartsInsideSelf : Bool = timeBlock.getStartingDate().isAfter(dateToCompare: self.startingDate) && timeBlock.getStartingDate().isBefore(dateToCompare: self.endingDate)
        let selfStartsInsideTimeBlockParameter : Bool = self.getStartingDate().isAfter(dateToCompare: timeBlock.getStartingDate()) && self.getStartingDate().isBefore(dateToCompare: timeBlock.getEndingDate())
        
        if(timeBlockParameterStartsInsideSelf || selfStartsInsideTimeBlockParameter){
            
            return true
            
        }
        
        return false
        
    }
    
    func getTimeBlocksResultingFromSplitWith(timeBlock: TimeBlock) -> [TimeBlock]{
    
        var timeBlocks: [TimeBlock] = []
        var projectsAux = self.projects
        projectsAux.append(contentsOf: timeBlock.getProjects())
        
        //sort projects by ending day
        projectsAux.sort { (p1, p2) -> Bool in
            return p1.endDate.isDayAfter(dateToCompare: p2.endDate) ? false : true
        }

        var dates: [Date] = []
        
        dates.append(self.startingDate)
        dates.append(self.endingDate)
        dates.append(timeBlock.startingDate)
        dates.append(timeBlock.endingDate)
        
        dates = dates.sorted()
        
        while(!(dates.count == 1)){
            
            
            let strtDate = dates.removeFirst()
            let strtDateTb2 = dates.first
            let fnshDateTb1 = Calendar.current.date(byAdding: .day, value: -1, to: strtDateTb2!)
            
            if fnshDateTb1 == nil{
                
                print("[Error] TimeBlock - getTimeBlocksResultingFromSplitWith: fnshDate is nil")
            }
            
            if dates.count == 1{ //last timeBlock
                
                let timeBlock = TimeBlock(startingDate: strtDate, endingDate: strtDateTb2!, userAvailableDays: self.userAvailableDays)

                timeBlock.projects.append(contentsOf: projectsAux)
                
                timeBlocks.append(timeBlock)
                
            }else{
            
                if let lastDate = dates.last {

                    let timeBlock = TimeBlock(startingDate: strtDate, endingDate: fnshDateTb1!, userAvailableDays: self.userAvailableDays)
                    
                    let auxSelf = TimeBlock(startingDate: strtDateTb2!, endingDate: lastDate, userAvailableDays: self.userAvailableDays)
                    
                    TimeBlock.splitProjectsBetween(timeBlock1: timeBlock,timeBlock2: auxSelf, projects: projectsAux)
                    
                    projectsAux = auxSelf.projects
                    
                    timeBlocks.append(timeBlock)
                    
                }else{
                    print("[Error] TimeBlock - getTimeBlocksResultingFromSplitWith: dates.last does not exist")
                }
            }
            
        }
        
        return timeBlocks
   
    }
    
    
    
    static public func splitProjectsBetween(timeBlock1 tb1: TimeBlock, timeBlock2 tb2 : TimeBlock, projects: [Project]){
        
        for project in projects{
            
            let projects: (proj1: Project?, proj2: Project?) = project.splitBetween(firstTimeBlock: tb1,secondTimeBlock: tb2)
            
            if let proj1 = projects.proj1{
            
                tb1.add(project: proj1)

            }
            
            if let proj2 = projects.proj2{
                
                tb2.add(project: proj2)
                
            }
            
        }
        
    }
    
    func contains(project: Project) -> Bool{
        
        if !project.startDate.isDayAfter(dateToCompare: self.endingDate) && !project.endDate.isDayBefore(dateToCompare: self.startingDate){
            
            return true
            
        }
        
        return false
        
    }
    
}
