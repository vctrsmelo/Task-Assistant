//
//  AvailableDay.swift
//  Task Assistant
//
//  Created by Rodrigo Cardoso Buske on 31/05/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

import Foundation

struct AvailableDay {
	// MARK: Private Properties
	private var _available : Bool
	private var _weekday : Int
	private var _startTime : Date?
	private var _endTime : Date?
	
	// MARK: Public Properties
	var available : Bool {
		get {
			return _available
		}
		set {
			_available = newValue
		}
	}
	var weekday : Int {
		get {
			return _weekday
		}
		set {
			_weekday = newValue
		}
	}
	var startTime : Date? {
		get {
			return _startTime
		}
		set {
			_startTime = newValue
		}
	}
	var endTime : Date? {
		get {
			return _endTime
		}
		set {
			_endTime = newValue
		}
	}
	
	// MARK: Initializers
	init(available: Bool, weekday: Int, startTime: Date?, endTime: Date?) {
		self._available = available
		self._weekday = weekday
		self._startTime = startTime
		self._endTime = endTime
	}
	
	init(weekday : Int) {
		self._available = false
		self._weekday = weekday
		self._startTime = nil
		self._endTime = nil
	}
}
