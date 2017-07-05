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
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		if let currentProject = self.project {
			self.titleLabel.text = currentProject.title
			self.startDayMonthView.date = currentProject.startDate
			self.endDayMonthView.date = currentProject.endDate
			self.progressBar.setProgress(0, animated: true) // TODO: Get the current completion value
			self.workedHoursLabel.text = "\(0) hours" // TODO: Use correct value here too
			self.needHoursLabel.text = "\(currentProject.estimatedTime/60/60) hours"
			self.importanceLabel.text = currentProject.priority.toString()
		}
		
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
