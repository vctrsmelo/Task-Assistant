//
//  TaskDAO.swift
//  Task Assistant
//
//  Created by Rodrigo Cardoso Buske on 03/06/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

import Foundation
import RealmSwift

class TaskDAO : ActivityDAO {
	dynamic var dueDate = Date()
	
	convenience init(_ task : Task) {
		self.init()
		
		self.activityInit(task)
		
		self.dueDate = task.dueDate
	}
}
