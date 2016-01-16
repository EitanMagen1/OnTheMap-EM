//
//  SearchBarDelegate.swift
//  On The Map
//
//  Created by Eitan Magen on 06/1/16.
//  Copyright © 2016 Eitan Magen . All rights reserved.
//

import UIKit
import MapKit

//MARK: UISearchBarDelegate

extension InfoPostingViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        searchBar.text = ""
        return true
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        submitButton.enabled = false
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
        
        //clear any previous annotations
        if mapView.annotations.count != 0 {
            let annotation = mapView.annotations[0]
            mapView.removeAnnotation(annotation)
        }
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(searchBar.text!) { (placemarks, error) -> Void in
            
            if placemarks == nil {
                let alertController = UIAlertController(title: nil, message: "Location Not Found", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
                self.activityIndicator.stopAnimating()
                self.presentViewController(alertController, animated: true, completion: nil)
                return
            }
            
            if let placemarks = placemarks {
                
                let firstPlacemark = placemarks[0]
                self.mapString = searchBar.text
                self.latitude = firstPlacemark.location?.coordinate.latitude
                self.longitude = firstPlacemark.location?.coordinate.longitude
                
                //create annotation
                let pointAnnotation = MKPointAnnotation()
                pointAnnotation.title = searchBar.text
                pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: self.latitude!, longitude: self.longitude!)
                
                //create annotation view
                let pinAnnotationView = MKPinAnnotationView(annotation: pointAnnotation, reuseIdentifier: nil)
                self.mapView.centerCoordinate = pointAnnotation.coordinate
                self.mapView.addAnnotation(pinAnnotationView.annotation!)
                let circularRegion = firstPlacemark.region as! CLCircularRegion
                let region = MKCoordinateRegionMakeWithDistance(circularRegion.center, circularRegion.radius, circularRegion.radius)
                self.mapView.setRegion(region, animated: true)
                
                self.activityIndicator.stopAnimating()
                self.submitButton.enabled = true
            }
        }
    }
}