//
//  Project.swift
//  Task Assistant
//
//  Created by Rodrigo Cardoso Buske on 31/05/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

import Foundation

class Project : Activity {
	// MARK: Private Properties
	private var _startDate : Date
	private var _endDate : Date
	private var _tasks = [Task]()
	
	// MARK: Public Properties
	var startDate : Date {
		get {
			return _startDate
		}
		set {
			_startDate = newValue
		}
	}
	var endDate : Date {
		get {
			return _endDate
		}
		set {
			_endDate = newValue
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
	init(title: String, estimatedTime: TimeInterval, priority: Priority, startDate: Date, endDate: Date, finished: Bool = false, uniqueID: String = UUID().uuidString) {
		self._startDate = startDate
		self._endDate = endDate
		
		super.init(title: title, estimatedTime: estimatedTime, priority: priority, finished: finished, uniqueID: uniqueID)
	}
}
