//
//  DataBaseConfig.swift
//  Task Assistant
//
//  Created by Rodrigo Cardoso Buske on 03/06/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

import Foundation
import RealmSwift

enum DBType {
	case userDefault, onlineServer
}

class DataBaseConfig {
	
	// MARK: Private Methods
	private static func getRealm(_ location : DBType = .userDefault) -> Realm? {
		var realm : Realm?
		
		switch location {
			case .userDefault:
				realm =  try! Realm()
			case .onlineServer:
				realm = nil
		}
		
		return realm
	}
	
	// MARK: Public Methods
	static func save(_ object : Object, to location : DBType = .userDefault) -> Bool {
		var result = false
		let realm = getRealm(location)
		
		try! realm?.write {
			realm!.add(object)
			result = true
		}
		
		return result
	}
}
