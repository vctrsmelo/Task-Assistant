//
//  ChatCollectionView.swift
//  Task Assistant
//
//  Created by Victor S Melo on 03/06/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

import UIKit

protocol ChatCollectionViewDelegate: class{
    
    func messageTyped(_ message: Message)
    
}

class ChatCollectionView: UICollectionView {

    private var messages: [Message] = []
    
    public weak var chatDelegate : ChatCollectionViewDelegate?
    
    public func add(message: Message){
        
        messages.append(message)
        self.reloadData()
        self.setNeedsLayout()
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
