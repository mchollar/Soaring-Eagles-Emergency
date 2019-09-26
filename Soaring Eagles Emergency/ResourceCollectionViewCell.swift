//
//  ResourceCollectionViewCell.swift
//  Soaring Eagles Emergency
//
//  Created by Micah Chollar on 9/10/19.
//  Copyright © 2019 Widgetilities. All rights reserved.
//

import UIKit

class ResourceCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var textLabel: UILabel!
    var contact: ResourceGroup? { didSet { setupCell() } }
    
    
    override func awakeFromNib() {
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowOpacity = 0.2
        layer.masksToBounds = false
        backgroundColor = UIColor.init(named: "AppCellBackground")
        //layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
    }
    
    private func setupCell() {
        self.textLabel.text = contact?.title
    }
    
    func setSelected(_ selected: Bool) {
        backgroundColor = selected ? .gray : UIColor.init(named: "AppCellBackground")
    }

}
