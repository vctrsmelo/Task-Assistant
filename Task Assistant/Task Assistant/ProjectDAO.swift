//
//  ProjectDAO.swift
//  Task Assistant
//
//  Created by Rodrigo Cardoso Buske on 03/06/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

import Foundation
import RealmSwift

class ProjectDAO : ActivityDAO {
	dynamic var startDate = Date()
	dynamic var endDate = Date()
	let tasks = List<TaskDAO>()
	
	convenience init(_ project : Project) {
		self.init()
		
		self.activityInit(project)
		
		self.startDate = project.startDate
		self.endDate = project.endDate
		
		for task in project.tasks {
			self.tasks.append(TaskDAO(task))
		}
	}
	
	func intoProject() -> Project {
		let priority = Priority(rawValue: self.priority)!
		
        return Project(title: self.title, estimatedTime: self.estimatedTime, priority: priority, startDate: self.startDate, endDate: self.endDate, finished: self.finished, containerProject: nil, uniqueID: self.uniqueID)
	}
    
    static func save(_ project : Project, on location : DBType = .userDefault, update : Bool = false) -> Bool {
        let projectDAO = ProjectDAO(project)
        
        return DataBaseConfig.save(projectDAO, to: location, update: update)
    }

    static func load(_ uniqueID: String, from location : DBType = .userDefault) -> Project? {
        
        let results =  DataBaseConfig.load(ProjectDAO.self, with: NSPredicate(format: "uniqueID = '\(uniqueID)'"))
        
        let projectDAO = results?.first as? ProjectDAO
        
        return projectDAO?.intoProject()
        
    }
    
}
