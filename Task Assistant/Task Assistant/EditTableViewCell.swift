//
//  EditTableViewCell.swift
//  Task Assistant
//
//  Created by Victor S Melo on 05/07/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

import UIKit

class EditTableViewCell : UITableViewCell{
    
    private var editableField: UIView!
    private var alertCellView: AlertCellView!

    func setEditableField(field: UIView){
        
        editableField = field
        
    }
    
    func setAlertMessage(text: String, isEnabled: Bool){
        
        self.alertCellView = AlertCellView(frame: self.frame)
        self.alertCellView.isEnabled = isEnabled
        
    }
    
}
