//
//  TalkController.swift
//  PS
//
//  Created by Radu Tothazan on 05/04/16.
//  Copyright © 2016 radutot. All rights reserved.
//

import UIKit
import Firebase

class TalkController: UIViewController, NSXMLParserDelegate {

    var refString = ""
    var ref = Firebase(url: "https://ps-radu.firebaseio.com/conferences")
    var uploadRef = Firebase(url: "https://ps-radu.firebaseio.com/conferences")
    var backRefString = ""
    let refreshControl: UIRefreshControl = UIRefreshControl()
    var talks = [""]
    var startHour = [""]
    var endHour = [""]
    var presenter = [""]
    var items = [NSDictionary]()
    var newRefString = ""
    var newRef = Firebase(url: "https://ps-radu.firebaseio.com/conferences")
    let OraIncepere = "OraIncepere"
    var email: String!
    
    
    @IBOutlet weak var addOutlet: UIButton!
    @IBOutlet weak var importOutlet: UIButton!
    
    var parser = NSXMLParser()
    var posts = NSMutableArray()
    var elements = NSMutableDictionary()
    var element = NSString()
    var title1 = NSMutableString()
    var oraIncepere = NSMutableString()
    var oraTerminare = NSMutableString()
    var prezentator = NSMutableString()
    
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.talks.removeAll()
        self.startHour.removeAll()
        refreshControl.addTarget(self, action: "uiRefreshControlAction", forControlEvents: .ValueChanged)
        self.tableView.addSubview(refreshControl)
        ref = Firebase(url: refString)
        uploadRef = Firebase(url: refString)
        uiRefreshControlAction()
        if self.email == "admin@admin.ro"{
            self.addOutlet.hidden = false
            self.importOutlet.hidden = false
        }
        else{
            self.addOutlet.hidden = true
            self.importOutlet.hidden = true
        }
        

        // Do any additional setup after loading the view.
    }
    
    func beginParsing()
    {
        posts = []
        parser = NSXMLParser(contentsOfURL:(NSURL(string:"http://ecinstal.ro/ps.xml"))!)!
        parser.delegate = self
        parser.parse()
        
    }
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String])
    {
        element = elementName
        if (elementName as NSString).isEqualToString("talk")
        {
            elements = NSMutableDictionary()
            elements = [:]
            title1 = NSMutableString()
            title1 = ""
            oraIncepere = NSMutableString()
            oraIncepere = ""
            oraTerminare = NSMutableString()
            oraTerminare = ""
            prezentator = NSMutableString()
            prezentator = ""
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
        if (elementName as NSString).isEqualToString("talk") {
            if !title1.isEqual(nil) {
                elements.setObject(title1, forKey: "name")
            }
            if !oraIncepere.isEqual(nil) {
                elements.setObject(oraIncepere, forKey: "oraIncepere")
            }
            if !oraTerminare.isEqual(nil) {
                elements.setObject(oraTerminare, forKey: "oraTerminare")
            }
            if !prezentator.isEqual(nil) {
                elements.setObject(prezentator, forKey: "prezentator")
            }
            
            
            posts.addObject(elements)
            var newref : Firebase!
            for (key, value) in elements {
                print("\(key) -> \(value)")
                if key as! String == "name"
                {
                    var value1 : String = value as! String
                    value1.removeAtIndex(value1.endIndex.predecessor())
                    self.ref.childByAppendingPath(value1).setValue(value1)
                    newref = Firebase(url: self.refString+"/"+(value1))
                    print(self.refString+"/"+(value1))
                    newref.childByAppendingPath("Nume").setValue(value1)
                }
            }
            for (key, value) in elements {
            
                var value1 : String = value as! String
                value1.removeAtIndex(value1.endIndex.predecessor())
                if key as! String == "oraIncepere"
                {
                    newref.childByAppendingPath("OraIncepere").setValue(value1)
                }
                if key as! String == "oraTerminare"
                {
                    newref.childByAppendingPath("OraTerminare").setValue(value1)
                }
                if key as! String == "prezentator"
                {
                    newref.childByAppendingPath("Prezentator").setValue(value1)
                }
            }
            
        }
    }
    func parser(parser: NSXMLParser, foundCharacters string: String)
    {
        if element.isEqualToString("name") {
            title1.appendString(string)
        } else if element.isEqualToString("oraIncepere") {
            oraIncepere.appendString(string)
        }else if element.isEqualToString("oraTerminare") {
            oraTerminare.appendString(string)
        }else if element.isEqualToString("prezentator") {
            prezentator.appendString(string)
        }
    }

    
    
    func uiRefreshControlAction(){
//        ref.observeEventType(.ChildAdded, withBlock:{ snapshot in
//            if !self.talks.contains(snapshot.key)
//            {
//                self.talks += ["\(snapshot.key)"]
//                self.newRefString = self.refString + "/" + snapshot.key
//                self.newRef = Firebase(url: self.newRefString)
//                print(self.newRef.valueForKey("OraIncepere"))
//                self.newRef.observeEventType(.Value, withBlock: {
//                    snap in
//                    //self.startHour += ["\(snap.value.objectForKey(self.OraIncepere))"]
//                })
//            }
//            print(self.startHour)
//        })
        
//        uploadRef.observeEventType(.Value, withBlock: { snapshot in
//            var tempItems = [NSDictionary]()
//            for item in snapshot.children {
//                let child = item as! FDataSnapshot
//                let dict = child.value as! NSDictionary
//                tempItems.append(dict)
//            }
//            self.items = tempItems
//            self.tableView.reloadData()
//        })
        uploadRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            var tempItems = [NSDictionary]()
            for item in snapshot.children {
                let child = item as! FDataSnapshot
                let dict = child.value as! NSDictionary
                tempItems.append(dict)
            }
            self.items = tempItems
            self.tableView.reloadData()
            
        })
        
        
        
        
        print(self.talks)
        self.tableView.reloadData()
        refreshControl.endRefreshing()
        print(newRefString)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        let indexPath1 = indexPath.row-1
        if editingStyle == UITableViewCellEditingStyle.Delete{
            talks.removeAtIndex(indexPath1)
            print(talks[indexPath1])
            let refRemove = Firebase(url: refString+"/\(talks[indexPath1])")
            refRemove.removeValue()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            self.talks.removeAll()
        }
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell4", forIndexPath: indexPath) as! Cell4TableViewCell
        let dict = items[indexPath.row]
        cell.nameLabel.text = dict["Nume"] as? String
        cell.hourStartLabel.text = dict["OraIncepere"] as? String
        cell.durationLabel.text = dict["OraTerminare"] as? String
        cell.presentatorLabel.text = dict["Prezentator"] as? String
        
        return cell
    }

    @IBAction func addAction(sender: AnyObject) {
        
        let alertController = UIAlertController(title: "Adaugare", message: "Talk", preferredStyle: .Alert)
        let addActionAlert = UIAlertAction(title: "Adaugare", style: .Default){ (_) in
            let talkTextField = alertController.textFields![0] as UITextField
            let startHourTextField = alertController.textFields![1] as UITextField
            let endHourTextField = alertController.textFields![2] as UITextField
            let presenterTextField = alertController.textFields![3] as UITextField
            let talkText = talkTextField.text
            let startHourText = startHourTextField.text
            let endHourText = endHourTextField.text
            let presenterText = presenterTextField.text
            if talkText != "" && startHourText != "" && endHourText != "" && presenterText != ""{
                self.ref.childByAppendingPath(talkText).setValue(talkText)
                let newref = Firebase(url: self.refString+"/"+talkText!)
                newref.childByAppendingPath("Nume").setValue(talkText)
                newref.childByAppendingPath("OraIncepere").setValue(startHourText)
                newref.childByAppendingPath("OraTerminare").setValue(endHourText)
                newref.childByAppendingPath("Prezentator").setValue(presenterText)
            }
            
        }
        addActionAlert.enabled = false
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (_) in }
        
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Nume Talk"
            
            NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidChangeNotification, object: textField, queue: NSOperationQueue.mainQueue()) { (notification) in
                addActionAlert.enabled = textField.text != ""
            }
        }
        
        alertController.addTextFieldWithConfigurationHandler{(textField) in
            textField.placeholder = "Ora incepere"
        }
        alertController.addTextFieldWithConfigurationHandler{(textField) in
            textField.placeholder = "Ora terminare"
        }
        alertController.addTextFieldWithConfigurationHandler{(textField) in
            textField.placeholder = "Prezentator"
        }
        
        alertController.addAction(addActionAlert)
        alertController.addAction(cancelAction)
        self.presentViewController(alertController, animated: true,completion: nil)
        
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Back3Segue"
        {
            var count = 0
            let vc = segue.destinationViewController as! TracksController
            backRefString = ""
            for var i=0; i < refString.characters.count;i=i+1{
                if refString[refString.startIndex.advancedBy(i)] == "/"{
                    count = count + 1
                }
                if count < 6{
                    backRefString.append(refString[refString.startIndex.advancedBy(i)])
                }
            }
            vc.refString = backRefString
            vc.email = self.email
            vc.title = ""
        }

        
    }
    
    @IBAction func backAction(sender: AnyObject) {
        self.performSegueWithIdentifier("Back3Segue", sender: self)
    }
    @IBAction func importAction(sender: AnyObject) {
        self.beginParsing()
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
