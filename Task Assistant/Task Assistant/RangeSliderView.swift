//
//  RangeSliderView.swift
//  Task Assistant
//
//  Created by Rodrigo Cardoso Buske on 04/06/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

import Foundation
import NHRangeSlider

@IBDesignable class RangeSliderView : NHRangeSliderView {
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		self.initialSetup()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		self.initialSetup()
	}
	
	private func initialSetup() {
		self.thumbLabelStyle = .FOLLOW
		self.maximumValue = 23
		self.upperValue = self.maximumValue
		self.gapBetweenThumbs = 1
		self.stepValue = 1
	}
	
}
