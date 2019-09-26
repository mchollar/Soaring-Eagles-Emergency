//
//  ResourceGroup.swift
//  Soaring Eagles Emergency
//
//  Created by Micah Chollar on 9/10/19.
//  Copyright © 2019 Widgetilities. All rights reserved.
//

import Foundation

class ResourceGroup: Codable {
    var title: String
    var contacts = [ResourceContact]()
    
    init(title: String) {
        self.title = title
    }
}
