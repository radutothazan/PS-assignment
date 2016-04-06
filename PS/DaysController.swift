//
//  DaysController.swift
//  PS
//
//  Created by Radu Tothazan on 03/04/16.
//  Copyright © 2016 radutot. All rights reserved.
//

import UIKit
import Firebase

class DaysController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var tableView: UITableView!
    var ref = Firebase(url: "https://ps-radu.firebaseio.com/conferences")
    var refString = ""
    var texts = ["Day 1"]
    var days = ""
    var daysNr:Int = 0
    let refreshControl: UIRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.texts.removeAll()
        refreshControl.addTarget(self, action: "uiRefreshControlAction", forControlEvents: .ValueChanged)
        self.tableView.addSubview(refreshControl)
        ref = Firebase(url: refString)
        
        // Do any additional setup after loading the view.
    }
    
    
    func uiRefreshControlAction(){
        ref.observeEventType(.Value, withBlock: {
            snapshot in
            self.days = snapshot.value.objectForKey("days") as! String
            self.daysNr = Int.init(self.days)!
        })
        print(self.daysNr)
        if !self.texts.contains("Day \(daysNr)"){
        for var i=1;i<=self.daysNr;i=i+1{
            self.texts += ["Day "+"\(i)"]
            print(self.texts)
        }
        }
        print(self.texts)
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            
            let newRefString = "https://ps-radu.firebaseio.com/conferences/"+"\(texts[indexPath.row])"
            let vc = segue.destinationViewController as! TracksController
            vc.refString = newRefString
            
            vc.title = self.texts[indexPath.row]
            
        }
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
