//
//  AvailableDaysSelectionView.swift
//  Task Assistant
//
//  Created by Rodrigo Cardoso Buske on 04/06/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

import UIKit

class AvailableDaysSelectionView: UIView {

	@IBOutlet weak var daySelector: UISegmentedControl!
	@IBOutlet weak var availableDaySwitch: UISwitch!
	@IBOutlet weak var switchLabel: UILabel!
	@IBOutlet weak var rangeSliderView: RangeSliderView!
	
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		self.addSubview(Bundle.main.loadNibNamed("AvailableDaysSelectionView", owner: self, options: nil)?.first as! UIView)
	}
	
	

}
