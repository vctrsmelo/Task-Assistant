//
//  User.swift
//  Task Assistant
//
//  Created by Rodrigo Cardoso Buske on 31/05/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

import Foundation

class User {
	// MARK: Private Properties
	private var _name : String
	private var _contexts : [Context]
	
	// MARK: Public Properties
	var name : String {
		get {
			return _name
		}
		set {
			_name = newValue
		}
	}
	var contexts : [Context] {
		get {
			return _contexts
		}
		set {
			_contexts = newValue
		}
	}
	
	// MARK: Initializer
	init(name: String, contexts: [Context]) {
		self._name = name
		self._contexts = contexts
	}
}
