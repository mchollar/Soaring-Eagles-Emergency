//
//  CustomContact.swift
//  Soaring Eagles Emergency
//
//  Created by Micah Chollar on 8/23/19.
//  Copyright © 2019 Widgetilities. All rights reserved.
//

import Foundation

class ResourceContact: Codable {
    
    var name: String
    var number: String
    
    init(name: String, number: String) {
        self.name = name
        self.number = number
    }
    
    // Archiving
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("CustomContacts")
}
