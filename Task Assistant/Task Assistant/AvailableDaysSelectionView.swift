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

@IBDesignable class AvailableDaysSelectionView: UIView, XibLoader, NHRangeSliderViewDelegate {
	// MARK: Private Properties
	let nibName = "AvailableDaysSelectionView"
	var view : UIView!
	
	private let labelMainText = "I don't work on"
	
	// MARK: Public Properties
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
	
	// MARK: Initializers
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		self.initialSetup()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		self.initialSetup()
	}
	
	// MARK: Private Methods
	func initialSetup() {
		self.xibSetup()
		
		self.rangeSliderView.delegate = self
		
		for day in 1...7 {
			self.availableDays.append(AvailableDay(weekday: day))
		}
		
		self.changedDay(self.daySelector)
	}
	
	// MARK: Public Methods
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
		
		self.currentDay.startTime = Int(slider!.lowerValue)
		self.currentDay.endTime = Int(slider!.upperValue)
		
		print(self.currentDay)
	}
    
}
