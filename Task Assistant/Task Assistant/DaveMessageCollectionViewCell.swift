//
//  MessageCollectionViewCell.swift
//  Task Assistant
//
//  Created by Victor S Melo on 03/06/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

import UIKit

extension CALayer {
    
    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        
        let border = CALayer()
        
        switch edge {
        case UIRectEdge.top:
            border.frame = CGRect.init(x: 0, y: 0, width: self.frame.width, height: thickness)
            break
            
        case UIRectEdge.bottom:
            border.frame = CGRect.init(x: 0, y: CGFloat(self.frame.size.height - thickness), width: UIScreen.main.bounds.width, height: thickness)
            break
            
        case UIRectEdge.left:
            border.frame = CGRect.init(x: 0, y: 0, width: thickness, height: self.frame.size.height)
                //CGRectMake(0, 0, thickness, CGRectGetHeight(self.frame))
            break
        case UIRectEdge.right:
            border.frame = CGRect.init(x: CGFloat(self.frame.size.width - thickness), y: 0, width: thickness, height: self.frame.size.height)
                //CGRectMake(CGRectGetWidth(self.frame) - thickness, 0, thickness, CGRectGetHeight(self.frame))
            break
        default:
            break
        }
        
        border.backgroundColor = color.cgColor;
        self.addSublayer(border)
        
    }
    
}

extension String {
    
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        let start = index(startIndex, offsetBy: r.lowerBound)
        let end = index(startIndex, offsetBy: r.upperBound - r.lowerBound)
        return self[Range(start ..< end)]
    }
}

protocol DaveMessageCollectionViewCellDelegate: class{
    
    func daveTypedAllCharacters()
    
}

class DaveMessageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var textView: UITextView!

    private var message: Message!
    weak var delegate: DaveMessageCollectionViewCellDelegate?
    
    let messageViewWidth: CGFloat = 300.0
    let messageMargin: CGFloat = 5.0
    var userMessageXPosition: CGFloat!
    var daveMessageXPosition: CGFloat!
    
    var timer:Timer?
    let timeToTypeCharacter = 0.0 //change to 0.04
    private var myCounter = 0
    public var allCharactersTyped = false
    
    override init(frame: CGRect){
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {

        super.draw(rect)
        
        self.layer.addBorder(edge: .left, color: .blue, thickness: 5.0)
        self.textView.isEditable = false
        self.textView.frame = rect

    }
    
    func write(message: Message, typingEffect: Bool){
        
        if(allCharactersTyped){
            self.textView.text = message.text
            return
        }
        
        self.message = message
        
        if(typingEffect){
            
            myCounter = 0
            self.textView.text = ""
            typeLetter()

        }else{
            
            self.textView.text = message.text
            Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.typedCharacters), userInfo: nil, repeats: false)
        }
        
    }
    
    @objc private func typedCharacters(){
        delegate?.daveTypedAllCharacters()
    }
    
    func fireTimer(){
        timer = Timer.scheduledTimer(timeInterval: self.timeToTypeCharacter, target: self, selector: #selector(self.typeLetter), userInfo: nil, repeats: true)
    }
    
    func typeLetter(){
        
        if myCounter < message.text.characters.count {
            
            self.textView.text = self.textView.text! + String(message.text[myCounter])
            
            timer?.invalidate()
            timer = Timer.scheduledTimer(timeInterval: self.timeToTypeCharacter, target: self, selector: #selector(self.typeLetter), userInfo: nil, repeats: false)
        
            
        } else {
            
            Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(self.typeLetterConcluded), userInfo: nil, repeats: false)
            
        }
        
        myCounter += 1
    
    }
    
    @objc private func typeLetterConcluded(){
        
        delegate?.daveTypedAllCharacters()
        timer?.invalidate()
        
    }

}
