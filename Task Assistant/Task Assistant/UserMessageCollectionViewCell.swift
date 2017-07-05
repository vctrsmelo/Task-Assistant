//
//  UserMessageCollectionViewCell.swift
//  Task Assistant
//
//  Created by Victor S Melo on 04/06/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

import UIKit


protocol UserMessageCollectionViewCellDelegate: class{
    
    func userTypedAllCharacters()
    
}

class UserMessageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var textView: UITextView!
    
    public var message: Message!
    public weak var delegate: UserMessageCollectionViewCellDelegate?
    
    let messageMargin: CGFloat = 5.0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        
        super.draw(rect)
        
		//self.layer.addBorder(edge: .right, color: .red, thickness: 5.0)
		//self.textView.textAlignment = NSTextAlignment.right
        
		//self.textView.isEditable = false
        
		//self.textView.frame = rect
		
		let path = UIBezierPath(roundedRect:self.textView.bounds,
		                        byRoundingCorners:[.topLeft, .bottomLeft],
		                        cornerRadii: CGSize(width: 20, height:  20))
		let maskLayer = CAShapeLayer()
		maskLayer.path = path.cgPath
		self.textView.layer.mask = maskLayer
    }
    
    public func write(message: Message, typingEffect: Bool){
        
        self.textView.text = message.text
        
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { (timer) in

            self.delegate?.userTypedAllCharacters()
            
        }
    
    }
    
}
