//
//  ActivityDAO.swift
//  Task Assistant
//
//  Created by Rodrigo Cardoso Buske on 03/06/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

import Foundation
import RealmSwift

class ActivityDAO : Object {
	dynamic var uniqueID = ""
	dynamic var title = ""
	dynamic var estimatedTime : TimeInterval = 0.0
	dynamic var priority = 0
	dynamic var finished = false
	
	override static func primaryKey() -> String? {
		return "uniqueID"
	}
	
	// Due to not being able to chain the inits correctly this is necessary
	func activityInit(_ activity : Activity) {
		self.uniqueID = activity.uniqueID
		self.title = activity.title
		self.estimatedTime = activity.estimatedTime
		self.priority = activity.priority.rawValue
		self.finished = activity.finished
	}
}
