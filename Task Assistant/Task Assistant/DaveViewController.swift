//
//  DaveViewController.swift
//  Task Assistant
//
//  Created by Victor S Melo on 03/06/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

import UIKit

enum DaveViewControllerStatus {
    case registeringUser
    case registeringProject
    case registeringTask
    case none
}

class DaveViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UserMessageCollectionViewCellDelegate,DaveMessageCollectionViewCellDelegate {

    //viewStatus controls in what proccess user currently is
    private var viewStatus : DaveViewControllerStatus = .none
    
    @IBOutlet weak var chatCollectionView: ChatCollectionView!
    private var dave : Dave!
    private var user : User!
    
    private var projectBeingCreated : Project?
    private var projectName: String!
    
    
    private var userName: String!
    private var userContexts: [Context]!
    
    private let messageViewWidth: CGFloat = 250.0
    
    //add text (name input)
    @IBOutlet weak var textInputView: UIView!
    @IBOutlet weak var textInputField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    //add project and add task
    @IBOutlet weak var addActivityButtonsView: UIView!
    @IBOutlet weak var addProjectButton: UIButton!
    @IBOutlet weak var addTaskButton: UIButton!
    
    @IBOutlet weak var availableDaysSelectionContainerView: UIView!
    @IBOutlet weak var availableDaysSelectionView: AvailableDaysSelectionView!
    @IBOutlet weak var sendAvailableDays: UIButton!
    
    private var lastIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

        if user == nil {
            
            viewStatus = .registeringUser
            
        }
        
        chatCollectionView.delegate = self
        chatCollectionView.dataSource = self
        textInputView.isHidden = true

        addActivityButtonsView.isHidden = true
        
        availableDaysSelectionContainerView.isHidden = true
        
        dave = Dave(isUserDefined: false)
        
        dave.sendNextMessage(chatView: chatCollectionView)

        self.view.setNeedsDisplay()
    
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
                
                messageCell.write(message: message, typingEffect: true)
                messageCell.delegate = self
            
            }else{
                
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
        
        switch(viewStatus){
        
        case .registeringUser:
        
            if(dave.indexOfNextMessageToSend == 4){ //asked user name
                
                textInputView.isHidden = false
                chatCollectionView.frame.size.height -= textInputView.frame.size.height //adjust size to don`t stay behind textInputView
                
                if let indexPath = lastIndexPath{
                    self.chatCollectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.top, animated: true)
                }
           
            }else if(dave.indexOfNextMessageToSend == 6){ //asked working time
            
                availableDaysSelectionContainerView.isHidden = false
                chatCollectionView.frame.size.height -= availableDaysSelectionContainerView.frame.size.height
                
                if let indexPath = lastIndexPath{
                    self.chatCollectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.top, animated: true)
                }
                
            }else if(dave.indexOfNextMessageToSend == 7){ //user provided all information
                
                user = User(name: userName, contexts: userContexts)

                self.viewStatus = .none
                
                chatCollectionView.frame.size.height -= addActivityButtonsView.frame.size.height
                
                if let indexPath = lastIndexPath{
                    self.chatCollectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.top, animated: true)
                }

                addActivityButtonsView.isHidden = false

            }else{
            
                dave.sendNextMessage(chatView: chatCollectionView)

            }
            
            break
            
        case .registeringProject:
            
            if(dave.indexOfNextMessageToSend == 2){ //Dave asked for projects name
            
                textInputView.isHidden = false
                chatCollectionView.frame.size.height -= textInputView.frame.size.height //adjust size to don`t stay behind textInputView
                
                if let indexPath = lastIndexPath{
                    self.chatCollectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.top, animated: true)
                }
            }
            
            break
            
        case .registeringTask:
            break
        
        case .none:
            break
            
        }
    }
    
    func userTypedAllCharacters() {
        
        switch viewStatus {
        
        case .registeringUser:
            
            if(dave.indexOfNextMessageToSend == 4){ //user sent his/her name
                
                dave.sendNextMessage(chatView: chatCollectionView, concatenate: ", "+self.userName+"! :)")
                
                
            }else if(dave.indexOfNextMessageToSend == 6){ //user sent his/her daily working time
                
                dave.sendNextMessage(chatView: chatCollectionView)
                
            }
            
            break
            
        case .registeringProject:
            
            if(dave.indexOfNextMessageToSend == 1){ //user sent the project name
            
                dave.sendNextMessage(chatView: chatCollectionView)
                
            }
            
            break
            
        case .registeringTask:
            break
            
        case .none:
            break
        
        }
    }

    @IBAction func sendButtonTouched(_ sender: UIButton) {
        
        if let text = textInputField.text{
            
            if(text.isEmpty){
                
                return
                
            }
            
            //restore original size of chatCollectionView
            chatCollectionView.frame.size.height += textInputView.frame.size.height
            
            //closes keyboard
            self.view.endEditing(true)
            textInputView.isHidden = true

            switch(viewStatus){
                
            case .registeringUser:
                    self.userName = text
                    break
                
            case .registeringProject:
                    self.projectName = text
                    break
                
            default:
                break

            }
        
            //user manda mensagem dizendo seu nome
            chatCollectionView.add(message: Message(text: text, from: .User))
            
        
        }
        
        
        
    }
    
    @IBAction func addProjectButtonTouched(_ sender: Any) {

        print("addProjectTouched")
        viewStatus = .registeringProject
        
        dave.beginAddProjectFlow()
        dave.sendNextMessage(chatView: chatCollectionView)
        addActivityButtonsView.isHidden = true
    
    }
    
    @IBAction func sendAvailableDaysTouched(_ sender: UIButton) {
        
        //create context
        userContexts = [Context(title: "Main", availableDays: availableDaysSelectionView.availableDays)]
        
        //hide available days selection view
        availableDaysSelectionContainerView.isHidden = true
        
        //restore collectionView size
        chatCollectionView.frame.size.height += availableDaysSelectionContainerView.frame.size.height
        
        //user sends message telling it has sent the working times
        chatCollectionView.add(message: Message(text: "These are my working times", from: .User))
        
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
            chatCollectionView.frame.size.height += keyboardSize.height-(49+textInputView.frame.size.height)
            

        }
    }

}
