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
	dynamic var available = false
	dynamic var weekday = 0
	dynamic var startTime : Date? = nil
	dynamic var endTime : Date? = nil
	
	convenience init(_ availableDay : AvailableDay) {
		self.init()
		
		self.available = availableDay.available
		self.weekday = availableDay.weekday
		self.startTime = availableDay.startTime
		self.endTime = availableDay.endTime
	}
	
	func intoAvailableDay() -> AvailableDay {
		return AvailableDay(available: self.available, weekday: self.weekday, startTime: self.startTime, endTime: self.endTime)
	}
}
