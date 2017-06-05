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
		
		do {
			
			switch location {
			case .userDefault:
				realm =  try Realm()
			case .onlineServer:
				realm = nil
			}
			
		} catch let error as NSError {
			print("Error opening Realm")
			
			if error.code == 10 {
				// TODO: Make migration before releasing
				print("Migration required, instead, deleting database to be restarted")
				
				let realmURL = Realm.Configuration.defaultConfiguration.fileURL!
				let realmURLs = [
					realmURL,
					realmURL.appendingPathExtension("lock"),
					realmURL.appendingPathExtension("note"),
					realmURL.appendingPathExtension("management")
				]
				
				for URL in realmURLs {
					do {
						try FileManager.default.removeItem(at: URL)
					} catch {
						print("Error deleting database, try doing manually")
					}
				}
				
			}
			
		}
		
		return realm
	}
	
	// MARK: Public Methods
	static func save(_ object : Object, to location : DBType = .userDefault, update : Bool = false) -> Bool {
		var result = false
		
		if let realm = getRealm(location) {
			try! realm.write {
				realm.add(object, update: update)
				result = true
			}
		}
		
		return result
	}
	
	static func load (_ objectType : Object.Type, from location : DBType = .userDefault, with filter : NSPredicate? = nil) -> Results<Object>? {
		var result : Results<Object>? = nil
		
		if let realm = getRealm(location) {
			result = realm.objects(objectType)
			
			if filter != nil {
				result = result!.filter(filter!)
			}
			
			if result!.isEmpty {
				result = nil
			}
		}
		
		return result
	}
}
