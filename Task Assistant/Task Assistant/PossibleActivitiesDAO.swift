//
//  PossibleActivities.swift
//  Task Assistant
//
//  Created by Rodrigo Cardoso Buske on 04/06/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

import Foundation
import RealmSwift

class PossibleActivitiesDAO : Object {
	dynamic var uniqueID = ""
	dynamic var projectDAO : ProjectDAO?
	dynamic var taskDAO : TaskDAO?
	
	override static func primaryKey() -> String? {
		return "uniqueID"
	}
	
	convenience init(_ activity : Activity) {
		self.init()
		
		if let project = activity as? Project {
			self.taskDAO = nil
			self.projectDAO = ProjectDAO(project)
			self.uniqueID = self.projectDAO!.uniqueID
		} else {
			let task = activity as! Task
			self.projectDAO = nil
			self.taskDAO = TaskDAO(task)
			self.uniqueID = self.taskDAO!.uniqueID
		}
		
	}
	
	func intoActivity() -> Activity {
		
		if self.projectDAO != nil {
			return self.projectDAO!.intoProject()
		} else {
			return self.taskDAO!.intoTask()
		}
		
	}
}
