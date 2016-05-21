//
//  LoginViewController.swift
//  PS
//
//  Created by Radu Tothazan on 01/04/16.
//  Copyright © 2016 radutot. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var logoutButton: UIButton!
    var email: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if NSUserDefaults.standardUserDefaults().valueForKey("uid") != nil && CURRENT_USER.authData != nil
        {
            self.logoutButton.hidden = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    @IBAction func loginAction(sender: AnyObject) {
        
        self.email = self.mailTextField.text
        let password = self.passwordTextField.text
        
        if email != "" && password != ""
        {
            FIREBASE_REF.authUser(email, password: password, withCompletionBlock: { (error, authData) -> Void in
            if error == nil
            {
                NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: "uid")
                
                
                if self.email == "admin@admin.ro"
                {
                    self.performSegueWithIdentifier("userSegue", sender: nil)
                }
                else{
                    self.performSegueWithIdentifier("userSegue", sender: nil)
                }
                
                print("Logged in")
                self.logoutButton.hidden = false
                }
                else
            {
                print(error)
                print(password)
                }
            
            })
        }
        else
        {
            let alert = UIAlertController(title: "Error", message: "Enter Email and Password", preferredStyle: .Alert)
            let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
            
        }
        
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "userSegue"{
            let vc = segue.destinationViewController as! UserController
            vc.email = self.email
    }
    }
    
    @IBAction func logoutAction(sender: AnyObject)
    {
        CURRENT_USER.unauth()
        
        NSUserDefaults.standardUserDefaults().setValue(nil, forKey: "uid")
        self.logoutButton.hidden = true
        
        
        
    }

}
