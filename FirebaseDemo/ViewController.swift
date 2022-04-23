//
//  ViewController.swift
//  FirebaseDemo
//
//  Created by Snehal on 17/04/22.
//

import UIKit
import FirebaseDatabase

class ViewController: UIViewController {

    @IBOutlet weak var todoTableView: UITableView!
    var titleArray: [String] = []
    var idArray: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Database.database().reference().child("Todos").observe(.value) { [self] (snapshot) in
            if snapshot.exists() {
                let snaps = snapshot.children
                titleArray = []
                idArray = []
                for snap in snaps {
                    let snapdata = snap as! DataSnapshot
                    let value = snapdata.value as! [String: String]
                    titleArray.append(value["title"]!)
                    idArray.append(value["id"]!)
                }
                DispatchQueue.main.async {
                    self.todoTableView.reloadData()
                }
            }
        }
    }

    @IBAction func onTapOfPlusButton(_ sender: UIBarButtonItem) {
        let vc = storyboard?.instantiateViewController(identifier: "AddTodoViewController") as! AddTodoViewController
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = titleArray[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let str = titleArray[indexPath.row]
        let id = idArray[indexPath.row]
        let editAction = UIContextualAction(style: .normal, title: "Edit") { (act, view, nil) in
            let alertcontroller = UIAlertController(title: "Edit Title", message: "Do you really want to edit?", preferredStyle: .alert)
            alertcontroller.addTextField(configurationHandler: nil)
            alertcontroller.textFields![0].text = str
        
            let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                Database.database().reference().child("Todos").child(id).updateChildValues(["title": alertcontroller.textFields![0].text!])
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alertcontroller.addAction(okAction)
            alertcontroller.addAction(cancelAction)
            self.present(alertcontroller, animated: true, completion: nil)
        }
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (act, view, nil) in
            Database.database().reference().child("Todos").child(id).removeValue()
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
    
}

