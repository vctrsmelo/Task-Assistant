//
//  EditEstimatedTimeTableViewCell.swift
//  Task Assistant
//
//  Created by Victor S Melo on 05/07/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

import UIKit

class EditEstimatedTimeTableViewCell: UITableViewCell{
    
    @IBOutlet weak var estimatedTimeLabel: UILabel!
    @IBOutlet weak var estimatedTimeValue: UILabel!
    
    static let HEIGHT: CGFloat = 70.0
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        estimatedTimeValue.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.touchedEstimatedTime))
        estimatedTimeValue.addGestureRecognizer(tap)
        
    }
    
    @objc private func touchedEstimatedTime(sender:UITapGestureRecognizer){
        
        print("abre component para mudar estimated time")
        
    }

}
