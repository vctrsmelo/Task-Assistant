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
	dynamic var title = ""
	let availableDayDAOs = List<AvailableDayDAO>()
	let activityDAOs = List<ActivityDAO>()
	
	
	convenience init(_ context : Context) {
		self.init()
		
		self.title = context.title
		
		for availableDay in context.availableDays {
			self.availableDayDAOs.append(AvailableDayDAO(availableDay))
		}
		
		for activity in context.activities {
			self.activityDAOs.append(ActivityDAO(activity))
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
		
		return Context(title: self.title, availableDays: availableDays, activities: activities)
	}
	
}
