//
//  ActivitiesViewController.swift
//  Task Assistant
//
//  Created by Victor S Melo on 07/07/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

import UIKit

class ActivitiesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var dave: Dave!
    var activities: [Activity] = []
    @IBOutlet weak var tableView: UITableView!
    var selectedActivity: Activity!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dave = Dave.getDave()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        activities.removeAll()
        
        if let projects = ProjectDAO.loadAll(){
            
            let timeBlocks = dave.getTimeBlocks(projects: projects)

            for tb in timeBlocks{
                
                let splitedProjects = tb.getProjects()
                for proj in splitedProjects{
                    
//                    if proj.containerProject != nil{
//                        
//                        for i in 0 ..< proj.containerProject!.subProjects.count{
//                            
//                            if proj.containerProject!.subProjects[i].isSame(proj){
//                                
//                                proj.title = proj.title+" (part \(i+1))"
//                                
//                            }
//                            
//                        }
//                        
//                    }
                    
                    activities.append(proj)
                    
                }
                
            }
            
        }
        
        self.tableView.reloadData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "activityCell", for: indexPath)

        cell.textLabel?.text = activities[indexPath.row].title
        cell.detailTextLabel?.text = activities[indexPath.row].estimatedTime.toString()

        return cell
    }
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 1
//    }
//    
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return activities.count
//        
//    }
//    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "activityCell", for: indexPath)
//        
//        cell.textLabel?.text = activities[indexPath.row].title
//        cell.detailTextLabel?.text = activities[indexPath.row].estimatedTime.toString()
//        
//        return cell
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let project = activities[indexPath.row] as? Project{
            
            if project.containerProject != nil{
                
                selectedActivity = project.containerProject
                
            }else{
                
                selectedActivity = project
                
            }
            
        }
        
        performSegue(withIdentifier: "activitiesToActivitySegue", sender: self)
        
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "activitiesToActivitySegue" {
            let destination = segue.destination as! ActivityViewController
            
            if let project = selectedActivity as? Project{
                
                destination.project = project
                
            }
            
            // TODO: Pick Correct project
        }
        
    }
    
    //	@IBAction func prepare(for unwind : UIStoryboardSegue) {
    //		self.tableView.reloadData()
    //	}
    
}
