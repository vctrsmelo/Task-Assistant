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
	let contexts = List<ContextDAO>()
	
	convenience init(_ user : User) {
		self.init()
		
		self.name = user.name
		
		for context in user.contexts {
			self.contexts.append(ContextDAO(context))
		}
	}
	
	static func save(_ user : User, on location : DBType = .userDefault) -> Bool {
		let userDAO = UserDAO(user)
		
		return DataBaseConfig.save(userDAO, to: location)
	}
}
