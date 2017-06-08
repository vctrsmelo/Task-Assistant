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
    var startingDate : Date?
    var endingDate : Date?
    
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
                                     "A last information, how important is to complete this project until"
            ])

        sendNextMessage()
        
    }
    
    private func getNextMessage()->String{
    
        let message = messages[indexOfNextMessageToSend]
        self.indexOfNextMessageToSend += 1
        return message
    
    }
    
    func messageTyped(_ message: Message) {
        
        if(message.source == .Dave && self.currentAction != .none){
            sendNextMessage()
        }
    }
    
    func received(date: Date){
        
        if(self.currentAction == .askedProjectStartingDate){
            
            self.projectBeingCreated?.startingDate = date
            
        }else if(self.currentAction == .askedProjectEndingDate){
            
            self.projectBeingCreated?.endingDate = date
            
        }
        
    }
    
    func received(availableDays: [AvailableDay], contextTitle: String){
        
        if(self.currentAction == .askedWorkingDays){
            
            if(self.currentFlow == .creatingUserAccount){
                
                if(self.userBeingCreated == nil){
                    print("[Error] in Dave.swift - received(availableDays, contextTitle): userBeingCreated is nil (it should has been setted in beginCreateUserFlow() method)")
                }
                
                if(self.userBeingCreated!.contexts.isEmpty){
                    
                    userBeingCreated?.contexts.append(Context(title: contextTitle, availableDays: availableDays))
                    return
                    
                }
                
                for context in self.userBeingCreated!.contexts{

                    if (context.title == contextTitle){
                        
                        context.availableDays = availableDays
                        return
                    }
                    
                }
                
            }else if(self.currentFlow == .creatingProject){
                
                
                // TO DO : implement creatingProject flow
                
            }
            
        }
        
    }
    
    func received(newContext: Context){
        
        
        
    }
    
    private func orderTasks(user: User){
        
        self.user = user
        
        for context in user.contexts{
            
            var orderedActivities : [Activity]
            
            for activity in context.activities{
                
                
                
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
        chatView.add(message: Message(text: msgStr, from: .Dave))

    }
    
    public func sendNextMessage(concatenate concatenatedString: String){
        
        if indexOfNextMessageToSend >= messages.count {
            
            return
            
        }
        
        let msgStr = getNextMessage()+concatenatedString
        chatView.add(message: Message(text: msgStr, from: .Dave))
        
    }
    
    public func addMessageToQueue(messageString text: String){
        
        messages.append(text)
        
    }
    
}
