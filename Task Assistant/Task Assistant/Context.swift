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
	private var _title : String
	private var _availableDays : [AvailableDay]
	private var _activities = [Activity]()
	
	// MARK: Public Properties
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
	init(title: String, availableDays: [AvailableDay]) {
		self._title = title
		self._availableDays = availableDays
	}
}
