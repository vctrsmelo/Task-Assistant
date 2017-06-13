//
//  DaveViewController.swift
//  Task Assistant
//
//  Created by Victor S Melo on 03/06/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

import UIKit

class DaveViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UserMessageCollectionViewCellDelegate,DaveMessageCollectionViewCellDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var chatCollectionView: ChatCollectionView!
    private var chatOriginalFrame : CGRect!
    private var dave : Dave!
    
    private var projectBeingCreated : Project?
    private var projectName: String!
    private var projectStartingDate: Date!
    
    
    private let messageViewWidth: CGFloat = 250.0
    
    //add text (name input)
    @IBOutlet weak var textInputView: UIView!
    @IBOutlet weak var textInputField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    //add project and add task
    @IBOutlet weak var addActivityButtonsView: UIView!
    @IBOutlet weak var addProjectButton: UIButton!
    @IBOutlet weak var addTaskButton: UIButton!
    
    //define days of the week and time
    @IBOutlet weak var availableDaysSelectionContainerView: UIView!
    @IBOutlet weak var availableDaysSelectionView: AvailableDaysSelectionView!
    @IBOutlet weak var sendAvailableDays: UIButton!
    
    //date picker
    @IBOutlet weak var datePickerContainerView: UIView!
    @IBOutlet weak var sendButtonDatePicker: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var estimatedHoursContainerView: UIView!
    @IBOutlet weak var estimatedHoursPickerView: UIPickerView!
    @IBOutlet weak var sendButtonEstimatedHours: UIButton!
    private var estimatedHours: Int = 0
    private var estimatedMinutes: Int = 0
    
    private var lastIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

        chatCollectionView.delegate = self
        chatCollectionView.dataSource = self
        
        estimatedHoursPickerView.dataSource = self
        estimatedHoursPickerView.delegate = self
        
        
        chatOriginalFrame = chatCollectionView.frame

        hideAllComponents()
        
        var user : User?
        
        // TO DO:  try to get user from DB

        dave = Dave(chatView: chatCollectionView)

        (user == nil) ? dave.beginCreateUserAccountFlow() : dave.suggestNextTask()
        
        self.view.setNeedsDisplay()
    
    }

    private func hideAllComponents(){
        textInputView.isHidden = true
        addActivityButtonsView.isHidden = true
        availableDaysSelectionContainerView.isHidden = true
        datePickerContainerView.isHidden = true
        estimatedHoursContainerView.isHidden = true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return chatCollectionView.getMessages().count
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let message = chatCollectionView.getMessages()[indexPath.row]
        
        if(message.source == .Dave){
            
            let messageCell:DaveMessageCollectionViewCell = self.chatCollectionView.dequeueReusableCell(withReuseIdentifier: "daveMessageCell", for: indexPath) as! DaveMessageCollectionViewCell
            
            if(chatCollectionView.getMessages().count == indexPath.row+1)
            {
                messageCell.allCharactersTyped = false
                messageCell.write(message: message, typingEffect: true)
                messageCell.delegate = self
            
            }else{
                messageCell.allCharactersTyped = true
                messageCell.write(message: message, typingEffect: false)
                messageCell.delegate = nil
            }
            
            collectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.top, animated: true)

            lastIndexPath = indexPath
            return messageCell

        }else{
    
            let messageCell:UserMessageCollectionViewCell = self.chatCollectionView.dequeueReusableCell(withReuseIdentifier: "userMessageCell", for: indexPath) as! UserMessageCollectionViewCell
        
            messageCell.write(message: message, typingEffect: false)
            
            if(chatCollectionView.getMessages().count == indexPath.row+1)
            {

                messageCell.delegate = self
                
            }else{
            
                messageCell.delegate = nil
            
            }


            collectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.top, animated: true)

            lastIndexPath = indexPath

            return messageCell

        }
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellWidth = self.view.frame.width
        
        let tempTextView = UITextView.init(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 500))
        
        tempTextView.text = chatCollectionView.getMessages()[indexPath.row].text
        
        let contentSize = tempTextView.sizeThatFits(tempTextView.bounds.size)
        let cellHeight : CGFloat = contentSize.height
        
        return CGSize(width: cellWidth, height: (cellHeight+30))
        
    }
    
    func daveTypedAllCharacters() {

        switch(dave.currentAction){
            
        case .none:
            
            if(dave.currentFlow == .none){
                self.addActivityButtonsView.isHidden = false
                chatCollectionView.frame.size.height -= addActivityButtonsView.frame.size.height //adjust size to don`t stay behind addActivityButtonsView
            }
            
            if let indexPath = lastIndexPath{ self.chatCollectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.bottom, animated: true) }
            
            break
            
        case .askedUserName:
            textInputView.isHidden = false
            chatCollectionView.frame.size.height -= textInputView.frame.size.height //adjust size to don`t stay behind textInputView
            
            if let indexPath = lastIndexPath{ self.chatCollectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.bottom, animated: true) }

            break
            
        case .askedWorkingDays:
            availableDaysSelectionContainerView.isHidden = false
            chatCollectionView.frame.size.height -= availableDaysSelectionContainerView.frame.size.height
            
            if let indexPath = lastIndexPath{
                self.chatCollectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.bottom, animated: true)
            }
            
            break
            
        case .askedProjectName:
            
            if(textInputView.isHidden){
                chatCollectionView.frame.size.height -= textInputView.frame.size.height //adjust size to don`t stay behind textInputView
            }
            
            textInputField.text = ""
            textInputField.placeholder = "Project Name"
            textInputView.isHidden = false
            
            if let indexPath = lastIndexPath{
                self.chatCollectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.bottom, animated: true)
            }

            break
            
        case .askedProjectStartingDate:
            chatCollectionView.frame.size.height -= datePickerContainerView.frame.size.height //adjust size to don`t stay behind datePickerContainerView
            datePickerContainerView.isHidden = false
            
            //adjust dates
            var dateComponents = DateComponents()
            dateComponents.year = 2017
            dateComponents.month = 6
            dateComponents.day = 13
            dateComponents.timeZone = TimeZone(abbreviation: "UTC") // Japan Standard Time
            dateComponents.hour = 9
            dateComponents.minute = 8
            // Create date from components
            let userCalendar = Calendar.current // user calendar
            
            datePicker.minimumDate = userCalendar.date(from: dateComponents)
            
            dateComponents.year = 2222
            dateComponents.month = 2
            dateComponents.day = 22
            
            datePicker.maximumDate = userCalendar.date(from: dateComponents)

            if let indexPath = lastIndexPath{
                self.chatCollectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.bottom, animated: true)
            }
            
            break
        
        case .askedProjectEndingDate:
            chatCollectionView.frame.size.height -= datePickerContainerView.frame.size.height //adjust size to don`t stay behind datePickerContainerView
            datePickerContainerView.isHidden = false
            
            //adjust dates            dateComponents.minute = 8
            // Create date from components
            //let userCalendar = Calendar.current // user calendar
            
            datePicker.minimumDate = Date()
            
            var dateComponents = DateComponents()
            dateComponents.year = 2323
            dateComponents.month = 2
            dateComponents.day = 23
            let userCalendar = Calendar.current // user calendar
            datePicker.maximumDate = userCalendar.date(from: dateComponents)

            if let indexPath = lastIndexPath{
                self.chatCollectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.bottom, animated: true)
            }
            
            break
            
        case .askedEstimatedHours:
            
            if let indexPath = lastIndexPath{
                self.chatCollectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.bottom, animated: true)
            }
            
        default:
            break

        }

        if let lastMessage = self.chatCollectionView.getMessages().last{ self.chatCollectionView.chatDelegate?.messageTyped(lastMessage) }
    }
    
    func userTypedAllCharacters() {

        if let lastMessage = self.chatCollectionView.getMessages().last{ self.chatCollectionView.chatDelegate?.messageTyped(lastMessage) }
        
    }

    @IBAction func sendButtonTouched(_ sender: UIButton) {
        
        self.view.endEditing(true)

        if let text = textInputField.text{
//            
            if(text.isEmpty){
                
                return
                
            }
            
            textInputView.isHidden = true

            chatCollectionView.add(message: Message(text: text, from: .User))
            dave.received(text: text)
            chatCollectionView.frame = chatOriginalFrame

            
        }
        
    }
    
    @IBAction func addProjectButtonTouched(_ sender: Any) {

        dave.beginCreateProjectFlow()
        addActivityButtonsView.isHidden = true
        chatCollectionView.frame = chatOriginalFrame
        
    }
    
    
    @IBAction func sendDateButtonTouched(_ sender: Any) {
        
        datePickerContainerView.isHidden = true
        dave.received(date: datePicker.date)
        chatCollectionView.frame = chatOriginalFrame
        
    }
    
    @IBAction func sendEstimatedHoursTouched(_ sender: UIButton) {
    
        
    
    }

    @IBAction func sendAvailableDaysTouched(_ sender: UIButton) {

        self.availableDaysSelectionContainerView.isHidden = true
        
        //user sends message telling it has sent the working times
        chatCollectionView.add(message: Message(text: "These are my working hours", from: .User))
        dave.received(availableDays: availableDaysSelectionView.availableDays, contextTitle: "Main")
        chatCollectionView.frame = chatOriginalFrame

//        self.chatCollectionView.frame = chatOriginalFrame
        
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {

            textInputView.frame.origin.y -= keyboardSize.height-49
            chatCollectionView.frame.size.height -= keyboardSize.height-(49+textInputView.frame.size.height)

        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
        
            textInputView.frame.origin.y += keyboardSize.height+49
            chatCollectionView.frame = chatOriginalFrame
            

        }
    }
    
    
    //Estimated time data source
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if(component == 0){
           
            return 1000
            
        }
        
        return 60
        
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {

        return estimatedHoursContainerView.frame.size.width/3.3
        
    }

//    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
//        return 50.0
//    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        pickerLabel.textAlignment = .left
        let titleData = String(row)
        
        let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: ".SFUIText-Medium", size: 20.0)!,NSForegroundColorAttributeName:UIColor.black])
        pickerLabel.attributedText = myTitle
        
        return pickerLabel

    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0{
            estimatedHours = row
        
        }else{
            estimatedMinutes = row
            
        }
        
        
    }
    

}
