//
//  TracksController.swift
//  PS
//
//  Created by Radu Tothazan on 05/04/16.
//  Copyright © 2016 radutot. All rights reserved.
//

import UIKit
import Firebase

class TracksController: UIViewController {

    
    var ref = Firebase(url: "https://ps-radu.firebaseio.com/conferences")
    var refString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Firebase(url: refString)
        // Do any additional setup after loading the view.
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

}
