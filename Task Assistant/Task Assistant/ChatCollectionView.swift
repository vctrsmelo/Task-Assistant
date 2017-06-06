//
//  ChatCollectionView.swift
//  Task Assistant
//
//  Created by Victor S Melo on 03/06/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

import UIKit

class ChatCollectionView: UICollectionView {

    private var messages: [Message] = []
    
    public func add(message: Message){
        
        messages.append(message)
        print("dentro de add \(messages[messages.count-1].text)")
        self.reloadData()
        
    }
    
    public func getMessages() -> [Message]{
        
        return messages
        
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
