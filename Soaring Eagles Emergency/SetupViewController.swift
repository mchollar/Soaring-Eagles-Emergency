//
//  SetupViewController.swift
//  Soaring Eagles Emergency
//
//  Created by Micah Chollar on 8/23/19.
//  Copyright © 2019 Widgetilities. All rights reserved.
//

import UIKit
import PhoneNumberKit

class SetupViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var primaryTextField: PhoneNumberTextField!
    @IBOutlet weak var secondaryTextField: PhoneNumberTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        var infoImage = UIImage(named: "icons8-info")
//        infoImage = infoImage?.resized(toWidth: 24)
//        
//        navigationItem.rightBarButtonItem = UIBarButtonItem(image: infoImage, style: .plain, target: self, action: #selector(infoButtonTouched))
        
        primaryTextField.delegate = self
        secondaryTextField.delegate = self
        
        let numbers = UserDefaults.standard.object(forKey: "Numbers") as? [String]
        primaryTextField.text = numbers?.first
        secondaryTextField.text = numbers?.last
        
    }
    

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // TODO: Error check
        
        let numbers = [(primaryTextField.text ?? ""), (secondaryTextField.text ?? "")]
        UserDefaults.standard.set(numbers, forKey: "Numbers")
    }
   
    @objc func infoButtonTouched() {
        
    }

}
