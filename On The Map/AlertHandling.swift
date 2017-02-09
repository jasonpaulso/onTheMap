//
//  AlertHandling.swift
//  On The Map
//
//  Created by Jason Southwell on 2/8/17.
//  Copyright © 2017 Jason Southwell. All rights reserved.
//

import UIKit
import Foundation
import SystemConfiguration
import MapKit

protocol ShowsAlert {}

extension ShowsAlert where Self: UIViewController {
    
    func showAlert(title: String = "Error", message: String, buttonText: String? = "OK") {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: buttonText, style: .default) { (action:UIAlertAction!) in
            // OK button tapped
        }
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
}

func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    
    DispatchQueue.main.async {
        
        updates()
        
    }
    
}


