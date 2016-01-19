//
//  LogInViewController.swift
//  On_The_Map_EM
//
//  Created by Lauren Efron on 04/01/2016.
//  Copyright © 2016 Eitan_Magen. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
class LogInViewController: UIViewController  {

   var appDelegate : AppDelegate!
    
    var session: NSURLSession!
    
    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var logInText: UILabel!
    @IBOutlet weak var facebookauth: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBAction func signUpButtonTouchUp(sender: UIButton) {
        if let requestUrl = NSURL(string: "https://www.udacity.com/account/auth#!/signin") {
        UIApplication.sharedApplication().openURL(requestUrl)
        } else {
            presentError("Error opening url: " + "https://www.udacity.com/account/auth#!/signin")
        }
    }
    
    @IBAction func loginAuthWithFacebook(sender: AnyObject) {
        logInText.text = "LogIn to Udacity with Facebook"
        let token = FBSDKAccessToken.currentAccessToken()
        
            let loginView : FBSDKLoginButton = FBSDKLoginButton()
            self.view.addSubview(loginView)
            loginView.center = self.view.center
            loginView.readPermissions = ["public_profile", "email", "user_friends"]
        showActivityIndicator()//starts the animation of the login indicator until we loged in!
        var userInfo = [String:String]()
        userInfo[UdacityConstants.JSONKeys.access_token] = "\(token)"
        let jsonBody = [UdacityConstants.JSONKeys.facebook_mobile: userInfo] //build the json body a array of dictianary
        UdacityModel.sheredInstance.requestForPOSTSession(jsonBody , completionHandler: {(success, errorType) -> Void in
            if success {
                dispatch_async(dispatch_get_main_queue(), {
                    self.passwordTextField.text = ""
                    self.showActivityIndicator()//flips the condition of the indictor , stops the animation once logged in
                    self.performSegueWithIdentifier("NavigationSague", sender: self)
                })
            } else if errorType != nil {
                dispatch_async(dispatch_get_main_queue(), {
                    self.showActivityIndicator()//flips the condition of the indictor , stops the animation once logged in
                    self.presentError(errorType!)
                })
                
            }
            
        })

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        facebookauth.hidden = true
        emailTextField.text = ""
        passwordTextField.text = ""
        activityIndicator.hidden = true
    }
    
    @IBAction func logInButton(sender: UIButton) {
            logInText.text = "LogIn to Udacity"
            var userInfo = [String:String]()
            userInfo[UdacityConstants.JSONKeys.Username] = emailTextField.text
            userInfo[UdacityConstants.JSONKeys.Password] = passwordTextField.text
            let jsonBody = [UdacityConstants.JSONKeys.Udacity: userInfo] //build the json body a array of dictianary

            if emailTextField.text!.isEmpty {
                logInText.text = "Username Empty."
                return
            } else if passwordTextField.text!.isEmpty {
                logInText.text = "Password Empty."
                return
            }
                showActivityIndicator()//starts the animation of the login indicator until we loged in!
        
        UdacityModel.sheredInstance.requestForPOSTSession(jsonBody , completionHandler: {(success, errorType) -> Void in
                    if success {
                        dispatch_async(dispatch_get_main_queue(), {
                            self.passwordTextField.text = ""
                            self.showActivityIndicator()//flips the condition of the indictor , stops the animation once logged in
                            self.performSegueWithIdentifier("NavigationSague", sender: self)
                        })
                    } else if errorType != nil {
                        dispatch_async(dispatch_get_main_queue(), {
                            self.showActivityIndicator()//flips the condition of the indictor , stops the animation once logged in
                            self.presentError(errorType!)
                        })
                        
                    }

                })
    }
            
    func showActivityIndicator() {
        if activityIndicator.hidden {
            activityIndicator.hidden = false
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
            activityIndicator.hidden = true
            activityIndicator.hidesWhenStopped = true


        }
    }
    
     override func presentError(alertString: String){
        /* Set transaction for when shake animation ceases */
        showActivityIndicator()
        CATransaction.begin()
        let ac = UIAlertController(title: "Error In Request", message: alertString, preferredStyle: .Alert)
        ac.addAction(UIAlertAction(title: "Dismiss", style: .Default, handler: nil))
        CATransaction.setCompletionBlock { () -> Void in
            self.presentViewController(ac, animated: true, completion: nil)
        }
        
        /* Configure shake animation */
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.3
        animation.autoreverses = true
        let fromPoint: CGPoint = CGPointMake(self.view.center.x - 5, self.emailTextField.center.y)
        let fromValue: NSValue = NSValue(CGPoint: fromPoint)
        let toPoint: CGPoint = CGPointMake(self.view.center.x + 5,self.emailTextField.center.y )
        let toValue: NSValue = NSValue(CGPoint: toPoint)
        animation.fromValue = fromValue
        animation.toValue = toValue
        
        /* Stop animating activity indicator */
        self.activityIndicator.stopAnimating()
        
        /* Animate view layer */
        //  self.view.layer.addAnimation(animation, forKey: "position")
        self.emailTextField.layer.addAnimation(animation, forKey: "position")
        
        /* Commit transaction */
        CATransaction.commit()
    } //Error handeler

    
}

