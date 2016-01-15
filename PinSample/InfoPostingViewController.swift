//
//  InfoPostingViewController.swift
//  On The Map
//
//  Created by Eitan Magen on 06/1/16.
//  Copyright © 2016 Eitan Magen . All rights reserved.
//

import UIKit
import MapKit

class InfoPostingViewController: UIViewController, MKMapViewDelegate {
    
    //MARK: IBOutlets
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var testLinkButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK: Properties
    
    var tapRecognizer: UITapGestureRecognizer? = nil
    var firstName: String?
    var lastName: String?
    var mapString: String?
    var longitude: Double?
    var latitude: Double?
    
    //MARK: Lifecycle functions
   /*
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: Delegate stuff
        searchBar.delegate = self
        urlTextField.delegate = self
        
        //MARK: UI stuff
        activityIndicator.hidden = true
        activityIndicator.hidesWhenStopped = true
        testLinkButton.enabled = false
        tapRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        tapRecognizer?.numberOfTapsRequired = 1
        
        //MARK: Other stuff
        getUserInfo()
        getStudentLocation()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        addKeyboardDismissRecognizer()
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardDismissRecognizer()
        unsubscribeFromKeyboardNotifications()
    }
    
    //MARK: UIButton TouchUp Event Handlers
    
    @IBAction func testLinkButtonTouchUp(sender: UIButton) {
        if let requestUrl = NSURL(string: urlTextField.text!) {
            UIApplication.sharedApplication().openURL(requestUrl)
        } else {
            presentError("Please enter a valid URL.")
        }
    }
    
    @IBAction func submitButtonTouchUp(sender: UIButton) {
        if ParseClient.sharedInstance.getObjectID() != nil {
            updateStudent()
        }
        else {
            addNewStudent()
        }
    }
    
    @IBAction func cancelButtonTouchUp(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: Methods to interact with clients
    
    func getUserInfo() {
        UdacityClient.sharedInstance.requestForGETUserData { (userInfo, errorString) -> Void in
            if let userInfo = userInfo as [String: String]? {
                self.firstName = userInfo[UdacityClient.JSONKeys.FirstName]
                self.lastName = userInfo[UdacityClient.JSONKeys.LastName]
            }
            else {
                print(errorString)
                self.presentError("Could not find user's name.")
            }
        }
    }
    
    func getStudentLocation() {
        ParseClient.sharedInstance.getStudentLocation { (success, errorString) -> Void in
            if success {
                print(ParseClient.sharedInstance.getObjectID()!)
            } else {
                print(errorString)
            }
        }
    }
    
    func addNewStudent() {
        var jsonBody = [String:AnyObject]()
        if let firstName = firstName, lastName = lastName, mapString = mapString, mediaURL = urlTextField.text, latitude = latitude, longitude = longitude {
            jsonBody[ParseClient.JSONKeys.UniqueKey] = UdacityClient.sharedInstance.getUserID()
            jsonBody[ParseClient.JSONKeys.FirstName] = firstName
            jsonBody[ParseClient.JSONKeys.LastName] = lastName
            jsonBody[ParseClient.JSONKeys.MapString] = mapString
            jsonBody[ParseClient.JSONKeys.MediaURL] = mediaURL
            jsonBody[ParseClient.JSONKeys.Latitude] = latitude
            jsonBody[ParseClient.JSONKeys.Longitude] = longitude
            
            ParseClient.sharedInstance.requestForPOSTParse(jsonBody) { (success, errorString) -> Void in
                if success {
                    self.completeSubmission()
                } else {
                    print(errorString)
                    self.presentError("Your changes could not be submitted due to a network error.")
                }
            }
        }
        else {
            print("Unable to post location due to missing JSON parameters.")
            presentError("Please complete the form before submitting.")
        }
    }
    
    func updateStudent() {
        var jsonBody = [String:AnyObject]()
        if let mapString = mapString, mediaURL = urlTextField.text, latitude = latitude, longitude = longitude {
            jsonBody[ParseClient.JSONKeys.MapString] = mapString
            jsonBody[ParseClient.JSONKeys.MediaURL] = mediaURL
            jsonBody[ParseClient.JSONKeys.Latitude] = latitude
            jsonBody[ParseClient.JSONKeys.Longitude] = longitude
            
            ParseClient.sharedInstance.requestForPUTParse(jsonBody) { (success, errorString) -> Void in
                if success {
                    self.completeSubmission()
                } else {
                    print(errorString)
                    self.presentError("Your changes could not be submitted due to a network error.")
                }
            }
        }
        else {
            print("Unable to post location due to missing JSON parameters.")
            presentError("Please complete the form before submitting.")
        }
    }
    
    //MARK: Helper methods
    
    func presentError(alertString: String){
        self.activityIndicator.stopAnimating()
        let ac = UIAlertController(title: "Error", message: alertString, preferredStyle: .Alert)
        ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.presentViewController(ac, animated: true, completion: nil)
    }
    
    func completeSubmission() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    */
}