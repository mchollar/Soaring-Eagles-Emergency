//
//  ResourcesTVC.swift
//  Soaring Eagles Emergency
//
//  Created by Micah Chollar on 8/22/19.
//  Copyright © 2019 Widgetilities. All rights reserved.
//

import UIKit
import MessageUI

class ResourcesTVC: UITableViewController{
    
    var resources = [ResourceGroup]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //navigationController?.navigationBar.backgroundColor = Colors.red
        setupContacts()

    }
    
    private func setupContacts() {
        // Read the file "contacts.txt" line by line and split into headers and rows
        
        guard let path = Bundle.main.path(forResource: "contacts", ofType: "txt") else {
            print("File 'contacts.txt' not found")
            return
        }
        
        do {
            let data = try String(contentsOfFile: path, encoding: .utf8)
            let rows = data.components(separatedBy: .newlines)
            for row in rows {
                let entries = row.components(separatedBy: ";")
                if entries.count != 2 {
                    continue
                }
                if entries[0] == "Header" {
                    let newGroup = ResourceGroup(title: entries[1])
                    resources.append(newGroup)
                    print("New Group created: \(entries[1])")
                } else {
                    let newContact = ResourceContact(name: entries[0], number: entries[1])
                    resources.last?.contacts.append(newContact)
                    print("New Contact created: \(entries)")
                }
                
            }
        } catch {
            print("Unable to read 'contacts.txt' into strings")
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        if cell?.textLabel?.text == "Text",
            let number = cell?.detailTextLabel?.text {
            displayMessageInterface(number: number)
            
        } else if let numberText = cell?.detailTextLabel?.text,
            let number = URL(string: "tel://" + numberText) {
            print("Dialing number")
            UIApplication.shared.open(number)
            
        } else {
            print("unable to create URL")
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func displayMessageInterface(number: String) {
        let composeVC = MFMessageComposeViewController()
        composeVC.messageComposeDelegate = self
        
        // Configure the fields of the interface.
        composeVC.recipients = [number]
        composeVC.body = "I need help!"
        
        // Present the view controller modally.
        if MFMessageComposeViewController.canSendText() {
            self.present(composeVC, animated: true, completion: nil)
        } else {
            print("Can't send messages.")
            //TODO: Ask permission to send messages
        }
    }
    

}

extension ResourcesTVC: MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }
}
