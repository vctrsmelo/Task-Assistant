//
//  Message.swift
//  Task Assistant
//
//  Created by Victor S Melo on 04/06/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

import UIKit

enum UserType{
    
    case User
    case Dave
    
}

class Message {

	let source: UserType
    var text : String
    
    init(text: String, from source: UserType){
        
        self.text = text
        self.source = source
    }
    
}
