//
//  AddTodoViewController.swift
//  FirebaseDemo
//
//  Created by Snehal on 17/04/22.
//

import UIKit
import FirebaseDatabase

class AddTodoViewController: UIViewController {
    @IBOutlet weak var todoTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    

    @IBAction func onTapOfSaveButton(_ sender: UIButton) {
        let ref = Database.database().reference().child("Todos")
        let id = ref.childByAutoId().key
        ref.child(id!).updateChildValues(["title": todoTF.text!, "id": id!])
        navigationController?.popViewController(animated: true)
    }
    
}
