//
//  BaseService.swift
//  PS
//
//  Created by Radu Tothazan on 01/04/16.
//  Copyright © 2016 radutot. All rights reserved.
//

import Foundation
import Firebase


let FIREBASE_REF = Firebase (url: "https://ps-radu.firebaseio.com")

var CURRENT_USER: Firebase
{

    let userID = NSUserDefaults.standardUserDefaults().valueForKey("uid") as! String
    let currentUser = Firebase(url: "\(FIREBASE_REF)").childByAppendingPath("user").childByAppendingPath(userID)
    return currentUser!
}