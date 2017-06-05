//
//  AvailableDaysSelectionView.swift
//  Task Assistant
//
//  Created by Rodrigo Cardoso Buske on 04/06/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

import UIKit
import NHRangeSlider

enum Weekday : String {
	case sunday, monday, tuesday, wednesday, thursday, friday, saturday
	
	private static var allDays = [sunday, monday, tuesday, wednesday, thursday, friday, saturday]
	
	static func getWeekday(day : Int) -> Weekday? {
		switch day {
		case 1 ... 7:
			return Weekday.allDays[day - 1]
		default:
			return nil
		}
	}
}

class AvailableDaysSelectionView: UIView, NHRangeSliderViewDelegate {

	@IBOutlet weak var daySelector: UISegmentedControl!
	@IBOutlet weak var availableDaySwitch: UISwitch!
	@IBOutlet weak var switchLabel: UILabel!
	@IBOutlet weak var rangeSliderView: RangeSliderView!
	
	var availableDays = [AvailableDay]()
	
	var currentDay: AvailableDay {
		get {
			return self.availableDays[self.daySelector.selectedSegmentIndex]
		}
		set {
			self.availableDays[self.daySelector.selectedSegmentIndex] = newValue
		}
	}
	
	let labelMainText = "I don't work on"
	
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		let xibView = Bundle.main.loadNibNamed("AvailableDaysSelectionView", owner: self, options: nil)?.first as! UIView
		xibView.frame = self.bounds
		xibView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		
		self.addSubview(xibView)
		
		self.rangeSliderView.delegate = self
		
		for day in 1...7 {
			self.availableDays.append(AvailableDay(weekday: day))
		}
		
		self.changedDay(self.daySelector)
	}
	
	@IBAction func switchValueChanged(_ sender: UISwitch) {
		self.rangeSliderView.isHidden = sender.isOn

		self.currentDay.available = !sender.isOn
		
		if self.currentDay.available && self.currentDay.startTime == nil {
			self.sliderValueChanged(slider: self.rangeSliderView.rangeSlider)
		}
	}
	
	@IBAction func changedDay(_ sender: UISegmentedControl) {
		let day = self.currentDay
		print(day)
		
		self.switchLabel.text = "\(self.labelMainText) \(Weekday.getWeekday(day: day.weekday)!.rawValue)"
		
		self.availableDaySwitch.isOn = !day.available
		self.switchValueChanged(self.availableDaySwitch)
		
		if day.available {
			rangeSliderView.lowerValue = Double(day.startTime ?? 0)
			rangeSliderView.upperValue = Double(day.endTime ?? 23)
		}
		
	}
	
	func sliderValueChanged(slider: NHRangeSlider?) {
		
		//let lowerValueIsInt = slider!.lowerValue.truncatingRemainder(dividingBy: 1) == 0
		//let upperValueIsInt = slider!.upperValue.truncatingRemainder(dividingBy: 1) == 0
		
//		if lowerValueIsInt && upperValueIsInt {
//		}
		
		self.currentDay.startTime = Int(slider!.lowerValue)
		self.currentDay.endTime = Int(slider!.upperValue)
		
		print(self.currentDay)
	}
}
