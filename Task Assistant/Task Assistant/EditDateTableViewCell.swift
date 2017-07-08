//
//  EditDateTableViewCell.swift
//  Task Assistant
//
//  Created by Victor S Melo on 05/07/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

import UIKit

class EditDateTableViewCell: EditTableViewCell{
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dateValue: UILabel!
    
    var date : Date!
    
    static let HEIGHT: CGFloat = 40.0

    override func layoutSubviews() {
        super.layoutSubviews()
//        
//        dateValue.isUserInteractionEnabled = true
//        
//        let tap = UITapGestureRecognizer(target: self, action: #selector(self.touchedDate))
//        dateValue.addGestureRecognizer(tap)
        
    }
    
//    @objc private func touchedDate(sender:UITapGestureRecognizer){
//    
//        print("abre date component para mudar data")
//    
//    }
    
}
