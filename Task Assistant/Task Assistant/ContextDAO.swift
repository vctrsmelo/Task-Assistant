//
//  ContextDAO.swift
//  Task Assistant
//
//  Created by Rodrigo Cardoso Buske on 03/06/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

import Foundation
import RealmSwift

class ContextDAO : Object {
	dynamic var uniqueID = ""
	dynamic var title = ""
	let availableDayDAOs = List<AvailableDayDAO>()
	let activityDAOs = List<PossibleActivitiesDAO>()
	
	override static func primaryKey() -> String? {
		return "uniqueID"
	}
	
	convenience init(_ context : Context) {
		self.init()
		
		self.uniqueID = context.uniqueID
		self.title = context.title
		
		for availableDay in context.availableDays {
			self.availableDayDAOs.append(AvailableDayDAO(availableDay))
		}
		
		for project in context.projects {
			self.activityDAOs.append(PossibleActivitiesDAO(project))
		}
        
        for task in context.tasks{
            self.activityDAOs.append(PossibleActivitiesDAO(task))

        }
	}
	
	func intoContext() -> Context {
		var availableDays = [AvailableDay]()
		var activities = [Activity]()
		
		for availableDayDAO in self.availableDayDAOs {
			availableDays.append(availableDayDAO.intoAvailableDay())
		}
		
		for activityDAO in self.activityDAOs {
			activities.append(activityDAO.intoActivity())
		}
        
        var tasks: [Task] = []
        var projects: [Project] = []
        
        for activity in activities{
            
            if let _ = activity as? Project{
                
                projects.append(activity as! Project)
                
            }else{
                
                tasks.append(activity as! Task)
                
            }
            
        }
		
        return Context(title: self.title, availableDays: availableDays, tasks: tasks, projects: projects, uniqueID: self.uniqueID)

    }
	
}
