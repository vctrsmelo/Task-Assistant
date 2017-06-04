//
//  Context.swift
//  Task Assistant
//
//  Created by Rodrigo Cardoso Buske on 31/05/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

import Foundation

class Context {
	// MARK: Private Properties
	private var _uniqueID : String
	private var _title : String
	private var _availableDays : [AvailableDay]
	private var _activities : [Activity]
	
	// MARK: Public Properties
	var uniqueID : String {
		return _uniqueID
	}
	
	var title : String {
		get {
			return _title
		}
		set {
			_title = newValue
		}
	}
	var availableDays : [AvailableDay] {
		get {
			return _availableDays
		}
		set {
			_availableDays = newValue
		}
	}
	var activities : [Activity] {
		get {
			return _activities
		}
		set {
			_activities = newValue
		}
	}
	
	// MARK: Initializer
	init(title: String, availableDays: [AvailableDay], activities: [Activity] = [Activity](), uniqueID: String = UUID().uuidString) {
		self._uniqueID = uniqueID
		self._title = title
		self._availableDays = availableDays
		self._activities = activities
	}
}
