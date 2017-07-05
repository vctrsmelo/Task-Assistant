//
//  EditItemSelectionTableViewCell.swift
//  Task Assistant
//
//  Created by Victor S Melo on 05/07/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

import UIKit

class EditItemSelectionTableViewCell: EditTableViewCell{
    
    @IBOutlet weak var itemSelectedLabel: UILabel!
    
    static let HEIGHT: CGFloat = 70.0
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        itemSelectedLabel.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.touchedItemSelected))
        itemSelectedLabel.addGestureRecognizer(tap)
        
    }
    
    @objc private func touchedItemSelected(sender:UITapGestureRecognizer){
        
        print("abre lista de prioridades")
        
    }

}
