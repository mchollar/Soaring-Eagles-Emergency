//
//  FirstViewController.swift
//  Soaring Eagles Emergency
//
//  Created by Micah Chollar on 8/20/19.
//  Copyright © 2019 Widgetilities. All rights reserved.
//

import UIKit
import MessageUI
import CoreLocation

class EmergencyViewController: UIViewController, MFMessageComposeViewControllerDelegate {
    
    //let DOPhoneNumber = "8144047460"
    //let CCPhoneNumber = "2109198891"
    //let testNumber = "8302007588"

    @IBOutlet weak var helpButton: UIButton!
    @IBOutlet weak var unlockButton: UIButton!
    
    @IBOutlet weak var activeShooterButton: UIButton!
    @IBOutlet weak var suspiciousActButton: UIButton!
    
    @IBOutlet weak var shareLocationButton: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var lockedState: Bool = true {
        didSet {
            helpButton.isEnabled = !lockedState
            activeShooterButton.isEnabled = !lockedState
            suspiciousActButton.isEnabled = !lockedState
            shareLocationButton.isEnabled = !lockedState
            unlockButton.setTitle(lockedState ? "Unlock" : "Lock", for: .normal)
        }
    }
    
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        lockedState = true
        activityIndicator.stopAnimating()
        
        if #available(iOS 13.0, *) {
            activityIndicator.style = .medium
        } else {
            activityIndicator.style = .gray
        }
        
        
        // Location setup stuff
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        locationManager = appDelegate.locationManager
        locationManager.delegate = self
        
    }

    
    @IBAction func unlockButtonTouched(_ sender: UIButton) {
        lockedState.toggle()
    }
    
    @IBAction func helpButtonTouched(_ sender: UIButton) {
        
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        displayMessageInterface()
        
    }
    
    @IBAction func activeShooterButtonTouched(_ sender: UIButton) {
        let dial911Action = UIAlertAction(title: "Call 911", style: .default, handler: {(action) in
            if let number = URL(string: "tel://911") {
                print("Dialing: ", number)
                UIApplication.shared.open(number)
            }
            
        })
        let callSFAction = UIAlertAction(title: "Call SF - 719-333-2000", style: .default, handler: {(action) in
            if let number = URL(string: "tel://7193332000") {
                print("Dialing: ", number)
                UIApplication.shared.open(number)
            }
            
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let alert = UIAlertController(title: "Report Active Shooter?", message: "First:\nESCAPE - BARRICADE - FIGHT\nOnce that has been accomplished, report to one or both of these numbers.", preferredStyle: .actionSheet)
        alert.addAction(dial911Action)
        alert.addAction(callSFAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func suspiciousActButtonTouched(_ sender: UIButton) {
        let callSFAction = UIAlertAction(title: "Call SF - 719-333-2000", style: .default, handler: {(action) in
            if let number = URL(string: "tel://7193332000") {
                print("Dialing: ", number)
                UIApplication.shared.open(number)
            }
            
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let alert = UIAlertController(title: "Report Suspicious Activity?", message: nil, preferredStyle: .actionSheet)
        alert.addAction(callSFAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func shareLocationTouched(_ sender: UIButton) {
        
        let auth = CLLocationManager.authorizationStatus()
        guard auth == .authorizedAlways || auth == .authorizedWhenInUse else {
            print("Location Manager Authorization Status is: \(auth.rawValue)")
            //locationManager.requestWhenInUseAuthorization()
            locationServicesNeeded()
            return
        }
        
        activityIndicator.startAnimating()
        locationManager.requestLocation()
        
    }
    
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    /// Will initiate a text message to the primary and secondary phone numbers
    /// - Parameter location: A String that contains the maps.google.com link with lat/long. If nil, then the text message body will say "*** I need help! ***"
    func displayMessageInterface(location: String? = nil) {
        
        guard let numbers = UserDefaults.standard.object(forKey: "Numbers") as? [String] else {
            print("No numbers found")
            activityIndicator.stopAnimating()
            displayNoNumbersAlert()
            return
        }
        
        let composeVC = MFMessageComposeViewController()
        composeVC.messageComposeDelegate = self
        
        // Configure the fields of the interface.
        
        composeVC.recipients = numbers
        if location == nil {
            composeVC.body = "*** I need help! ***"
        } else {
            composeVC.body = location
        }
        
        // Present the view controller modally.
        if MFMessageComposeViewController.canSendText() {
            
            self.present(composeVC, animated: true, completion: { [unowned self] in self.activityIndicator.stopAnimating()})
        } else {
            activityIndicator.stopAnimating()
            print("Can't send messages to numbers: \(numbers).")
            //TODO: Ask permission to send messages
        }
    }
    
    private func displayNoNumbersAlert() {
        let message = "No primary or secondary alert numbers have been set. Please tap on the 'Setup' button above to set them up and then try again."
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        let alert = UIAlertController(title: "No Numbers Set Up", message: message, preferredStyle: .alert)
        alert.addAction(okAction)
        self.present(alert, animated: true)
        
    }
}

extension EmergencyViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        activityIndicator.stopAnimating()
        guard let location = locations.first else { return }
        
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        displayMessageInterface(location: "https://maps.google.com/?q=\(latitude),\(longitude)")
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        activityIndicator.stopAnimating()
        print(error)
        guard let clError = error as? CLError else { return }
        
        let message: String
        
        switch clError.code {
        case .denied:
            locationServicesNeeded()
            return
            
        default:
            message = "Error experienced in location retrieval. Please try again.\nError code: \(clError.code.rawValue) -  \(clError.localizedDescription)"
        }
        
        let alert = UIAlertController(title: "Location Error", message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func locationServicesNeeded() {
        
        let message = "Location services are not currently authorized. Please activate location services in settings and try again."
        let settingsAction = UIAlertAction(title: "Settings", style: .default, handler: { (_) in
            // Direct user to app settings
            if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSettings)
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        let alert = UIAlertController(title: "Permissions Error", message: message, preferredStyle: .alert)
        
        alert.addAction(cancelAction)
        alert.addAction(settingsAction)
        
        self.present(alert, animated: true, completion: nil)
    }
}
