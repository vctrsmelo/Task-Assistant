//
//  ChatManager.swift
//  Task Assistant
//
//  Created by Victor S Melo on 04/06/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

import UIKit

enum DaveAction {
    
    case none
    case askedProjectName
    case askedUserName
    case askedProjectStartingDate
    case askedProjectEndingDate
    case askedWorkingDays
    case presentedHome
    case askedEstimatedHours
    case askedProjectImportance
    case addedNewProject
    case needToTypeNextActivity
    case askedToSelectAProject
    
}

enum DaveFlow{
    
    case none
    case creatingUserAccount
    case creatingProject
    case notAvailableTime
    
}

protocol DaveDelegate: class{
    
    func actionUpdated(action: DaveAction)
    func flowUpdated(flow: DaveFlow)
    
}

struct ProjectData {
    var name: String?
    var startingDate : Date?
    var endingDate : Date?
    var estimatedSeconds: Int?
    var priority: Priority?
    
    init() {
        
    }
    
}

struct UserData {
    
    var name : String?
    var contexts : [Context] = []
    
    init(){
        
    }
    
}

class Dave: NSObject, ChatCollectionViewDelegate {

    private(set) var messages: [String] = []
    private(set) var indexOfNextMessageToSend = 0
    private(set) var messagesSent = 0
    var user: User?
    private(set) var currentAction: DaveAction
    private(set) var currentFlow: DaveFlow
    private let chatView : ChatCollectionView
    
    public weak var delegate : DaveDelegate?
    
    //user creation variables
    private var userName: String?
    private var userContexts: [Context]?
    
    //project creation variables
    private var projectBeingCreated : ProjectData?
    private var userBeingCreated : UserData?
    
    //user infos
    var userTimeBlocks: [TimeBlock]?
    
    init(chatView : ChatCollectionView) {
        
        self.chatView = chatView
        
        self.currentAction = .none
        self.currentFlow = .none
        
        super.init()
        
        self.chatView.chatDelegate = self
            
    }
    
    public func beginCreateUserAccountFlow(){
        
        self.currentFlow = .creatingUserAccount
        self.userBeingCreated = UserData()
        
        messages = []
        indexOfNextMessageToSend = 0
        
        messages.append(contentsOf: ["Hello! I’m Dave, your personal task assistant. I’ll help you to achieve all your tasks, suggesting the next task you need to complete to be allowed to complete them all on time.",
                                      "With my help, you don’t need to spend time deciding about what to do. Just do it! :)",
                                      "If you add more tasks than you have time to complete, I’ll provide solutions so we can solve this together.",
                                      "So, I need some information to be allowed to manage your tasks. First, how can I call you?",
                                      "Nice to meet you",
                                      "To precisely suggest your next task, I need to know your daily time to dedicate for your tasks. Please, insert them below according to the weekday.",
                                      "Thank you for your information. You still have no task or project registered. You can add one now, so I can help you :)"])
        
        sendNextMessage()
        
    }
    
    
    public func beginCreateProjectFlow(){

        self.projectBeingCreated = ProjectData()
        self.currentFlow = .creatingProject
        
        messages = []
        indexOfNextMessageToSend = 0

        messages.append(contentsOf: ["Ok! What is the project name?","Cool! And what is the starting date of the project?","Ok! And what is the final date of the project?",
                                     "And how much hours working on this project do you estimate you need to complete it?",
                                     "A last information, how important is to complete this project until"])

        sendNextMessage()
        
    }
    
    private func getNextMessage()->String{
    
        let message = messages[indexOfNextMessageToSend]
        self.indexOfNextMessageToSend += 1
        return message
    
    }
    
    func messageTyped(_ message: Message) {
        
        if(message.source == .Dave && self.currentFlow != .none && self.currentAction == .none){
            sendNextMessage()
        }
        
        if message.source == .Dave && self.currentFlow == .none && self.currentAction == .needToTypeNextActivity {
            
            sendNextMessage()
            
        }
        
    }
    
    func received(date: Date){
        
        if(self.currentAction == .askedProjectStartingDate){
            
            self.projectBeingCreated?.startingDate = date
            
        }else if(self.currentAction == .askedProjectEndingDate){
            
            self.projectBeingCreated?.endingDate = date
            
        }
        
        sendNextMessage()
        
    }
    
    func received(availableDays: [AvailableDay], contextTitle: String){
        
        if(self.currentAction == .askedWorkingDays){
            
            if(self.currentFlow == .creatingUserAccount){
                
                if(self.userBeingCreated == nil){
                    print("[Error] in Dave.swift - received(availableDays, contextTitle): userBeingCreated is nil (it should has been setted in beginCreateUserFlow() method)")
                }
                
                if(self.userBeingCreated!.contexts.isEmpty){
                    
                    userBeingCreated?.contexts.append(Context(title: contextTitle, availableDays: availableDays))
                    user = User(name: userBeingCreated!.name!, contexts: userBeingCreated!.contexts)
                    userBeingCreated = nil
                    
                }else{
                
                    for context in self.userBeingCreated!.contexts{

                        if (context.title == contextTitle){
                            
                            context.availableDays = availableDays
                            
                        }
                        
                    }

                }
                
                sendNextMessage()
                self.currentFlow = .none
                
            }else if(self.currentFlow == .creatingProject){
                
                
                // TO DO : implement creatingProject flow
                
            }
            
        }
        
    }
    
    func received(text: String){
        
        switch currentAction {
        case .askedUserName:
            self.userBeingCreated?.name = text
            break
            
        case .askedProjectName:
            self.projectBeingCreated?.name = text
            break
            
        default:
            break
        }
    
        
        if(currentAction == .askedUserName && currentFlow != .none){
            
            sendNextMessage(concatenate: " "+text+"!")
            return
            
        }
        
        sendNextMessage()
        
    }
    
    func received(seconds: Int){
        
        switch currentAction{
            
        case .askedEstimatedHours:
            self.projectBeingCreated?.estimatedSeconds = seconds
            break
        default:
            break
        }
        
        
        if let deadlineDate = self.projectBeingCreated?.endingDate {
            let formatter = DateFormatter()
            // initially set the format based on your datepicker date
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let myString = formatter.string(from: deadlineDate)
            // convert your string to date
            let yourDate = formatter.date(from: myString)
            //then again set the date format whhich type of output you need
            formatter.dateFormat = "MMMM dd yyyy"
            // again convert your date to string
            let dateString = formatter.string(from: yourDate!)

            sendNextMessage(concatenate: " "+dateString+"?")
            
        }else{
            
            sendNextMessage()
        
        }
    }
    
    func received(priority: Priority){
     
        switch currentAction{
            
        case .askedProjectImportance:
            self.projectBeingCreated?.priority = priority
            break
            
        default:
            break
        }
       
        self.tryToAddProject()
        
    }
    
    func tryToAddProject(){
        
        if let user = self.user {
            
            if user.contexts.count == 1 {
                
                if let context = user.contexts.first{
                    
                    if let proj = projectBeingCreated {
                            
                        let newProj = Project(title: proj.name!, estimatedTime: TimeInterval(proj.estimatedSeconds!), priority: proj.priority!, startDate: proj.startingDate!, endDate: proj.endingDate!)
                        
                        var projs = context.projects
                        projs.append(newProj)
                        
                        self.userTimeBlocks = getTimeBlocks(projects: projs)
                        
                        if !userHasAvailableTime(){
                            
                            self.beginNotAvailableTimeFlow()
                            return
                            
                        }
                        
                        context.projects.append(newProj)
                        self.currentFlow = .none
                        self.currentAction = .needToTypeNextActivity
                        sendNextMessage()
                    
                    }
                    
                }
                
            }
            
        }
        
        self.currentFlow = .none
        sendNextMessage()

    }
    
    func received(newContext: Context){
        
        print("Dave recebeu contexto")
        
        
    }
    
    func orderUserActivities(){
        
        if let user = self.user{
        
            if user.contexts.first == nil{
                
                print("[Error] Dave - orderUserActivities(): user.contexts.first is nil")
                
            }
            
            self.userTimeBlocks = getTimeBlocks(projects: user.contexts.first!.projects)
            
            self.userTimeBlocks?.sort(by: { (tb1, tb2) -> Bool in
                
                if tb1.getStartingDate().isAfter(dateToCompare: tb2.getStartingDate()){
                    
                    return false
                    
                }
                
                return true
            })
        }
        
    }
    
    private func getTimeBlocks(projects: [Project]) -> [TimeBlock]{
        
        var timeBlocks: [TimeBlock] = []
        
        
        for project in projects{
            
            if let user = self.user {
            
                let newTimeBlock = TimeBlock(startingDate: project.startDate, endingDate: project.endDate, userAvailableDays: user.contexts[0].availableDays)
                newTimeBlock.add(project: project)
                timeBlocks.append(newTimeBlock)
                
            }else{
                print("[Error] Dave: getTimeBlocks() - user not defined")
                
            }
          
        }
        
        //split nos timeBlocks
        var changed = false
        repeat{
            
            changed = false
            
            for i in 0 ..< timeBlocks.count{
                
                for j in i+1 ..< timeBlocks.count{ // tb1 intersecting tb2 == tb2 intersecting tb1
                    
                    if(timeBlocks[i].isIntersecting(timeBlock: timeBlocks[j])){
                        
                        var newTimeBlocks = timeBlocks[i].getTimeBlocksResultingFromSplitWith(timeBlock: timeBlocks[j])

                        timeBlocks.remove(at: j)
                        timeBlocks.remove(at: i)
                        
                        newTimeBlocks.append(contentsOf: timeBlocks)
                        timeBlocks = newTimeBlocks
                        changed = true
                        break
                        
                    }
                    
                }
                
                if changed {
                    break
                }
                
            }
            
            
        }while(changed)

        
        return timeBlocks
        
    }

    public func suggestNextTask(){
        
        self.currentAction = .presentedHome
        
    }

    public func sendNextMessage(){
        
        if self.currentAction == .needToTypeNextActivity{
            
            if let message = getNextActivityMessage(){
                
                self.addMessageToQueue(messageString: message)
                
            }
            
        }
        
        if indexOfNextMessageToSend >= messages.count {
            
            return
            
        }
        
        let msgStr = getNextMessage()
        messagesSent += 1
        updateCurrentAction()
        chatView.add(message: Message(text: msgStr, from: .Dave))

    }
    
    private func beginNotAvailableTimeFlow(){
        
        self.currentFlow = .notAvailableTime
        messages.append("You tried to add a project, but you have no time available to complete it. Select one of the projects below to delete it or to change its deadline.")
        sendNextMessage()
        
    }
    
    private func userHasAvailableTime() -> Bool{
        
        for tb in self.userTimeBlocks!{
            
            if tb.getAvailableTimeInHours() < 0 {
                
                return false
                
            }
            
        }
        
        return true
        
    }

    private func userHasAvailableTime(timeBlocks: [TimeBlock]) -> Bool{
        
        for tb in timeBlocks{
            
            if tb.getAvailableTimeInHours() < 0 {
                
                return false
                
            }
            
        }
        
        return true
        
    }

    
    public func getConflictingProjects() -> [Project]{
        
        var projects: [Project] = []
        
        for tb in self.userTimeBlocks!{
            
            if tb.getAvailableTimeInHours() < 0 {
                
                for subProject in tb.getProjects(){
                    
                    if let project = subProject.containerProject{
                        
                        projects.append(project)
                        
                    }else{
                        
                        projects.append(subProject)
                        
                    }
                    
                }
                
            }
            
        }
        
        for i in 0 ..< projects.count{
            
            if i > projects.count{
                
                break
                
            }
            
            for j in i+1 ..< projects.count{
                
                if projects[i].title == projects[j].title {
                    
                    projects.remove(at: i)
                    break
                    
                }
                
            }
            
        }
        
        return projects
        
    }

    
    private func getNextActivityMessage() -> String?{

        self.orderUserActivities()
        
//        if !self.userHasAvailableTime(){
//            
//            //not available time
//            self.updateCurrentAction()
//            self.beginNotAvailableTimeFlow()
//         
//            return nil
//        }
        
        if self.user != nil{
            
            if let nextActivity = self.userTimeBlocks?.first?.getProjects().first{
                
                if let userAvailableDays = self.user?.contexts.first?.availableDays{
                    
                    var today: AvailableDay?
                    
                    for availableDay in userAvailableDays{
                        
                        if availableDay.weekday == Date().getWeekday(){
                            
                            today = availableDay
                            break
                            
                        }
                        
                    }
                    
                    if today == nil{
                        print("[Error] Dave - getNextActivityMessage(): current availableDay is nil")
                        
                    }
                    
                    if !today!.available{
                        
                        return "Today you have no activity, according to your available time :)"
                        
                    }
                    
                    if let todayEndTime = today!.endTime, let todayStartTime = today!.startTime{
                        
                        let todayAvailableTime = todayEndTime - todayStartTime
                        let hours = (Int(nextActivity.estimatedTime/3600) > todayAvailableTime) ? todayAvailableTime : Int(nextActivity.estimatedTime/3600)
                        
//                        let formatter = DateFormatter()
//                        formatter.dateFormat = "MM/dd/yyyy"
//                        let finalDateString = formatter.string(from: nextActivity.endDate)

                        return "Today, you need to dedicate \(hours) working on project \"\(nextActivity.title)\""
                        
                    }else{
                        
                        print("[Error] Dave - getNextActivityMessage(): today endTime or today startTime is undefined")
                        
                    }
                    
                }
                
            }
            
            
        }
     
        return nil
        
    }

    public func sendNextMessage(concatenate concatenatedString: String){
        
        if indexOfNextMessageToSend >= messages.count {
            
            return
            
        }
        
        let msgStr = getNextMessage()+concatenatedString
        messagesSent += 1
        updateCurrentAction()
        chatView.add(message: Message(text: msgStr, from: .Dave))

        
    }
    
    public func addMessageToQueue(messageString text: String){
        
        messages.append(text)
        
    }
    
    public func addProjectCancelled(){
        
        self.projectBeingCreated = nil

        self.currentFlow = .none
        self.currentAction = .needToTypeNextActivity
        self.addMessageToQueue(messageString: "You have cancelled the project creation.")
        self.sendNextMessage()
        
    }
    
    private func updateCurrentAction(){
        
        switch (self.currentFlow){
         
        case .creatingProject:
            if self.indexOfNextMessageToSend == 1 && self.currentAction != .askedProjectName{ //asked project name
                self.currentAction = .askedProjectName
           
            }else if self.indexOfNextMessageToSend == 2 && self.currentAction != .askedProjectStartingDate { //asked project starting date
                self.currentAction = .askedProjectStartingDate
                
            }else if self.indexOfNextMessageToSend == 3 && self.currentAction != .askedProjectEndingDate { //asked project ending date
                self.currentAction = .askedProjectEndingDate
                
            }else if self.indexOfNextMessageToSend == 4 && self.currentAction != .askedEstimatedHours { //asked estimated hours
                self.currentAction = .askedEstimatedHours
            
            }else if self.indexOfNextMessageToSend == 5 && self.currentAction != .askedProjectImportance { //asked importance to complete project until deadline
                self.currentAction = .askedProjectImportance

            }else{
                
                self.currentAction = .none
                
            }
            
            break
            
        case .creatingUserAccount:
            
            if(self.indexOfNextMessageToSend == 4 && self.currentAction != .askedUserName){ //asked user name
                self.currentAction = .askedUserName
                
            }else if(self.indexOfNextMessageToSend == 6 && self.currentAction != .askedWorkingDays){ //asked working days and hours
                self.currentAction = .askedWorkingDays
                
            }else{
                self.currentAction = .none
                
            }
        
            break
            
        case .notAvailableTime:
            
            if self.currentAction != .askedToSelectAProject{
            
                self.currentAction = .askedToSelectAProject
            
            }else{
                self.currentAction = .none
            }
            
        default:
            
            if self.currentAction == .askedProjectImportance{
                self.currentAction = .needToTypeNextActivity
                
            }else{
                self.currentAction = .none
            
            }
            break
            
        }
        
    }
    
}
