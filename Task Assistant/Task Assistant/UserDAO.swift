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
	dynamic var name = ""
	let contextDAOs = List<ContextDAO>()
	
	convenience init(_ user : User) {
		self.init()
		
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
		
		return User(name: self.name, contexts: contexts)
	}
	
	static func save(_ user : User, on location : DBType = .userDefault) -> Bool {
		let userDAO = UserDAO(user)
		
		return DataBaseConfig.save(userDAO, to: location)
	}
	
	static func load(_ appleID : String, from location : DBType = .userDefault) -> User? {
		let results = DataBaseConfig.load(UserDAO.self, to: location)
		
		let userDAO = results?.first as? UserDAO
		
		return userDAO?.intoUser()
	}
}
