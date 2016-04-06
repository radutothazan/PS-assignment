//
//  AdaugareConferintaController.swift
//  PS
//
//  Created by Radu Tothazan on 03/04/16.
//  Copyright © 2016 radutot. All rights reserved.
//

import UIKit

class AdaugareConferintaController: UIViewController {

    @IBOutlet weak var adaugareConfLabel: UILabel!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var daysText: UITextField!
    @IBOutlet weak var tracksText: UITextField!
    @IBOutlet weak var ticketsNoText: UITextField!
    @IBOutlet weak var ticketsPriceText: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
    @IBAction func adaugareButton(sender: AnyObject) {
        let name = self.nameText.text
        let days = self.daysText.text
        let tracks = self.tracksText.text
        let ticketsno = self.ticketsNoText.text
        let ticketsprice = self.ticketsPriceText.text
        
        
        if name != ""{
        
        let conf1 : Dictionary<String, AnyObject> = ["days": days!, "tracks": tracks!, "ticketsno": ticketsno!, "ticketsprice": ticketsprice!]
        let confRef = FIREBASE_REF.childByAppendingPath("conferences")
        confRef.childByAppendingPath(name).setValue(conf1)
        }
    }

}
