//
//  Context.swift
//  Task Assistant
//
//  Created by Rodrigo Cardoso Buske on 31/05/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

import Foundation

class Context {
	// MARK: Private Properties
	private var _uniqueID : String
	private var _title : String
	private var _availableDays : [AvailableDay]
    private var _projects: [Project]
	private var _tasks : [Task]
    
    public var isActivitiesOrdered = false
	
	// MARK: Public Properties
	var uniqueID : String {
		return _uniqueID
	}
	
	var title : String {
		get {
			return _title
		}
		set {
			_title = newValue
		}
	}
	var availableDays : [AvailableDay] {
		get {
			return _availableDays
		}
		set {
			_availableDays = newValue
		}
	}
    
	var projects : [Project] {
		get {
			return _projects
		}
		set {
			_projects = newValue
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
    
    
	
	// MARK: Initializer
    init(title: String, availableDays: [AvailableDay], tasks: [Task] = [Task](), projects: [Project] = [Project](), uniqueID: String = UUID().uuidString) {
        
        self._uniqueID = uniqueID
        self._title = title
        self._availableDays = availableDays
        self._tasks = tasks
        self._projects = projects
        
    }
    
    func getNextTask() -> Task?{
        
        return tasks.first
        
    }
    
    func add(project: Project){
        
        projects.append(project)
        
    }
    
    func add(task: Task){
        
        tasks.append(task)
        
    }
    
}
