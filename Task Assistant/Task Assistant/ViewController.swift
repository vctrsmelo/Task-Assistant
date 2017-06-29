//
//  ViewController.swift
//  Task Assistant
//
//  Created by Victor S Melo on 29/05/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	static let myAppleId = "ItsaMeMario"
	static var user : User!
	

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

		self.smallTestCase()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
	
	// Some simple tests, TODO: Delete when not useful anymore
	func smallTestCase() {
		print("Will begin process")
		
		if let userTest = UserDAO.load(ViewController.myAppleId) {
			ViewController.user = userTest
			print("Loaded User")
			
			if DataBaseConfig.load(ProjectDAO.self, from: DBType.userDefault, with: NSPredicate(format: "title = %@", "Great Project")) != nil {
				print("Project Exists")
			} else {
				print("Creating Project")
				
				let projectTask = Task(title: "Project Task", estimatedTime: 100, priority: Priority.canBeRescheduled, dueDate: Date().addingTimeInterval(100))
				
				let project = Project(title: "Great Project", estimatedTime: 10000, priority: Priority.shouldNotBeRescheduled, startDate: Date(), endDate: Date().addingTimeInterval(10000))
				project.tasks.append(projectTask)
				
				let task = Task(title: "Task Alone", estimatedTime: 5000, priority: Priority.cannotBeRescheduled, dueDate: Date().addingTimeInterval(10340))
				
				ViewController.user.contexts.first!.projects.append(project)
				ViewController.user.contexts.first!.tasks.append(task)
				
				if UserDAO.save(ViewController.user, appleID: ViewController.myAppleId, on: DBType.userDefault, update: true) {
					print("Saved Project")
				} else {
					print("Failed to save project")
				}
			}
		
		} else {
			print("Will Create User")
			let availableDay = AvailableDay(weekday: 4, startTime: 7, endTime: 15)
			let nonAvailableDay = AvailableDay(weekday: 3)
			let context = Context(title: "Work", availableDays: [nonAvailableDay, availableDay])
			ViewController.user = User(name: "Luigi", contexts: [context])
			
			print("User Created")
			print("Will save User")
			
			if UserDAO.save(ViewController.user, appleID: ViewController.myAppleId) {
				print("Saved User")
			} else {
				print("Failed to save User")
			}
		}
		
		print("Finished")
	}
}

