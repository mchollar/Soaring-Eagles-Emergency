//
//  CustomResourceTVC.swift
//  Soaring Eagles Emergency
//
//  Created by Micah Chollar on 8/23/19.
//  Copyright © 2019 Widgetilities. All rights reserved.
//

import UIKit

class CustomResourceTVC: UITableViewController {

    var contacts = [ResourceContact]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.rightBarButtonItem = self.editButtonItem
        //navigationController?.navigationBar.backgroundColor = Colors.darkBlue
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if let loadedContacts = loadData() {
            contacts = loadedContacts
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath)

        let contact = contacts[indexPath.row]
            cell.textLabel?.text = contact.name
            cell.detailTextLabel?.text = contact.number
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        guard let numberText = cell?.detailTextLabel?.text else { return }
        let formattedNumber = numberText.components(separatedBy: NSCharacterSet.decimalDigits.inverted).joined(separator: "")
        
        if let number = URL(string: "tel://" + formattedNumber) {
            print("Dialing number")
            UIApplication.shared.open(number)
            
        } else {
            print("unable to create URL")
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            contacts.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            saveData()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

        let movedObject = contacts.remove(at: fromIndexPath.row)
        contacts.insert(movedObject, at: to.row)
        saveData()
        
    }
    
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let destination = segue.destination as? CreateCustomResourceViewController {
            if let indexPath = tableView.indexPathForSelectedRow {
                destination.contact = contacts[indexPath.row]
                destination.isEditingExisting = true
            }
            destination.delegate = self
            
        }
    }
    
    
    // MARK: - Saving and Loading
    
    func saveData() {
        
        var savedData = Data()
        do {
            savedData = try JSONEncoder().encode(contacts)
        } catch let error {
            print(error.localizedDescription)
            return
        }
        
        do {
            try savedData.write(to: ResourceContact.ArchiveURL)
            print("Successful save of Custom Contacts, size: \(savedData.count)")
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func loadData() -> [ResourceContact]? {
        var data = Data()
        do {
            data = try Data(contentsOf: ResourceContact.ArchiveURL)
        } catch let error {
            print(error.localizedDescription)
            print("Error in reading data in loadData(): ", error)
            return nil
        }
        do {
            let objects = try JSONDecoder().decode([ResourceContact].self, from: data)
            return objects
            
        } catch let error {
            print(error.localizedDescription)
            print("Error in JSON decoding in loadData(): ", error)
        }
        return nil
    }

}

extension CustomResourceTVC: CreateCustomResourceDelegateProtocol {
    func add(contact: ResourceContact) {
        contacts.append(contact)
        saveData()
        tableView.reloadData()
    }
}
