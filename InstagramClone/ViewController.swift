/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import UIKit
import Parse

class ViewController: UIViewController {
    
    var signupActive = true
    
    @IBOutlet var username: UITextField!
    
    @IBOutlet var password: UITextField!
    
    @IBOutlet var signupButton: UIButton!
    
    @IBOutlet var registeredText: UILabel!
    
    @IBOutlet var loginButton: UIButton!
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    func displayAlart(errorTitle: String, errorMessage: String) {
        
        let alart = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: UIAlertControllerStyle.Alert)
        alart.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) in
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
        }))
        
        self.presentViewController(alart, animated: true, completion: nil)
        
    }

    
    @IBAction func signUp(sender: AnyObject) {
        
        if (username.text == "" || password.text == "") {
            
            self.displayAlart("Cannot Be Blank", errorMessage: "Please enter Username and Password")
            
        } else {
            
            activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0,0,50,50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            
            var errorMessage = "Please try again later"
            
            let user = PFUser()
            
            if signupActive == true {
            
                user.username = username.text
                user.password = password.text
            
                user.signUpInBackgroundWithBlock({ (success, error) in
                
                    self.activityIndicator.stopAnimating()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                
                    if error == nil {
                    
                        // Signup successful
                        
                        self.performSegueWithIdentifier("login", sender: self)
                        
                    
                    } else {
                    
                        if let errorString =  error!.userInfo["error"] as? String {
                        
                            errorMessage = errorString
                        
                            self.displayAlart("Failed Signup", errorMessage: errorMessage)
                        }
                    
                    }
                
                })
                
            } else {
                
               PFUser.logInWithUsernameInBackground(username.text!, password: password.text!, block: { (user, error) in
                
                self.activityIndicator.stopAnimating()
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                
                if user != nil {
                
                    // Login successful
                    
                    self.performSegueWithIdentifier("login", sender: self)
                    
                } else {
                    
                    if let errorString =  error!.userInfo["error"] as? String {
                        
                        errorMessage = errorString
                        
                        self.displayAlart("Failed Login", errorMessage: errorMessage)
                    }
                    
                }
                
               })
                
            }
            
            
        }
        
    }
    
    @IBAction func logIn(sender: AnyObject) {
        
        if signupActive == true {
            
            signupButton.setTitle("Login", forState: UIControlState.Normal)
            registeredText.text = "Don't have an account?"
            loginButton.setTitle("Sign Up", forState: UIControlState.Normal)
            
            signupActive = false
            
        } else {
            
            signupButton.setTitle("Sign Up", forState: UIControlState.Normal)
            registeredText.text = "Already have an account?"
            loginButton.setTitle("Login", forState: UIControlState.Normal)
            
            signupActive = true
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool) {
        
        if PFUser.currentUser() != nil {
            
            self.performSegueWithIdentifier("login", sender: self)
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
