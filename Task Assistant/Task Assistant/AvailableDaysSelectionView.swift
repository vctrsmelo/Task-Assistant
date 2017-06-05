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
	
	static func getWeekday(day : Int) -> Weekday {
		switch day {
		case 1 ... 7:
			return Weekday.allDays[day]
		default:
			return Weekday.sunday
		}
	}
}

class AvailableDaysSelectionView: UIView, NHRangeSliderViewDelegate {

	@IBOutlet weak var daySelector: UISegmentedControl!
	@IBOutlet weak var availableDaySwitch: UISwitch!
	@IBOutlet weak var switchLabel: UILabel!
	@IBOutlet weak var rangeSliderView: RangeSliderView!
	
	var availableDays = [AvailableDay]()
	
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
	}
	
	@IBAction func switchValueChanged(_ sender: UISwitch) {
		self.rangeSliderView.isHidden = sender.isOn
		
		var day = self.getAvailableDay()
		day.available = sender.isOn
	}
	
	@IBAction func changedDay(_ sender: UISegmentedControl) {
		let day = self.getAvailableDay()
		
		self.switchLabel.text = "\(self.labelMainText) \(Weekday.getWeekday(day: day.weekday).rawValue)"
		self.availableDaySwitch.isOn = !day.available
		
		if day.available {
			rangeSliderView.lowerValue = Double(day.startTime!)
			rangeSliderView.lowerValue = Double(day.endTime!)
		}
		
	}

	func getAvailableDay() -> AvailableDay {
		let day = self.daySelector.selectedSegmentIndex
		
		for availableDay in self.availableDays {
			if availableDay.weekday ==  day{
				return availableDay
			}
		}
		
		return AvailableDay(weekday: day)
	}
	
	func sliderValueChanged(slider: NHRangeSlider?) {
		var day = self.getAvailableDay()
		
		day.startTime = Int(slider!.lowerValue)
		day.endTime = Int(slider!.upperValue)
	}
}
