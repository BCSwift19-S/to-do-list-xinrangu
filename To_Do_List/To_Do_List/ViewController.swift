//
//  ViewController.swift
//  To_Do_List
//
//  Created by Gu Xinran on 2/10/19.
//  Copyright © 2019 Gu Xinran. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editBarButton: UIBarButtonItem!
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    
    var defaultsData = UserDefaults.standard
    var toDoArray = [String]()
    var toDoNotesArray = [String]()
//    var toDoArray = ["Learn Swift", "Build Apps", "Change the World"]
//    var toDoNotesArray = ["I should be certain to do all exercises","take my ideas to school","focus apps on empowerment for all"]
//
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        toDoArray = defaultsData.stringArray(forKey: "toDoArray") ?? [String]()
        //if nil, empty string
        toDoNotesArray = defaultsData.stringArray(forKey: "toDoNotesArray") ?? [String]()
        
    }
    
    func saveDefaultsData(){
        defaultsData.set(toDoArray, forKey: "toDoArray")
        defaultsData.set(toDoNotesArray, forKey: "toDoNotesArray")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditItem"{
            let destination = segue.destination as! DetailViewController
            let index = tableView.indexPathForSelectedRow!.row//index of row clicked on
            destination.toDoItem = toDoArray[index]
            destination.toDoNoteItem = toDoNotesArray[index]
        }
    }
    
    @IBAction func unwindFromDetailViewController(segue: UIStoryboardSegue) {
        //unwind = swith the source and destination back?
        let sourceViewController = segue.source as! DetailViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            toDoArray[indexPath.row] = sourceViewController.toDoItem!
            toDoNotesArray[indexPath.row] = sourceViewController.toDoNoteItem!
            tableView.reloadRows(at: [indexPath], with: .automatic)
        } else {
            let newIndexPath = IndexPath(row: toDoArray.count, section: 0)
            toDoArray.append(sourceViewController.toDoItem!)
            toDoNotesArray.append(sourceViewController.toDoNoteItem!)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
        saveDefaultsData()
    }
    
    @IBAction func editBarButtonPressed(_ sender: UIBarButtonItem) {
        if tableView.isEditing {//editing mode, left corner is done when clicked button
            tableView.setEditing(false, animated: true)
            addBarButton.isEnabled = true
            editBarButton.title = "Edit"
        } else {//get in editing mode
            tableView.setEditing(true, animated: true)
            addBarButton.isEnabled = false
            editBarButton.title = "Done"
        }
    }
    
    @IBAction func addBarButtonPressed(_ sender: UIBarButtonItem) {
    }
    
}

extension ViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = toDoArray[indexPath.row]
        cell.detailTextLabel?.text = toDoNotesArray[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            toDoArray.remove(at: indexPath.row)
            toDoNotesArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            saveDefaultsData()
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let itemToMove = toDoArray[sourceIndexPath.row]//make a copy to move around
        let noteToMove = toDoNotesArray[sourceIndexPath.row]
        toDoArray.remove(at: sourceIndexPath.row)//remove original
        toDoNotesArray.remove(at: sourceIndexPath.row)
        toDoArray.insert(itemToMove, at: destinationIndexPath.row)
        toDoNotesArray.insert(noteToMove, at: destinationIndexPath.row)
        saveDefaultsData()
    }
}
