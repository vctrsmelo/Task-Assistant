//
//  MessageCollectionViewCell.swift
//  Task Assistant
//
//  Created by Victor S Melo on 03/06/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

import UIKit

class MessageCollectionViewCell: UICollectionViewCell {
    
    private var message: Message!
    
    let messageMargin: CGFloat = 5.0
    var userMessageXPosition: CGFloat!
    var daveMessageXPosition: CGFloat!
    @IBOutlet weak var textView: UITextView!

    override init(frame: CGRect){
        super.init(frame: frame)
    }
    
    public func set(message: Message){
        self.message = message
        self.textView.text = message.text

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        self.userMessageXPosition = rect.size.width-textView.frame.width-self.messageMargin
        
        self.daveMessageXPosition =  self.messageMargin
        self.textView.text = message.text
        
        var frame = textView.frame
        frame.origin.x = (self.message.source == .User) ? self.userMessageXPosition : daveMessageXPosition

        //align text horizontally
        frame.origin.y = rect.origin.y+(self.frame.size.height/2.0) - (textView.frame.size.height/2.0)
        print("originX: \(frame.origin.x) originY: \(frame.origin.y)")
        textView.frame = frame
        
    }
    
}
