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
	let availableDays = List<AvailableDayDAO>()
	let activities = List<ActivityDAO>()
	
	
	convenience init(_ context : Context) {
		self.init()
		
		self.title = context.title
		
		for availableDay in context.availableDays {
			self.availableDays.append(AvailableDayDAO(availableDay))
		}
	}
	
}
