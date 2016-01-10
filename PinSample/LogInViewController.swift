//
//  LogInViewController.swift
//  On_The_Map_EM
//
//  Created by Lauren Efron on 04/01/2016.
//  Copyright © 2016 Eitan_Magen. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController {

   var appDelegate : AppDelegate!
    
    var session: NSURLSession!
    
    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var logInText: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBAction func signUpButtonTouchUp(sender: UIButton) {
        if let requestUrl = NSURL(string: "https://www.udacity.com/account/auth#!/signin") {
        UIApplication.sharedApplication().openURL(requestUrl)
        } else {
            print("Error opening url: " + "https://www.udacity.com/account/auth#!/signin")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.text = "eitan.magen1@gmail.com"
        passwordTextField.text = "Password2345"
        activityIndicator.hidden = true
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logInButton(sender: UIButton) {
            logInText.text = ""
            if emailTextField.text!.isEmpty {
                logInText.text = "Username Empty."
                return
            } else if passwordTextField.text!.isEmpty {
                logInText.text = "Password Empty."
                return
            } else {
                showActivityIndicator()//starts the animation of the login indicator until we loged in!
                getLogedIn()
        }
    }
    
        func completeLogin() {
            dispatch_async(dispatch_get_main_queue(), {
                self.logInText.text = "Login To Udacity"
                self.passwordTextField.text = ""
                self.showActivityIndicator()//flips the condition of the indictor , stops the animation once logged in
                self.performSegueWithIdentifier("NavigationSague", sender: self)
            })
        }
        
    ///Function is called when a user presses the log in button; it authenticates with Udacity

        func getLogedIn() {
            
            
            /* 1. Set the parameters */
           //there are none
            
            /* 2. Build the URL */
           // let urlString = appDelegate.URLBase + appDelegate.session
            let urlString = "https://www.udacity.com/api/session"
            let url = NSURL(string: urlString)!
            
            /* 3. Configure the request */
            let request = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
         //   var userInfo = [String:String]()
            
         //   userInfo[UdacityClient.JSONKeys.Username] = emailTextField.text
        //    userInfo[UdacityClient.JSONKeys.Password] = passwordTextField.text
          //  let jsonBody = [UdacityClient.JSONKeys.Udacity: userInfo]
            
           request.HTTPBody = "{\"udacity\": {\"username\": \"\(emailTextField.text!)\", \"password\": \"\(passwordTextField.text!)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
            
            /* 4. Make the request */
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithRequest(request) { (data, response, error) in
                
                /* GUARD: Was there an error? */
                guard (error == nil) else {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.logInText.text = "Login Failed (Udacity)."
                    }
                    print("There was an error with your request: \(error)")
                    return
                }
                
                /* GUARD: Did we get a successful 2XX response? */
                guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                    if let response = response as? NSHTTPURLResponse {
                        print("Your request returned an invalid response! Status code: \(response.statusCode)!")
                    } else if let response = response {
                        print("Your request returned an invalid response! Response: \(response)!")
                    } else {
                        print("Your request returned an invalid response!")
                    }
                    return
                }
                
                /* GUARD: Was there any data returned? */
                guard let data = data else {
                    print("No data was returned by the request!")
                    return
                }
                
                /* subset response data! only from Udacity API*/
                let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))

                /* 5. Parse the data */
                let parsedResult: AnyObject!
                do {
                    parsedResult = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments)
                } catch {
                    parsedResult = nil
                    print("Could not parse the data as JSON: '\(data)'")
                    return
                }
                
                /* GUARD: Is the "account" key in parsedResult? */
                guard let accountStatus = parsedResult["account"] as? [String : AnyObject] else {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.logInText.text = "Login Failed (account is not found)."
                    }
                    print("student is not registered \(self.emailTextField)")
                    return
                }
                guard let UserID = accountStatus["key"] as? String else {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.logInText.text = "Login Failed (User is not registered)."
                    }
                    return
                    }
                
                /* 6. Use the data! */
            }
            
            /* 7. Start the request */
            task.resume()
            completeLogin()
        }
        
    func showActivityIndicator() {
        if activityIndicator.hidden {
            activityIndicator.hidden = false
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }

}

