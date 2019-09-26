//
//  InfoViewController.swift
//  
//
//  Created by Micah Chollar on 9/11/19.
//

import UIKit

class InfoViewController: UIViewController {

    @IBOutlet weak var versionLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        versionLabel.text = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
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
