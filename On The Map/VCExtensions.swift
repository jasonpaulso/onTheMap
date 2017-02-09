//
//  VCExtensions.swift
//  On The Map
//
//  Created by Jason Southwell on 2/8/17.
//  Copyright © 2017 Jason Southwell. All rights reserved.
//

import UIKit
import Foundation
import SystemConfiguration
import MapKit

extension UIViewController : MKMapViewDelegate, CLLocationManagerDelegate, UIGestureRecognizerDelegate, ShowsAlert {
    
    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard !(annotation is MKUserLocation) else { return nil }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "Annotation") as? MKPinAnnotationView
        
        if annotationView == nil {
            
            let image = #imageLiteral(resourceName: "Arrow")
            let button = UIButton(type: .custom)
            button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            button.setImage(image, for: .normal)
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "Annotation")
            annotationView?.canShowCallout = true
            annotationView?.rightCalloutAccessoryView = button
            
        } else {
            
            annotationView?.annotation = annotation
            
        }
        
        return annotationView
    }
    
    public func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == view.rightCalloutAccessoryView {
            print("Disclosure Pressed! \(String(describing: view.annotation?.subtitle))")
            let url = ((view.annotation?.subtitle)!)! as String
            UIApplication.shared.open(URL(string: url)!)
            
        }
    }
    
    
    
}

