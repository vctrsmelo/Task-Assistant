//
//  DayMonthView.swift
//  Task Assistant
//
//  Created by Rodrigo Cardoso Buske on 04/07/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

import UIKit

@IBDesignable class DayMonthView: UIView, XibLoader {
	
	let nibName = "DayMonthView"
	var view : UIView!
	
	@IBOutlet weak var monthLabel : UILabel!
	@IBOutlet weak var dayLabel : UILabel!
	
	private var _date = Date()
	
	var date : Date {
		get {
			return _date
		}
		set {
			_date = newValue
			self.updateDisplay()
		}
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		self.initialSetup()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		self.initialSetup()
	}
	
	func initialSetup() {
		self.xibSetup()
		
		self.updateDisplay()
	}
	
	private func updateDisplay(){
		let dateFormater = DateFormatter()
		dateFormater.setLocalizedDateFormatFromTemplate("MMMM")
		
		self.monthLabel.text = dateFormater.string(from: self._date)
		
		let calendar = Calendar.current
		
		let day = calendar.component(.day, from: self._date)
		
		self.dayLabel.text = String(day)
	}
}
