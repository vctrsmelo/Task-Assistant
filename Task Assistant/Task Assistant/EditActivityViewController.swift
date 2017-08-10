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
    
    case daveViewController
    case activityViewController

}

enum DateBeingModified{
    
    case startingDate
    case endingDate
    
}

class EditActivityViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource{
    
    var activity: Activity!
    var origin : OriginViewController!
    
    @IBOutlet weak var deleteProjectButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    //date picker
    @IBOutlet weak var datePickerContainerView: UIView!
    @IBOutlet weak var sendButtonDatePicker: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    private var dateBeingModified: DateBeingModified!
    
    @IBOutlet weak var estimatedHoursContainerView: UIView!
    @IBOutlet weak var estimatedHoursPickerView: UIPickerView!
    @IBOutlet weak var sendButtonEstimatedHours: UIButton!
    private var estimatedHours: Int = 0
    private var estimatedMinutes: Int = 0
    
    @IBOutlet weak var importanceContainerView: UIView!
    @IBOutlet weak var lowImportanceButton: UIButton!
    @IBOutlet weak var mediumImportanceButton: UIButton!
    @IBOutlet weak var highImportanceButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideComponents()
        
        estimatedHoursPickerView.dataSource = self
        estimatedHoursPickerView.delegate = self
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.tableFooterView = UIView()
        
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(EditActivityViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
        
    }
    
    
    private func hideComponents(){
        
        datePickerContainerView.isHidden = true
        estimatedHoursContainerView.isHidden = true
        importanceContainerView.isHidden = true
        
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
                cell.tag = 1
                return cell
            
            case 1: //project starting date
                let cell = tableView.dequeueReusableCell(withIdentifier: "editDateTableViewCell", for: indexPath) as! EditDateTableViewCell

                cell.date = project.startDate
                cell.dateLabel.text = "Starting Date:"
                let formatter = DateFormatter()
                formatter.dateFormat = "MM/dd/yyyy"
                cell.dateValue.text = formatter.string(from: project.startDate)
                cell.tag = 2
                
                cell.dateValue.isUserInteractionEnabled = true
                let tap = UITapGestureRecognizer(target: self, action: #selector(self.displayStartingDateUpdateComponent))
                cell.dateValue.addGestureRecognizer(tap)
                
                return cell
            
            case 2: //project ending date
                let cell = tableView.dequeueReusableCell(withIdentifier: "editDateTableViewCell", for: indexPath) as! EditDateTableViewCell
                
                cell.date = project.endDate
                cell.dateLabel.text = "Ending Date:"
                let formatter = DateFormatter()
                formatter.dateFormat = "MM/dd/yyyy"
                cell.dateValue.text = formatter.string(from: project.endDate)
                cell.tag = 3
                
                cell.dateValue.isUserInteractionEnabled = true
                let tap = UITapGestureRecognizer(target: self, action: #selector(self.displayEndingDateUpdateComponent))
                cell.dateValue.addGestureRecognizer(tap)
                
                return cell
            
            case 3: //project estimated time
                let cell = tableView.dequeueReusableCell(withIdentifier: "editEstimatedTimeViewCell", for: indexPath) as! EditEstimatedTimeTableViewCell
                cell.timeInterval = project.estimatedTime
                cell.estimatedTimeLabel.text = "Estimated Time:"
                cell.estimatedTimeValue.text = project.estimatedTime.toString()
                cell.tag = 4
                
                cell.estimatedTimeValue.isUserInteractionEnabled = true
                let tap = UITapGestureRecognizer(target: self, action: #selector(self.displayEstimatedTimeUpdateComponent))
                cell.estimatedTimeValue.addGestureRecognizer(tap)
                
                return cell
            
            case 4:// project priority
                let cell = tableView.dequeueReusableCell(withIdentifier: "editItemSelectionTableViewCell", for: indexPath) as! EditItemSelectionTableViewCell
                cell.tag = 5
                switch(project.priority){
                    
                case .canBeRescheduled:
                    cell.selectedIndex = 1
                    cell.itemSelectedLabel.text = "It can be rescheduled"
                    break
                case .shouldNotBeRescheduled:
                    cell.selectedIndex = 2
                    cell.itemSelectedLabel.text = "It should not be rescheduled"
                    break
                    
                case .cannotBeRescheduled:
                    cell.selectedIndex = 3
                    cell.itemSelectedLabel.text = "It can not be rescheduled"
                    break
                    
                }
                
                cell.itemSelectedLabel.isUserInteractionEnabled = true
                let tap = UITapGestureRecognizer(target: self, action: #selector(self.displayPriorityUpdateComponent))
                cell.itemSelectedLabel.addGestureRecognizer(tap)
                
                return cell
                
            default: // error. Should never reach here
                print("[Error] EditActivityViewController - tableView cellForRowAtIndexPath: identifier not found")
                break
                
            }
            
            
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "error", for: indexPath)
        return cell
        
    }
    
    @objc private func displayStartingDateUpdateComponent(sender:UITapGestureRecognizer){
        
        if let project = activity as? Project{
            
            datePicker.date = project.startDate
            
            self.dateBeingModified = .startingDate
            datePickerContainerView.isHidden = false

        }
        
    }
    
    @objc private func displayEndingDateUpdateComponent(sender:UITapGestureRecognizer){
        
        
        if let project = activity as? Project{
            
            datePicker.date = project.endDate
            datePicker.minimumDate = project.startDate
            
            self.dateBeingModified = .endingDate
            datePickerContainerView.isHidden = false

        }
        
    }
    
    @objc private func displayEstimatedTimeUpdateComponent(sender:UITapGestureRecognizer){
        
        estimatedHoursContainerView.isHidden = false
        
    }
    
    @objc private func displayPriorityUpdateComponent(sender:UITapGestureRecognizer){
        
        importanceContainerView.isHidden = false
        
    }
    
    
    
    @IBAction func cancelEditTouched(_ sender: UIBarButtonItem) {
        
        performUnwind()
        
    }
    
    @IBAction func doneEditTouched(_ sender: UIBarButtonItem) {
        
        if let project = activity as? Project{
            
            let title = (self.view.viewWithTag(1) as? EditTextTableViewCell)!.textField.text!
            let startingDate = (self.view.viewWithTag(2) as? EditDateTableViewCell)!.date!
            let endingDate = (self.view.viewWithTag(3) as? EditDateTableViewCell)!.date!
            let estimatedTime = (self.view.viewWithTag(4) as? EditEstimatedTimeTableViewCell)!.timeInterval!
            print((self.view.viewWithTag(5) as? EditItemSelectionTableViewCell)!.selectedIndex)
            let priority = Priority(rawValue: (self.view.viewWithTag(5) as? EditItemSelectionTableViewCell)!.selectedIndex)!
            
            let projectUpdated = Project(title: title, estimatedTime: estimatedTime, priority: priority, startDate: startingDate, endDate: endingDate, uniqueID: project.uniqueID)
            
            
            _ = ProjectDAO.save(projectUpdated, update: true)
            
        }
        
        performUnwind()
        
    }
    
    @IBAction func deleteProjectButtonTouched(_ sender: UIButton) {
        
        //delete project from database
        //perform unwind to DaveViewController
        
        if let project = activity as? Project{
            
            let deleted = ProjectDAO.delete(project)
            
            print("Project was deleted? \(deleted)")
            
        }
        
        performSegue(withIdentifier: "unwindSegueToDaveViewController", sender: self)
        
    }
    
    @IBAction func sendEstimatedHoursButtonTouched(_ sender: UIButton) {
    
        if let project = activity as? Project{
            
            project.estimatedTime = TimeInterval(estimatedHours*3600+estimatedMinutes*60)
            
        }
        estimatedHoursContainerView.isHidden = true
        self.tableView.reloadData()
    }

    
    @IBAction func sendDateButtonTouched(_ sender: UIButton) {
        
        if let project = activity as? Project{
            
            switch dateBeingModified!{
                
            case .startingDate:
                project.startDate = datePicker.date
                
                if project.startDate.isAfter(dateToCompare: project.endDate){
                    
                    project.endDate = datePicker.date
                    
                }
                
                break
            
            case .endingDate:
                project.endDate = datePicker.date
                break

            }
        }
        
        datePickerContainerView.isHidden = true
        self.tableView.reloadData()
        
    }
    
    @IBAction func sendLowImportanceButtonTouched(_ sender: UIButton) {

        if let project = activity as? Project{
        
            project.priority = .canBeRescheduled
        
        }
        
        importanceContainerView.isHidden = true
        self.tableView.reloadData()
        
    }
    
    
    @IBAction func sendMediumImportanceTouched(_ sender: UIButton) {

        if let project = activity as? Project{
            
            project.priority = .shouldNotBeRescheduled
            
        }
        
        importanceContainerView.isHidden = true
        self.tableView.reloadData()
        
    }
    
    @IBAction func sendHighImportanceButtonTouched(_ sender: UIButton) {
 
        if let project = activity as? Project{
            
            project.priority = .cannotBeRescheduled
            
        }
        
        importanceContainerView.isHidden = true
        self.tableView.reloadData()
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if(component == 0){
            
            return 1000
            
        }
        
        return 60
        
    }
    
    //Estimated time data source
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        
        return estimatedHoursContainerView.frame.size.width/3.3
        
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        pickerLabel.textAlignment = .left
        let titleData = String(row)
        
        let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: ".SFUIText-Medium", size: 20.0)!,NSForegroundColorAttributeName:UIColor.black])
        pickerLabel.attributedText = myTitle
        
        return pickerLabel
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0{
            estimatedHours = row
            
        }else{
            estimatedMinutes = row
            
        }
        
        
    }
    
    private func performUnwind(){
        
        if(self.origin == nil){ print("[Error] EditActivityViewControler - perfomrUnwind: origin is nil") }
        
        switch (self.origin!){
            
        case .daveViewController:
            performSegue(withIdentifier: "unwindSegueToDaveViewController", sender: self)
            break
            
        case .activityViewController:
            performSegue(withIdentifier: "unwindSegueToActivityViewController", sender: self)
            break
            
        }
        
    }
    
    
    
}
