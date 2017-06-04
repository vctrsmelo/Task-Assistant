//
//  Task.swift
//  Task Assistant
//
//  Created by Rodrigo Cardoso Buske on 31/05/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

import Foundation

class Task : Activity {
	// MARK: Private Properties
	private var _dueDate : Date
	
	// MARK: Public Properties
	var dueDate : Date {
		get {
			return _dueDate
		}
		set {
			_dueDate = newValue
		}
	}
	
	// MARK: Initializer
	init(title: String, estimatedTime: TimeInterval, priority: Priority, dueDate: Date, finished: Bool = false) {
		self._dueDate = dueDate
		
		super.init(title: title, estimatedTime: estimatedTime, priority: priority, finished: finished)
	}
}
