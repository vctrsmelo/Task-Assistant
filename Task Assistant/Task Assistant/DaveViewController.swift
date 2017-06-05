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
    private var dave : Dave!
    private var user : User!

    private var userName: String!
    
    private let messageViewWidth: CGFloat = 250.0
    
<<<<<<< HEAD
    //add text (name input)
    @IBOutlet weak var textInputView: UIView!
    @IBOutlet weak var textInputField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    //add project and add task
    @IBOutlet weak var addActivityButtonsView: UIView!
    @IBOutlet weak var addProjectButton: UIButton!
    @IBOutlet weak var addTaskButton: UIButton!
    
=======
    @IBOutlet weak var textInputView: UIView!
    @IBOutlet weak var textInputField: UITextField!
    
    @IBOutlet weak var sendButton: UIButton!
    
    var isUserTurn = false
>>>>>>> 2730042ff23cb1ce1cc665caa315016cc9d01dad
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

        chatCollectionView.delegate = self
        chatCollectionView.dataSource = self
        textInputView.isHidden = true
<<<<<<< HEAD
    
        
        addActivityButtonsView.isHidden = true
=======
>>>>>>> 2730042ff23cb1ce1cc665caa315016cc9d01dad
        
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
        
<<<<<<< HEAD
        let message = chatCollectionView.getMessages()[indexPath.row]
=======
        var message = chatCollectionView.getMessages()[indexPath.row]
>>>>>>> 2730042ff23cb1ce1cc665caa315016cc9d01dad
        
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
        
        if(dave.indexOfNextMessageToSend == 4){ //asked user name
            
            textInputView.isHidden = false
<<<<<<< HEAD
            chatCollectionView.frame.size.height -= textInputView.frame.size.height //adjust size to don`t stay behind textInputView
=======
            chatCollectionView.frame.size.height -= 55
            isUserTurn = true
>>>>>>> 2730042ff23cb1ce1cc665caa315016cc9d01dad
            
        }else if(dave.indexOfNextMessageToSend == 6){ //asked working time
        
            print("pediu horarios")
        
        }else{
        
            dave.sendNextMessage(chatView: chatCollectionView)

        }
    }
    
    func userTypedAllCharacters() {
        
        if(dave.indexOfNextMessageToSend == 4){
            
            dave.sendNextMessage(chatView: chatCollectionView, concatenate: ", "+self.userName+"! :)")

            
        }
        
    }


    @IBAction func sendButtonTouched(_ sender: UIButton) {
        
        if let text = textInputField.text{
            
            if(text.isEmpty){
                
                return
                
            }
            
            //restore original size of chatCollectionView
<<<<<<< HEAD
            chatCollectionView.frame.size.height += textInputView.frame.size.height
=======
            chatCollectionView.frame.size.height += 55
>>>>>>> 2730042ff23cb1ce1cc665caa315016cc9d01dad
            
            //closes keyboard
            self.view.endEditing(true)
            textInputView.isHidden = true
            
            self.userName = text
            
            //user manda mensagem dizendo seu nome
            chatCollectionView.add(message: Message(text: self.userName, from: .User))

        }
        
        
        
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
