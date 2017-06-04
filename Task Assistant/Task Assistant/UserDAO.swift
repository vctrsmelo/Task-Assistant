//
//  UserDAO.swift
//  Task Assistant
//
//  Created by Rodrigo Cardoso Buske on 03/06/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

import Foundation
import RealmSwift

class UserDAO : Object {
	dynamic var uniqueID = ""
	dynamic var appleID = ""
	dynamic var name = ""
	let contextDAOs = List<ContextDAO>()
	
	override static func primaryKey() -> String? {
		return "uniqueID"
	}
	
	convenience init(_ user : User, appleID : String) {
		self.init()
		
		self.appleID = appleID
		self.uniqueID = user.uniqueID
		self.name = user.name
		
		for context in user.contexts {
			self.contextDAOs.append(ContextDAO(context))
		}
	}
	
	func intoUser() -> User {
		var contexts = [Context]()
		
		for contextDAO in self.contextDAOs {
			contexts.append(contextDAO.intoContext())
		}
		
		return User(name: self.name, contexts: contexts, uniqueID: self.uniqueID)
	}
	
	static func save(_ user : User, appleID : String, on location : DBType = .userDefault, update : Bool = false) -> Bool {
		let userDAO = UserDAO(user, appleID: appleID)
		
		return DataBaseConfig.save(userDAO, to: location, update: update)
	}
	
	static func load(_ appleID : String, from location : DBType = .userDefault) -> User? {
		let results = DataBaseConfig.load(UserDAO.self, from: location)
		
		let userDAO = results?.first as? UserDAO
		
		return userDAO?.intoUser()
	}
}
