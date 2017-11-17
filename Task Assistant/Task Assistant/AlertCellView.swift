//
//  AlertCellView.swift
//  Task Assistant
//
//  Created by Victor S Melo on 05/07/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

import UIKit

class AlertCellView: UIView {
    
    private var textLabel : UILabel
    
    var isEnabled: Bool{
        get {
            return self.isEnabled
        }
        set {
            if newValue == false{
                
                self.isHidden = true
                
            }else{
                
                self.isHidden = false
                
            }
            
            self.isEnabled = newValue
            
        }
    }
    
    init(frame: CGRect,text: String) {
        self.textLabel = UILabel(frame: frame)
        textLabel.text = text
        
        super.init(frame: frame)
        self.isEnabled = true
        
    }
    
    override init(frame: CGRect) {
        self.textLabel = UILabel(frame: frame)
        textLabel.text = ""
        
        super.init(frame: frame)
        
    }
    
    //set the new text, adjusting the number of lines of textLabel
    func set(text: String){
        
        self.textLabel.text = text
        var newFrame = self.textLabel.frame
        newFrame.size.height = heightForView(label: self.textLabel, text: text)
        
        self.textLabel.frame = newFrame
        
        let charSize = lroundf(Float(textLabel.font.lineHeight))
        let rHeight = lroundf(Float(newFrame.size.height))
        let lineCount = rHeight/charSize
        
        self.textLabel.numberOfLines = lineCount
        
    }
    
    func heightForView(label: UILabel, text:String) -> CGFloat{
        
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: label.frame.width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = self.textLabel.font
        label.text = text
        label.sizeToFit()
        
        return label.frame.height
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
