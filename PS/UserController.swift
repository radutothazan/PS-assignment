//
//  UserController.swift
//  PS
//
//  Created by Radu Tothazan on 03/04/16.
//  Copyright © 2016 radutot. All rights reserved.
//

import UIKit
import Firebase


class UserController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    var ref = Firebase(url: "https://ps-radu.firebaseio.com/conferences")
    var imageRef = Firebase(url: "https://ps-radu.firebaseio.com/imagini/")
    var bileteeRef = Firebase(url: "https://ps-radu.firebaseio.com/bilete")
    var texts = [""]
    let refreshControl: UIRefreshControl = UIRefreshControl()
    var email: String!
    var items = [NSDictionary]()
    
    @IBOutlet weak var addOutlet: UIButton!
    @IBOutlet weak var welcomeLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var imageOutlet: UIImageView!
    @IBOutlet weak var addImageOutlet: UIButton!
    @IBOutlet weak var reportButton: UIButton!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       self.texts.removeAll()
        refreshControl.addTarget(self, action: "uiRefreshControlAction", forControlEvents: .ValueChanged)
        self.tableView.addSubview(refreshControl)
        uiRefreshControlAction()
        if self.email == "admin@admin.ro"{
            self.addOutlet.hidden = false
            self.nameLbl.text = "admin"
            self.reportButton.hidden = false
        }
        else{
            self.addOutlet.hidden = true
            self.nameLbl.text = self.email
            self.reportButton.hidden = true
        }
        
        // Do any additional setup after loading the view.
    }
    
    
    func uiRefreshControlAction(){
        ref.observeEventType(.ChildAdded, withBlock:{ snapshot in
            // print(snapshot.value.objectForKey("conferences"))
            //print("\(snapshot.key)")
            if !self.texts.contains(snapshot.key)
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.texts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell1", forIndexPath: indexPath) as! Cell1TableViewCell
        cell.label.text = self.texts[indexPath.row]
        return cell
    }
    
    

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("Vizualizare2Segue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Vizualizare2Segue"
        {
            let indexPaths = self.tableView!.indexPathsForSelectedRows!
            let indexPath = indexPaths[0] as NSIndexPath
            
            let newRefString = "https://ps-radu.firebaseio.com/conferences/"+"\(texts[indexPath.row])"
            let vc = segue.destinationViewController as! DaysController
            vc.refString = newRefString
            vc.email = self.email
            vc.title = self.texts[indexPath.row]
            
        }
    }
    
    

    @IBAction func addAction(sender: AnyObject) {
        let alertController = UIAlertController(title: "Adaugare", message: "Conferinta", preferredStyle: .Alert)
        let addActionAlert = UIAlertAction(title: "Adaugare", style: .Default){ (_) in
            let conferintaTextField = alertController.textFields![0] as UITextField
            let nrBileteTextField = alertController.textFields![1] as UITextField
            let pretBiletTextField = alertController.textFields![2] as UITextField
            let conferintaText = conferintaTextField.text
            let nrBileteText = nrBileteTextField.text
            let pretBileteText = pretBiletTextField.text
            if conferintaText != "" && nrBileteText != "" && pretBileteText != ""{
                self.ref.childByAppendingPath(conferintaText).setValue(conferintaText)
                let newref = Firebase(url: "https://ps-radu.firebaseio.com/conferences/"+conferintaText!)
                newref.childByAppendingPath("NumarBilete").setValue(nrBileteText)
                newref.childByAppendingPath("PretBilet").setValue(pretBileteText)
                
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
        
        alertController.addTextFieldWithConfigurationHandler{(textField) in
            textField.placeholder = "Numar Bilete"
        }
        alertController.addTextFieldWithConfigurationHandler{(textField) in
            textField.placeholder = "Pret bilet"
        }

        alertController.addAction(addActionAlert)
        alertController.addAction(cancelAction)
        self.presentViewController(alertController, animated: true,completion: nil)
        
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        let indexPath1 = indexPath.row-1
        if editingStyle == UITableViewCellEditingStyle.Delete{
            texts.removeAtIndex(indexPath1)
            print(texts[indexPath1])
            let refRemove = Firebase(url: "https://ps-radu.firebaseio.com/conferences/"+"\(texts[indexPath1])")
            refRemove.removeValue()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            self.texts.removeAll()
        }
    }
    
    @IBAction func logoutAction(sender: AnyObject) {
        CURRENT_USER.unauth()
        
        NSUserDefaults.standardUserDefaults().setValue(nil, forKey: "uid")
    }
    @IBAction func addImageAction(sender: AnyObject) {
        let myPicker = UIImagePickerController()
        myPicker.delegate = self
        myPicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(myPicker, animated : true, completion: nil)
        
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        imageOutlet.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        imageOutlet.backgroundColor = UIColor.clearColor()
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func reportAction(sender: AnyObject) {
        bileteeRef.observeSingleEventOfType(.Value, withBlock: {snap in
            var tempItems = [NSDictionary]()
            for item in snap.children {
                let child = item as! FDataSnapshot
                let dict = child.value as! NSDictionary
                tempItems.append(dict)
            }
            self.items = tempItems
        })
        
        
    }
    
    

}
