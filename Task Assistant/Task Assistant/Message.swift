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

class Message: NSObject {

    public let source: UserType
    public var text : String
    
    init(withMessage text: String, from source: UserType){
        
        self.text = text
        self.source = source
        
    }
    
}
