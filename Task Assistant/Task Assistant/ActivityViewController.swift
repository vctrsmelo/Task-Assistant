//
//  ActivityViewController.swift
//  Task Assistant
//
//  Created by Rodrigo Cardoso Buske on 05/07/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

import UIKit

class ActivityViewController: UIViewController {

	var project : Project?
	var task : Task?
	
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var startDayMonthView: DayMonthView!
	@IBOutlet weak var endDayMonthView: DayMonthView!
	@IBOutlet weak var hiddenPickerView: UIView!
	@IBOutlet weak var progressBar: UIProgressView!
	@IBOutlet weak var workedHoursLabel: UILabel!
	@IBOutlet weak var needHoursLabel: UILabel!
	@IBOutlet weak var importanceLabel: UILabel!
    @IBOutlet weak var editButton: UIBarButtonItem!
	
	@IBOutlet weak var completeButton: UIButton!
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.progressBar.transform = self.progressBar.transform.scaledBy(x: 1, y: 3)
		
		//self.navigationItem.rightBarButtonItem = self.editButtonItem // TODO: Not editable at the moment, so not showing button
        
		if let currentProject = self.project {
			
			self.titleLabel.text = currentProject.title
			self.startDayMonthView.date = currentProject.startDate
			self.endDayMonthView.date = currentProject.endDate
			self.progressBar.setProgress(0, animated: true) // TODO: Get the current completion value
			self.workedHoursLabel.text = "\(0) hours" // TODO: Use correct value here too
			self.needHoursLabel.text = "\(Int(currentProject.estimatedTime/60/60)) hours"
			self.importanceLabel.text = currentProject.priority.toString()
			
		} else if let currentTask = self.task {
			
			self.titleLabel.text = currentTask.title // TODO: Finish
			
		}
		
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if self.project != nil{
            
            if let currentProject = ProjectDAO.load(self.project!.uniqueID){
                
                self.project = currentProject
                
                self.titleLabel.text = currentProject.title
                self.startDayMonthView.date = currentProject.startDate
                self.endDayMonthView.date = currentProject.endDate
                self.progressBar.setProgress(0, animated: true) // TODO: Get the current completion value
                self.workedHoursLabel.text = "\(0) hours" // TODO: Use correct value here too
                self.needHoursLabel.text = "\(Int(currentProject.estimatedTime/60/60)) hours"
                self.importanceLabel.text = currentProject.priority.toString()
                
            }
                
        } else if let currentTask = self.task {
            
            self.titleLabel.text = currentTask.title // TODO: Finish
            
        }
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
//	override func setEditing(_ editing: Bool, animated: Bool) {
//		super.setEditing(editing, animated: animated)
//	
//	}

	@IBAction func completeActivity() {
		if let currentProject = self.project {
			var difference = currentProject.estimatedTime // TODO: - worked time
			
			difference = difference / 60 / 60
			
			let messageTime = difference <= 0 ? "" : " There are still \(Int(difference)) estimated hours to go"
			
			let alert = UIAlertController(title: "Complete Project", message: "Are you sure you want to complete this project?\(messageTime)", preferredStyle: .alert)
			
			let cancel = UIAlertAction(title: "No", style: .cancel, handler: nil)
			let confirm = UIAlertAction(title: "Yes", style: .destructive, handler: { (alertAction) in
				currentProject.finished = true
				self.save()
				self.completeButton.isEnabled = false // TODO: Go back instead?
			})
			
			alert.addAction(cancel)
			alert.addAction(confirm)
			
			self.present(alert, animated: true, completion: nil)
			
		}
	}
	
	func save(){
		// TODO: Save
        if project != nil{
        
            _ = ProjectDAO.save(project!)
        
        }
        
	}
	
//    // MARK: - Navigation
//	override func unwind(for unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
//		self.project = nil
//		self.task = nil
//	}

    @IBAction func unwindToActivityView(segue: UIStoryboardSegue){
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "editActivity"{
            
            let editViewControllerDestination = segue.destination as! EditActivityViewController
            
            if self.project != nil{
            
                editViewControllerDestination.activity = self.project
            
            }else{
                
                editViewControllerDestination.activity = self.task
                
            }
            
            editViewControllerDestination.origin = .activityViewController
        
        }
        
        
        
    }

}
