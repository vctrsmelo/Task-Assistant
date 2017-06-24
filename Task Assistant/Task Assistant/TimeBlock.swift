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
    
}

class TimeBlock {
    
    private var projects: [Project]
    private var startingDate: Date
    private var endingDate: Date
    
    init(startingDate: Date, endingDate: Date, projects : [Project] = []) {
        self.startingDate = startingDate
        self.endingDate = endingDate
        self.projects = projects
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

        var dates: [Date] = []
        
        dates.append(self.startingDate)
        dates.append(self.endingDate)
        dates.append(timeBlock.startingDate)
        dates.append(timeBlock.endingDate)
        
        //order dates (using bubble sort)

        var changed: Bool
        
        repeat{
        
            changed = false
            
            for i in 0 ..< dates.count-1{
                
                if dates[i].isAfter(dateToCompare: dates[i+1]){
                    
                    changed = true
                    let d1 = dates[i]
                    dates[i] = dates[i+1]
                    dates[i+1] = d1
                    
                }

            }
            
            
        }while(changed)
        
        while(!dates.isEmpty){
            
            let strtDate = dates.removeFirst()
            let fnshDate = dates.removeFirst()
            
            var timeBlock = TimeBlock(startingDate: strtDate, endingDate: fnshDate)
            
            var projectsDictionary = splitProjectsBetweenSelfAnd(timeBlock: timeBlock)
            
        }
        
        
        
        return timeBlocks
   
    }
    
    private func splitProjectsBetweenSelfAnd(timeBlock: TimeBlock) -> [Int:[Project]]{
        
        var dicProjects: [Int:[Project]] = [:]
        
        for project in self.projects{
            
            var projSplittedArray: [Project] = project.splitBetween(firstTimeBlock: self,secondTimeBlock: timeBlock)
            
            
            
        }
        
    }
    
}
