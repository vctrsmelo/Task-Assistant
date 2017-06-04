//
//  Activity.swift
//  Task Assistant
//
//  Created by Rodrigo Cardoso Buske on 30/05/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

import Foundation

enum Priority : Int {
	case canBeRescheduled = 1, shouldNotBeRescheduled, cannotBeRescheduled
}

class Activity {
	// MARK: Private Properties
	private var _title : String
	private var _estimatedTime : TimeInterval
	private var _priority : Priority
	private var _finished = false
	
	// MARK: Public Properties
	var title : String {
		get {
			return _title
		}
		set {
			_title = newValue
		}
	}
	var estimatedTime : TimeInterval {
		get {
			return _estimatedTime
		}
		set {
			_estimatedTime = newValue
		}
	}
	var priority : Priority {
		get {
			return _priority
		}
		set {
			_priority = newValue
		}
	}
	var finished : Bool {
		get {
			return _finished
		}
		set {
			_finished = newValue
		}
	}
	
	// MARK: Initializer
	init(title: String, estimatedTime: TimeInterval, priority: Priority) {
		self._title = title
		self._estimatedTime = estimatedTime
		self._priority = priority
	}
}
