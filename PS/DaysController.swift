//
//  DaysController.swift
//  PS
//
//  Created by Radu Tothazan on 03/04/16.
//  Copyright © 2016 radutot. All rights reserved.
//

import UIKit
import Firebase
import MessageUI

class DaysController: UIViewController, UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate {

    
    @IBOutlet weak var tableView: UITableView!
    var ref = Firebase(url: "https://ps-radu.firebaseio.com/conferences")
    var refAuth = Firebase(url: "https://ps-radu.firebaseio.com/bilete")
    var refString = ""
    var texts = ["Day 1"]
    var days = ""
    var daysNr:Int = 0
    let refreshControl: UIRefreshControl = UIRefreshControl()
    var numarBilete = 0
    var pretBilet = 0
    var bileteCumparate = 0
    var ok = true
    var email: String!
    var bileteCumparateDeja: Int!
    
    @IBOutlet weak var addOutlet: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.texts.removeAll()
        refreshControl.addTarget(self, action: "uiRefreshControlAction", forControlEvents: .ValueChanged)
        self.tableView.addSubview(refreshControl)
        ref = Firebase(url: refString)
        print(refString)
        uiRefreshControlAction()
        if self.email == "admin@admin.ro"{
            self.addOutlet.hidden = false
        }
        else{
            self.addOutlet.hidden = true
        }
        // Do any additional setup after loading the view.
    }
    
    
    func uiRefreshControlAction(){
        ref.observeEventType(.ChildAdded, withBlock:{ snapshot in
        if !self.texts.contains(snapshot.key) && snapshot.key != "NumarBilete" && snapshot.key != "PretBilet"
        {
            self.texts += ["\(snapshot.key)"]
        }
    })
    print(self.texts)
    self.tableView.reloadData()
    refreshControl.endRefreshing()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        let indexPath1 = indexPath.row-1
        if editingStyle == UITableViewCellEditingStyle.Delete{
            texts.removeAtIndex(indexPath1)
            print(texts[indexPath1])
            let refRemove = Firebase(url: refString+"/\(texts[indexPath1])")
            refRemove.removeValue()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            self.texts.removeAll()
        }
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.texts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell2", forIndexPath: indexPath) as! Cell2TableViewCell
        cell.label.text = self.texts[indexPath.row]
        return cell
    }
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("Vizualizare3Segue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Vizualizare3Segue"
        {
            let indexPaths = self.tableView!.indexPathsForSelectedRows!
            let indexPath = indexPaths[0] as NSIndexPath
            
            let newRefString = refString+"/\(texts[indexPath.row])"
            let vc = segue.destinationViewController as! TracksController
            vc.refString = newRefString
            vc.email = self.email
            vc.title = self.texts[indexPath.row]
            
        }
        if segue.identifier == "Back1Segue"
        {
            let vc = segue.destinationViewController as! UserController
            vc.email = self.email
        }
    }

    
    @IBAction func addAction(sender: AnyObject) {
        let alertController = UIAlertController(title: "Adaugare", message: "Zi", preferredStyle: .Alert)
        let addActionAlert = UIAlertAction(title: "Adaugare", style: .Default){ (_) in
            
            let conferintaTextField = alertController.textFields![0] as UITextField
            let conferintaText = conferintaTextField.text
            if conferintaText != ""{
                self.ref.childByAppendingPath(conferintaText).setValue(conferintaText)
            }
            
        }
        addActionAlert.enabled = false
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (_) in }
        
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Conferinta"
            
            NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidChangeNotification, object: textField, queue: NSOperationQueue.mainQueue()) { (notification) in
                addActionAlert.enabled = textField.text != ""
            }
        }
        
        
        alertController.addAction(addActionAlert)
        alertController.addAction(cancelAction)
        self.presentViewController(alertController, animated: true,completion: nil)
   
    }

    @IBAction func cumparareAction(sender: AnyObject) {
        let alertController1 = UIAlertController(title: "Biletele au fost rezervate!", message: "Le puteti gasi in cos", preferredStyle: .Alert)
//        let addActionAlert1 = UIAlertAction(title: "Cumparare", style: .Default){
//            (_) in
//            self.ref.observeEventType(.Value, withBlock: {snapshot in
//                    //self.bileteCumparate = snapshot.value.objectForKey("NumarBilete") as! Int
//                    //self.pretBilet = snapshot.value.objectForKey("PretBilet") as! Int
//                    self.ref.childByAppendingPath("NumarBilete").setValue(self.bileteCumparate - self.numarBilete)
//            })
//        }
        
        let cancelAction1 = UIAlertAction(title: "Ok", style: .Cancel) { (_) in }
        //alertController1.addAction(addActionAlert1)
        alertController1.addAction(cancelAction1)
        
        
        
        
        
        
        let alertController = UIAlertController(title: "Rezervare", message: "Bilete", preferredStyle: .Alert)
        let addActionAlert = UIAlertAction(title: "Rezervare", style: .Default){ (_) in
            
            let conferintaTextField = alertController.textFields![0] as UITextField
            let bileteText = conferintaTextField.text
            if bileteText != ""{
                self.ok = true
                self.numarBilete = Int.init(bileteText!)!
                self.ref.observeEventType(.Value, withBlock: {snapshot in
                    if self.ok == true{
                        self.bileteCumparate = snapshot.value.objectForKey("NumarBilete") as! Int
                        let pretBiletText = snapshot.value.objectForKey("PretBilet") as! String
                        self.pretBilet = Int.init(pretBiletText)!
                        print(self.numarBilete)
                        print(self.pretBilet)
                        print(self.email)
                        self.presentViewController(alertController1, animated: true,completion: nil)
                        
                        self.ok = false
                    }
                })
                var backRefString = ""
                var count = 0
                for var i=0; i < self.email.characters.count;i=i+1{
                    if self.email[self.email.startIndex.advancedBy(i)] == "."{
                        count = count + 10
                    }
                    if count <= 0{
                        backRefString.append(self.email[self.email.startIndex.advancedBy(i)])
                    }
                }
                
                
                var conference = ""
                var count1 = 0
                for var i=0; i < self.refString.characters.count;i=i+1{
                    if self.refString[self.refString.startIndex.advancedBy(i)] == "/"{
                        count1 = count1 + 1
                    }
                    if count1 > 3{
                        conference.append(self.refString[self.refString.startIndex.advancedBy(i)])
                    }
                }
                let conference1 = String(conference.characters.dropFirst())
                print(conference1)
                
               // var ok = true
//                self.refAuth.observeEventType(.ChildAdded, withBlock: {snapshot in
//                    print(snapshot.key)
//                    if snapshot.key == backRefString
//                    {
//                        let bileteRezervate = snapshot.value.objectForKey("BileteRezervate") as! Int
//                        self.refAuth.childByAppendingPath(backRefString).childByAppendingPath(conference1).childByAppendingPath("BileteRezervate").setValue(self.numarBilete + bileteRezervate)
//                        ok = false
//                    }
//                    })
                
                
//                if ok == true{
//                self.refAuth.childByAppendingPath(backRefString).childByAppendingPath(conference1).childByAppendingPath("BileteCumparate").setValue(self.numarBilete)
//                }
                
                
               
            }
            
        }
        addActionAlert.enabled = false
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (_) in }
        
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Numar Bilete"
            
            NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidChangeNotification, object: textField, queue: NSOperationQueue.mainQueue()) { (notification) in
                addActionAlert.enabled = textField.text != ""
            }
        }
        
        
        alertController.addAction(addActionAlert)
        alertController.addAction(cancelAction)
        self.presentViewController(alertController, animated: true,completion: nil)
    }
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        
        var conference = ""
        var count = 0
        for var i = 0; i < self.refString.characters.count; i = i + 1{
            if self.refString[self.refString.startIndex.advancedBy(i)] == "/"{
                count = count + 1
            }
            if count > 3{
                conference.append(self.refString[self.refString.startIndex.advancedBy(i)])
            }
        }
        let conference1 = String(conference.characters.dropFirst())
        
        mailComposerVC.setToRecipients([self.email])
        mailComposerVC.setSubject("Felicitari pentru achizitionarea biletelor")
        mailComposerVC.setMessageBody("Ati achizitionat \(self.numarBilete) bilete pentru evenimentul \(conference1) in valoare de \(self.pretBilet * self.numarBilete) lei?", isHTML: false)
        
        return mailComposerVC
    }
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func CartAction(sender: AnyObject) {
        var conference = ""
        var count = 0
        for var i = 0; i < self.refString.characters.count; i = i + 1{
            if self.refString[self.refString.startIndex.advancedBy(i)] == "/"{
                count = count + 1
            }
            if count > 3{
                conference.append(self.refString[self.refString.startIndex.advancedBy(i)])
            }
        }
        
        var backRefString = ""
        var count1 = 0
        for var i=0; i < self.email.characters.count;i=i+1{
            if self.email[self.email.startIndex.advancedBy(i)] == "."{
                count1 = count1 + 10
            }
            if count1 <= 0{
                backRefString.append(self.email[self.email.startIndex.advancedBy(i)])
            }
        }
        
        let conference1 = String(conference.characters.dropFirst())
        var mesaj = ""
        if self.numarBilete == 0{
            mesaj = "Cosul este gol"
        }
        else {
            mesaj = "Doriti sa cumparti \(self.numarBilete) bilete pentru evenimentul \(conference1) pentru suma de \(self.pretBilet * self.numarBilete) lei?"
        }
        let alertController2 = UIAlertController(title: "Cumparare Bilete", message: mesaj, preferredStyle: .Alert)
        let addAction = UIAlertAction(title: "Cumparare", style: .Default){ (_) in
        
            self.ref.observeSingleEventOfType(.Value, withBlock: {snapshot in
                self.bileteCumparate = snapshot.value.objectForKey("NumarBilete") as! Int
                //self.pretBilet = snapshot.value.objectForKey("PretBilet") as! Int
                self.ref.childByAppendingPath("NumarBilete").setValue(self.bileteCumparate - self.numarBilete)
            })
            self.refAuth.childByAppendingPath(backRefString).childByAppendingPath(conference1).childByAutoId().childByAppendingPath("BileteCumparate").setValue(self.numarBilete)
            let mailComposeViewController = self.configuredMailComposeViewController()
            if MFMailComposeViewController.canSendMail() {
                self.presentViewController(mailComposeViewController, animated: true, completion: nil)
            } else {
                self.showSendMailErrorAlert()
            }
        
        }
        let deleteAction = UIAlertAction(title: "Stergere", style: .Default){ (_) in
            self.numarBilete = 0
        }
        let cancelAction = UIAlertAction(title: "Anulare", style: .Cancel){ (_) in}
        if self.numarBilete == 0{
            alertController2.addAction(cancelAction)
        }
        else {
            alertController2.addAction(cancelAction)
            alertController2.addAction(deleteAction)
            alertController2.addAction(addAction)
        }
        self.presentViewController(alertController2, animated: true, completion: nil)
        

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
