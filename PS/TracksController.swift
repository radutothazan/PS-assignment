//
//  TracksController.swift
//  PS
//
//  Created by Radu Tothazan on 05/04/16.
//  Copyright © 2016 radutot. All rights reserved.
//

import UIKit
import Firebase

class TracksController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    
    @IBOutlet weak var tableView: UITableView!
    var ref = Firebase(url: "https://ps-radu.firebaseio.com/conferences")
    var refString = ""
    var backRefString = ""
    let refreshControl: UIRefreshControl = UIRefreshControl()
    var tracks = [""]
    var email: String!
    
    @IBOutlet weak var addOutlet: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tracks.removeAll()
        refreshControl.addTarget(self, action: "uiRefreshControlAction", forControlEvents: .ValueChanged)
        self.tableView.addSubview(refreshControl)
        ref = Firebase(url: refString)
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
            if !self.tracks.contains(snapshot.key) && snapshot.key != "NumarBilete" && snapshot.key != "PretBilet"
            {
                self.tracks += ["\(snapshot.key)"]
            }
        })
        print(self.tracks)
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        let indexPath1 = indexPath.row-1
        if editingStyle == UITableViewCellEditingStyle.Delete{
            tracks.removeAtIndex(indexPath1)
            print(tracks[indexPath1])
            let refRemove = Firebase(url: refString+"/\(tracks[indexPath1])")
            refRemove.removeValue()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            self.tracks.removeAll()
        }
    }
    
    

    
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tracks.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell3", forIndexPath: indexPath) as! Cell3TableViewCell
        cell.label.text = self.tracks[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("Vizualizare4Segue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Vizualizare4Segue"
        {
            let indexPaths = self.tableView!.indexPathsForSelectedRows!
            let indexPath = indexPaths[0] as NSIndexPath
            
            let newRefString = refString+"/\(tracks[indexPath.row])"
            let vc = segue.destinationViewController as! TalkController
            vc.refString = newRefString
            vc.email = self.email
            vc.title = self.tracks[indexPath.row]
            
        }
        if segue.identifier == "Back2Segue"
        {
            var count = 0
            let vc = segue.destinationViewController as! DaysController
            for var i=0; i < refString.characters.count;i=i+1{
                if refString[refString.startIndex.advancedBy(i)] == "/"{
                    count = count + 1
                }
                if count < 5{
                    backRefString.append(refString[refString.startIndex.advancedBy(i)])
                }
            }
            vc.refString = backRefString
            vc.email = self.email
            vc.title = ""
        }
    }
    
    
    @IBAction func backAction(sender: AnyObject) {
        self.performSegueWithIdentifier("Back2Segue", sender: self)
        
    }

    

    @IBAction func addAction(sender: AnyObject) {
        let alertController = UIAlertController(title: "Adaugare", message: "Sala", preferredStyle: .Alert)
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
            textField.placeholder = "Sala"
            
            NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidChangeNotification, object: textField, queue: NSOperationQueue.mainQueue()) { (notification) in
                addActionAlert.enabled = textField.text != ""
            }
        }
        
        
        alertController.addAction(addActionAlert)
        alertController.addAction(cancelAction)
        self.presentViewController(alertController, animated: true,completion: nil)

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
