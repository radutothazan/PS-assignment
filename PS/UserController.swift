//
//  UserController.swift
//  PS
//
//  Created by Radu Tothazan on 03/04/16.
//  Copyright © 2016 radutot. All rights reserved.
//

import UIKit
import Firebase


class UserController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var ref = Firebase(url: "https://ps-radu.firebaseio.com/conferences")
    var texts = [""]
    let refreshControl: UIRefreshControl = UIRefreshControl()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       self.texts.removeAll()
        refreshControl.addTarget(self, action: "uiRefreshControlAction", forControlEvents: .ValueChanged)
        self.tableView.addSubview(refreshControl)
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
            
            vc.title = self.texts[indexPath.row]
            
        }
    }
    
    
    @IBAction func logoutAction(sender: AnyObject) {
        CURRENT_USER.unauth()
        
        NSUserDefaults.standardUserDefaults().setValue(nil, forKey: "uid")
    }

}
