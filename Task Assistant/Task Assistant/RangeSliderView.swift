//
//  RangeSliderView.swift
//  Task Assistant
//
//  Created by Rodrigo Cardoso Buske on 04/06/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

import Foundation
import NHRangeSlider

class RangeSliderView : NHRangeSliderView {
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		self.thumbLabelStyle = .FOLLOW
		self.maximumValue = 23
		self.upperValue = 23
		self.gapBetweenThumbs = 1
		self.stepValue = 1
	}
	
}
