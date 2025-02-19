//
//  AvailableDayDAO.swift
//  Task Assistant
//
//  Created by Rodrigo Cardoso Buske on 03/06/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

import Foundation
import RealmSwift

class AvailableDayDAO : Object {
	dynamic var uniqueID = ""
	dynamic var available = false
	dynamic var weekday = 0
	let startTime = RealmOptional<Int>()
	let endTime = RealmOptional<Int>()
	
	override static func primaryKey() -> String? {
		return "uniqueID"
	}
	
	convenience init(_ availableDay : AvailableDay) {
		self.init()
		
		self.uniqueID = availableDay.uniqueID
		self.available = availableDay.available
		self.weekday = availableDay.weekday
		self.startTime.value = availableDay.startTime
		self.endTime.value = availableDay.endTime
	}
	
	func intoAvailableDay() -> AvailableDay {
		return AvailableDay(weekday: self.weekday, startTime: self.startTime.value, endTime: self.endTime.value, available: self.available, uniqueID: self.uniqueID)
	}
}
