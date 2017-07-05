//
//  EditActivityViewController.swift
//  Task Assistant
//
//  Created by Victor S Melo on 05/07/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

import UIKit

class EditActivityViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var activity: Activity!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.tableFooterView = UIView()
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if (activity as? Project) != nil{
            
            return 1
            
            
        }else{
            
            return 0
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch(indexPath.row){
            
        case 0:
            return EditTextTableViewCell.HEIGHT

        default:
            break
            
        }
        
        return 0
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
                let cell = tableView.dequeueReusableCell(withIdentifier: "editDateTableView", for: indexPath) as! EditDateTableViewCell
                return cell
            
            case 2: //project ending date
                let cell = tableView.dequeueReusableCell(withIdentifier: "editDateTableViewCell", for: indexPath) as! EditDateTableViewCell
                return cell
            
            case 3: //project estimated time
                let cell = tableView.dequeueReusableCell(withIdentifier: "editEstimatedTimeViewCell", for: indexPath) as! EditEstimatedTimeTableViewCell
                return cell
            
            case 4:// project priority
                let cell = tableView.dequeueReusableCell(withIdentifier: "editItemSelectionTableViewCell", for: indexPath) as! EditItemSelectionTableViewCell
                return cell
                
            default: // error. Should never reach here
                print("[Error] EditActivityViewController - tableView cellForRowAtIndexPath: identifier not found")
                break
                
            }
            
            
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "error", for: indexPath)
        return cell
        
    }
    
}
