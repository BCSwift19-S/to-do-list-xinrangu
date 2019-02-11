//
//  DetailViewController.swift
//  To_Do_List
//
//  Created by Gu Xinran on 2/10/19.
//  Copyright © 2019 Gu Xinran. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    @IBOutlet weak var toDoField: UITextField!
    @IBOutlet weak var toDoNoteView: UITextView!
    
    
    var toDoNoteItem: String?
    var toDoItem: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let toDoItem = toDoItem{
            toDoField.text = toDoItem
            self.navigationItem.title = "Edit To Do Item"
        }else{
            self.navigationItem.title = "New To Do Item"
        }
        if let toDoNoteItem = toDoNoteItem {
            //If non nil value created, take it. otherwise empty string
            toDoNoteView.text = toDoNoteItem
        }
        enableDisableSaveButton()
        toDoField.becomeFirstResponder()//keyboard
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UnwindFromSave" {
            toDoItem = toDoField.text
            toDoNoteItem = toDoNoteView.text
        }
    }
    
    @IBAction func toDoFieldChanged(_ sender: UITextField) {
        enableDisableSaveButton()
    }
    
    func enableDisableSaveButton(){
        if let toDoFieldCount = toDoField.text?.count, toDoFieldCount > 0 {
            saveBarButton.isEnabled = true
        } else {
            saveBarButton.isEnabled = false
        }
    }
    
    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode{
            dismiss(animated: true, completion: nil)
        }else{
            navigationController?.popViewController(animated: true)
        }
    }
}
