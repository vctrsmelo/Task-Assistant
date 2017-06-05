//
//  ChatManager.swift
//  Task Assistant
//
//  Created by Victor S Melo on 04/06/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

import UIKit

class Dave: NSObject {

    private(set) var messages: [String] = []
    private(set) var indexOfNextMessageToSend = 0
    
    init(isUserDefined: Bool) {
        
        super.init()
        
        if(isUserDefined){
            
            self.suggestNextTask()
            
        }else{
            
            self.addCreateAccountMessages()
            
        }
    }
    
    private func addCreateAccountMessages(){
        
        messages.append(contentsOf: ["Hello! I’m Dave, your personal task assistant. I’ll help you to achieve all your tasks, suggesting the next task you need to complete to be allowed to complete them all on time.",
                                      "With my help, you don’t need to spend time deciding about what to do. Just do it! :)",
                                      "If you add more tasks than you have time to complete, I’ll provide solutions so we can solve this together.",
                                      "So, I need some information to be allowed to manage your tasks. First, how can I call you?",
                                      "Nice to meet you",
                                      "To precisely suggest your next task, I need to know your daily time to dedicate for your tasks. Please, insert them below according to the weekday.",
                                      "Thank you for your information. You still have no task or project registered. You can add one now, so I can help you :)"])
        
    }
    
    private func getNextMessage()->String{
    
        let message = messages[indexOfNextMessageToSend]
        self.indexOfNextMessageToSend += 1
        return message
    
    }
    
    private func suggestNextTask(){
        
        
        
    }
    
    public func sendNextMessage(chatView chat : ChatCollectionView){
        
        if indexOfNextMessageToSend >= messages.count {
            
            return
            
        }
        
        let msgStr = getNextMessage()
        chat.add(message: Message(text: msgStr, from: .Dave))

    }
    
    public func sendNextMessage(chatView chat : ChatCollectionView, concatenate concatenatedString: String){
        
        if indexOfNextMessageToSend >= messages.count {
            
            return
            
        }
        
        let msgStr = getNextMessage()+concatenatedString
        chat.add(message: Message(text: msgStr, from: .Dave))
        
    }
    
    public func addMessageToQueue(messageString text: String){
        
        messages.append(text)
        
    }
    
}
