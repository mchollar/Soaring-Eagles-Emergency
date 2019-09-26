//
//  ResourcesCVC.swift
//  Soaring Eagles Emergency
//
//  Created by Micah Chollar on 9/10/19.
//  Copyright © 2019 Widgetilities. All rights reserved.
//

import UIKit
import MessageUI

private let reuseIdentifier = "resourceCell"

class ResourcesCVC: UICollectionViewController {

    var resources = [ResourceGroup]()
    var selectedCell: ResourceCollectionViewCell? {
        didSet {
            if selectedCell == nil {
                oldValue?.setSelected(false)
            } else {
                selectedCell?.setSelected(true)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupResources()
        let inset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        let layout = ResourceCVLayout(cellsPerRow: 3, minimumInteritemSpacing: 8.0, minimumLineSpacing: 16.0, sectionInset: inset)
        collectionView.collectionViewLayout = layout
        collectionView.contentInsetAdjustmentBehavior = .always
        
        
    }

    private func setupResources() {
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
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionViewLayout.invalidateLayout()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1 //resources.count
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return resources.count //resources[section].contacts.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? ResourceCollectionViewCell else {
            fatalError("Unable to dequeue ResourceCollectionViewCell")
        }
        
        //cell.textLabel.text = resources[indexPath.row].title
    
        
        cell.contact = resources[indexPath.row]
        // Configure the cell
    
        return cell
    }
    
    

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
*/
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let cell = collectionView.cellForItem(at: indexPath) as? ResourceCollectionViewCell {
//            cell.setSelected(true)
//            selectedCell = cell
            selectedCell = nil
            selectedCell = cell
        }
        
        let resource = resources[indexPath.row]
        if resource.contacts.count == 1 {
            textOrDial(contact: resource.contacts[0])
            return
        }
        let number1Title = "\(resource.contacts[0].name) - \(resource.contacts[0].number)"
        let number1 = UIAlertAction(title: number1Title, style: .default, handler: { [unowned self] (action) in
            self.textOrDial(contact: resource.contacts[0])
        })
        
        let number2Title = "\(resource.contacts[1].name) - \(resource.contacts[1].number)"
        let number2 = UIAlertAction(title: number2Title, style: .default, handler: { [unowned self] (action) in
            self.textOrDial(contact: resource.contacts[1])
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { [unowned self] (_) in
            self.selectedCell = nil
        })
        
        let alert = UIAlertController(title: resource.title, message: "Select which number to contact", preferredStyle: .actionSheet)
        alert.addAction(number1)
        alert.addAction(number2)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
//    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
//        if let cell = collectionView.cellForItem(at: indexPath) as? ResourceCollectionViewCell {
//            cell.setSelected(false)
//        }
//    }
    
    func textOrDial(contact: ResourceContact) {
        if contact.name == "Text" {
            displayMessageInterface(number: contact.number)
            return
        }
        
        if let number = URL(string: "tel://" + contact.number) {
            print("Dialing: ", number)
            UIApplication.shared.open(number, completionHandler: { [unowned self] (_) in
                self.selectedCell = nil
            })
        }
        
    }
    
    func displayMessageInterface(number: String) {
        let composeVC = MFMessageComposeViewController()
        composeVC.messageComposeDelegate = self
        
        // Configure the fields of the interface.
        composeVC.recipients = [number]
        composeVC.body = "I need help!"
        
        // Present the view controller modally.
        if MFMessageComposeViewController.canSendText() {
            self.present(composeVC, animated: true, completion: {[unowned self] in
                self.selectedCell = nil
            })
        } else {
            print("Can't send messages.")
            selectedCell = nil
            //TODO: Ask permission to send messages
        }
    }
    
    
}

extension ResourcesCVC: MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ResourcesCVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (collectionView.bounds.size.width / 2) - 16.0
        return CGSize(width: width, height: width)
        
    }
    
}
