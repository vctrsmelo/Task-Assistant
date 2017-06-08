//
//  DaveViewController.swift
//  Task Assistant
//
//  Created by Victor S Melo on 03/06/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

import UIKit

class DaveViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UserMessageCollectionViewCellDelegate,DaveMessageCollectionViewCellDelegate {
    
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
    
    
    private var lastIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

        chatCollectionView.delegate = self
        chatCollectionView.dataSource = self
        
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

            hideAllComponents()
            chatCollectionView.frame = chatOriginalFrame
            
            if(dave.currentFlow == .none){ self.addActivityButtonsView.isHidden = false }
    
            break
            
        case .askedUserName:
            textInputView.isHidden = false
            chatCollectionView.frame.size.height -= textInputView.frame.size.height //adjust size to don`t stay behind textInputView
            
            if let indexPath = lastIndexPath{ self.chatCollectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.top, animated: true) }

            break
            
        case .askedWorkingDays:
            availableDaysSelectionContainerView.isHidden = false
            chatCollectionView.frame.size.height -= availableDaysSelectionContainerView.frame.size.height
            
            if let indexPath = lastIndexPath{
                self.chatCollectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.top, animated: true)
            }
            
            break
            
        case .askedProjectName:
            if(textInputView.isHidden){
                chatCollectionView.frame.size.height -= textInputView.frame.size.height //adjust size to don`t stay behind textInputView
            }
            
            textInputField.placeholder = "Project Name"
            textInputView.isHidden = false
            
            if let indexPath = lastIndexPath{
                self.chatCollectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.top, animated: true)
            }

            break
            
        case .askedProjectStartingDate:
        
            break
        
        case .askedProjectEndingDate:
            
            break
            
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
//            if(text.isEmpty){
//                
//                return
//                
//            }
//            
//            //restore original size of chatCollectionView
//            chatCollectionView.frame.size.height += textInputView.frame.size.height
//            
//            //closes keyboard
//            self.view.endEditing(true)
//            textInputView.isHidden = true
//
//            switch(viewStatus){
//                
//            case .registeringUser:
//                    self.userName = text
//                    break
//                
//            case .registeringProject:
//                    self.projectName = text
//                    break
//                
//            default:
//                break
//
//            }
//        
//            //user manda mensagem dizendo seu nome
//
            chatCollectionView.add(message: Message(text: text, from: .User))
            
        }
        
    }
    
    @IBAction func addProjectButtonTouched(_ sender: Any) {

        
        
//        self.viewStatus = .registeringProject
//        adjustComponentsTo(status: viewStatus)
        
        dave.beginCreateProjectFlow()
//        addActivityButtonsView.isHidden = true
//        dave.sendNextMessage(chatView: chatCollectionView)

    
    }
    
    
    @IBAction func sendDateButtonTouched(_ sender: Any) {
        
//        projectStartingDate = datePicker.date
        dave.received(date: datePicker.date)
        
    }

    @IBAction func sendAvailableDaysTouched(_ sender: UIButton) {
        
        dave.received(availableDays: availableDaysSelectionView.availableDays, contextTitle: "Main")
        
        //hide available days selection view and restore chat size
        availableDaysSelectionContainerView.isHidden = true
        chatCollectionView.frame = chatOriginalFrame
        
        //user sends message telling it has sent the working times
        chatCollectionView.add(message: Message(text: "These are my working hours", from: .User))
        
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

}
