//
//  DaveViewController.swift
//  Task Assistant
//
//  Created by Victor S Melo on 03/06/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

import UIKit

class DaveViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource {

    @IBOutlet weak var chatCollectionView: ChatCollectionView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        chatCollectionView.add(message: Message(withMessage: "Mensagem User", from: .User))
        chatCollectionView.add(message: Message(withMessage: "Mensagem Dave", from: .Dave))
        
        chatCollectionView.delegate = self
        chatCollectionView.dataSource = self
    
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
        print("tttt")
        let messageCell:MessageCollectionViewCell = self.chatCollectionView.dequeueReusableCell(withReuseIdentifier: "messageCell", for: indexPath) as! MessageCollectionViewCell
        
        messageCell.set(message: chatCollectionView.getMessages()[indexPath.row])
        
        print("past message \(messageCell.textView.text)")
        return messageCell
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
