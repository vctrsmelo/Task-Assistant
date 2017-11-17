//
//  EditTextTableViewCell.swift
//  Task Assistant
//
//  Created by Victor S Melo on 05/07/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

import UIKit

class EditTextTableViewCell: EditTableViewCell{
    
    @IBOutlet weak var textField: UITextField!
    static let HEIGHT: CGFloat = 70.0
    
    override func awakeFromNib() {
        
    }
}
