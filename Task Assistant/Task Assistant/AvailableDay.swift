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
	private var _uniqueID : String
	private var _available : Bool
	private var _weekday : Int
	private var _startTime : Int?
	private var _endTime : Int?
	
	// MARK: Public Properties
	var uniqueID : String {
		return _uniqueID
	}
	
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
	var startTime : Int? {
		get {
			return _startTime
		}
		set {
			_startTime = newValue
		}
	}
	var endTime : Int? {
		get {
			return _endTime
		}
		set {
			_endTime = newValue
		}
	}
	
	// MARK: Initializers
	init(weekday: Int, startTime: Int?, endTime: Int?, available: Bool = true, uniqueID: String = UUID().uuidString) {
		self._uniqueID = uniqueID
		self._available = available
		self._weekday = weekday
		self._startTime = startTime
		self._endTime = endTime
	}
	
	init(weekday : Int) {
		self.init(weekday: weekday, startTime: nil, endTime: nil, available: false)
	}
}
