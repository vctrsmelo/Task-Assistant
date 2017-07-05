//
//  EditActivityViewController.swift
//  Task Assistant
//
//  Created by Victor S Melo on 05/07/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

import UIKit

extension TimeInterval{
    
    func toString() -> String {
        
        let ti = Int(self)
        
        let minutes = (ti / 60) % 60
        let hours = (ti / 3600)
        
        return "\(hours)h \(minutes)min"
    }
    
}

enum OriginViewController {
    case chatViewController
    case activityViewController
}

class EditActivityViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var activity: Activity!
    var origin : OriginViewController!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.tableFooterView = UIView()
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if (activity as? Project) != nil{
            
            return 5
            
            
        }else{
            
            return 0
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch(indexPath.row){
            
        case 0:
            return EditTextTableViewCell.HEIGHT

        case 1:
            return EditDateTableViewCell.HEIGHT
            
        case 2:
            return EditDateTableViewCell.HEIGHT
            
        case 3:
            return EditEstimatedTimeTableViewCell.HEIGHT
            
        case 4:
            return EditItemSelectionTableViewCell.HEIGHT
            
        default:
            break
            
        }
        
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let project = activity as? Project{
            
            switch(indexPath.row){
                
            case 0: //project title
                let cell = tableView.dequeueReusableCell(withIdentifier: "editTextTableViewCell", for: indexPath) as! EditTextTableViewCell
                cell.textField.text = project.title
                print("veio aqui!")
                return cell
            
            case 1: //project starting date
                let cell = tableView.dequeueReusableCell(withIdentifier: "editDateTableViewCell", for: indexPath) as! EditDateTableViewCell
                
                cell.dateLabel.text = "Starting Date:"
                let formatter = DateFormatter()
                formatter.dateFormat = "MM/dd/yyyy"
                cell.dateValue.text = formatter.string(from: project.startDate)
                
                return cell
            
            case 2: //project ending date
                let cell = tableView.dequeueReusableCell(withIdentifier: "editDateTableViewCell", for: indexPath) as! EditDateTableViewCell
                
                cell.dateLabel.text = "Ending Date:"
                let formatter = DateFormatter()
                formatter.dateFormat = "MM/dd/yyyy"
                cell.dateValue.text = formatter.string(from: project.endDate)
                
                return cell
            
            case 3: //project estimated time
                let cell = tableView.dequeueReusableCell(withIdentifier: "editEstimatedTimeViewCell", for: indexPath) as! EditEstimatedTimeTableViewCell
                cell.estimatedTimeLabel.text = "Estimated Time:"
                cell.estimatedTimeValue.text = project.estimatedTime.toString()
                
                return cell
            
            case 4:// project priority
                let cell = tableView.dequeueReusableCell(withIdentifier: "editItemSelectionTableViewCell", for: indexPath) as! EditItemSelectionTableViewCell
            
                switch(project.priority){
                    
                case .canBeRescheduled:
                    cell.itemSelectedLabel.text = "It can be rescheduled"
                    break
                case .shouldNotBeRescheduled:
                    cell.itemSelectedLabel.text = "It should not be rescheduled"
                    break
                    
                case .cannotBeRescheduled:
                    cell.itemSelectedLabel.text = "It can not be rescheduled"
                    break
                    
                }
                
                return cell
                
            default: // error. Should never reach here
                print("[Error] EditActivityViewController - tableView cellForRowAtIndexPath: identifier not found")
                break
                
            }
            
            
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "error", for: indexPath)
        return cell
        
    }
    
    @IBAction func cancelEditTouched(_ sender: UIBarButtonItem) {
        
        performUnwind()
        
    }
    
    @IBAction func doneEditTouched(_ sender: UIBarButtonItem) {
        
        performUnwind()
        
    }
    
    private func performUnwind(){
        
        
        
    }
    
    
    
}
