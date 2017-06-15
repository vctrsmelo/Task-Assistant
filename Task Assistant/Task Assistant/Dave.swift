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
    
}

enum DaveFlow{
    
    case none
    case creatingUserAccount
    case creatingProject
    
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
    private var user: User?
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
    
    //addUser variables
    
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
                                     "A last information, how important is to complete this project until",
                                     "Thanks. I've added your new project to the list of activities."
            ])

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
        
        if let usr = user {
            
            if(usr.contexts.count == 1){
                
                if let context = usr.contexts.first{
                    
                    if let proj = projectBeingCreated {
                        
                        context.add(project: Project(title: proj.name!, estimatedTime: TimeInterval(proj.estimatedSeconds!), priority: proj.priority!, startDate: proj.startingDate!, endDate: proj.endingDate!))
                    
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
    
    private func orderUserTasks(){
        
        if let user = self.user{
        
            for context in user.contexts{
                
                var orderedTasks : [Task]
                
                
                
                
            }
        }
        
    }

    public func suggestNextTask(){
        
        self.currentAction = .presentedHome
        
    }

    public func sendNextMessage(){
        
        if indexOfNextMessageToSend >= messages.count {
            
            return
            
        }
        
        let msgStr = getNextMessage()
        messagesSent += 1
        updateCurrentAction()
        chatView.add(message: Message(text: msgStr, from: .Dave))

    }
    
    public func sendNextActivityMessage(){
        
            self.orderUserTasks()
        
        if let user = self.user{
        
            if let context = user.contexts.first{
                
                if let task = user.getNextTask(contextName: "Main"){
            
                    chatView.add(message: Message(text: "Your next task is: \(task.title), and you need to achieve it until [NEED TO ADD]", from: .Dave))
                
                }
            }
        
        }
        
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
        
        default:
            self.currentAction = .none
            break
            
        }
        
    }
    
}
