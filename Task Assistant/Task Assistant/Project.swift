//
//  Project.swift
//  Task Assistant
//
//  Created by Rodrigo Cardoso Buske on 31/05/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

import Foundation

class Project : Activity {
	// MARK: Private Properties
	private var _startDate : Date
	private var _endDate : Date
	private var _tasks = [Task]()
    private var _containerProject: Project?
    private var _subProjects: [Project] = []
	
	// MARK: Public Properties
	var startDate : Date {
		get {
			return _startDate
		}
		set {
			_startDate = newValue
		}
	}
	var endDate : Date {
		get {
			return _endDate
		}
		set {
			_endDate = newValue
		}
	}
	var tasks : [Task] {
		get {
			return _tasks
		}
		set {
			_tasks = newValue
		}
	}
    
    var containerProject : Project? {
        get {
            return _containerProject
        }
        set {
            _containerProject = newValue
        }
        
    }
    
    
    var subProjects: [Project]{
        get {
            
            return _subProjects

        }
        set {
            
            _subProjects = newValue

        }
        
    }
	
	// MARK: Initializer
    init(title: String, estimatedTime: TimeInterval, priority: Priority, startDate: Date, endDate: Date, finished: Bool = false, containerProject: Project? = nil, uniqueID: String = UUID().uuidString) {
		self._startDate = startDate
		self._endDate = endDate
        self._containerProject = containerProject
		
		super.init(title: title, estimatedTime: estimatedTime, priority: priority, finished: finished, uniqueID: uniqueID)
	}
    
    func splitBetween(firstTimeBlock tb1: TimeBlock, secondTimeBlock tb2: TimeBlock) -> (proj1: Project?, proj2: Project?){
        
        let timeTb1 = TimeInterval(tb1.getAvailableTimeInHours()*60*60)
        
        //situações possiveis:
        
        //projeto está no primeiro timeblock apenas
        
        
        //projeto está no segundo timeblock apenas
        
        //projeto está nos dois timeblocks
        
        //if timeblock 1 deos not contains the project, or the time available in timeblock 1 is zero, it means the project can not be inserted into timeblock 1.
        if !tb1.contains(project: self) || Int(timeTb1) == 0 {
            
            return (nil, self)
            
        }
        
        //if timeblock 2 deos not contains the project, or the time available in timeblock 2 is zero, it means the project can not be inserted into timeblock 2.
        if !tb2.contains(project: self) || self.estimatedTime <= timeTb1 {
            
            return (self,nil)

        }
        
        //tratar evitar que projeto seja deslocado de sua data final e/ou inicial

        
//        var tb1ContainsProjectTime: Bool = tb1.getStartingDate().isBefore(dateToCompare: self.startDate) || tb1.getStartingDate().isEqual(dateToCompare: self.startDate)
//        tb1ContainsProjectTime = tb1ContainsProjectTime && (tb1.getEndingDate().isAfter(dateToCompare: self.endDate) || tb1.getEndingDate().isEqual(dateToCompare: self.endDate))
//        
//        var tb2ContainsProjectTime: Bool = tb1.getStartingDate().isBefore(dateToCompare: self.startDate) || tb1.getStartingDate().isEqual(dateToCompare: self.startDate)
//        tb2ContainsProjectTime = tb1ContainsProjectTime && (tb1.getEndingDate().isAfter(dateToCompare: self.endDate) || tb1.getEndingDate().isEqual(dateToCompare: self.endDate))
//        
//        if !tb1ContainsProjectTime{
//            
//            return (nil,nil)
//            print("[ACUMULO DE TAREFAS] project: splitBetween(tb1, tb2)")
//            
//        }
        
        //verifica se o projeto pode ser alocado pro timeTb2
        
        
        //the first project is for tb1
        let proj1 = Project(title: self.title, estimatedTime: timeTb1, priority: self.priority, startDate: self.startDate, endDate: tb1.getEndingDate(), containerProject: self)
        
        //the second project is for tb2
        let proj2 = Project(title: self.title, estimatedTime: self.estimatedTime - Double(timeTb1), priority: self.priority, startDate: tb2.getStartingDate(), endDate: self.endDate, containerProject: self)
        
        self.subProjects.append(contentsOf: [proj1,proj2])
        
        return (proj1,proj2)
        
    }
    
    func isSame(_ project: Project) -> Bool {
        
        if self.uniqueID == project.uniqueID {
            return true
        }
        
        return false
        
    }
    
}
