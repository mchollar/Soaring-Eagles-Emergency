//
//  CreateCustomResourceViewController.swift
//  Soaring Eagles Emergency
//
//  Created by Micah Chollar on 8/23/19.
//  Copyright © 2019 Widgetilities. All rights reserved.
//

import UIKit
import PhoneNumberKit

class CreateCustomResourceViewController: UIViewController, UITextFieldDelegate {

    var contact: ResourceContact?
    var isEditingExisting = false
    weak var delegate: CreateCustomResourceDelegateProtocol?
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var numberTextField: PhoneNumberTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if contact == nil {
            contact = ResourceContact(name: "", number: "")
        }
        nameTextField.delegate = self
        numberTextField.delegate = self
        
        //navigationController?.navigationBar.backgroundColor = Colors.darkBlue
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let textEntered = textField.text else { return }
        // TODO: Error check
        
        switch textField {
        case nameTextField:
            contact?.name = textEntered
        case numberTextField:
            contact?.number = textEntered
        default:
            break
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    
    @IBAction func doneButtonTouched(_ sender: UIButton) {
        guard let contact = contact else { return }
        
        nameTextField.resignFirstResponder()
        numberTextField.resignFirstResponder()
        
        if contact.number != "" {
            delegate?.add(contact: contact)
        }
        navigationController?.popViewController(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
}

protocol CreateCustomResourceDelegateProtocol: class {
    func add(contact: ResourceContact)
}
