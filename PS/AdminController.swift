//
//  AdminController.swift
//  PS
//
//  Created by Radu Tothazan on 03/04/16.
//  Copyright © 2016 radutot. All rights reserved.
//

import UIKit
import Firebase

class AdminController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{

    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var texts = ["hjjh","ghjghj"]
    var ref = Firebase(url: "https://ps-radu.firebaseio.com/conferences")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(animated: Bool) {
        dispatch_async(dispatch_get_main_queue()){
            self.collectionView.reloadData()
        }
        ref.observeEventType(.ChildAdded, withBlock:{ snapshot in
            // print(snapshot.value.objectForKey("conferences"))
            //print("\(snapshot.key)")
            self.texts += ["\(snapshot.key)"]
            print(self.texts)

        })
        super.viewWillAppear(animated);
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    
    @IBAction func logoutAction(sender: AnyObject) {
        CURRENT_USER.unauth()
        
        NSUserDefaults.standardUserDefaults().setValue(nil, forKey: "uid")
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(self.texts)
        return self.texts.count
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! Cell1CollectionViewCell
        cell.textLabel.text = self.texts[indexPath.row]
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("Vizualizare1Segue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Vizualizare1Segue"
        {
            let indexPaths = self.collectionView!.indexPathsForSelectedItems()!
            let indexPath = indexPaths[0] as NSIndexPath
            
            let vc = segue.destinationViewController as! DaysController
            
            vc.title = self.texts[indexPath.row]
            
        }
    }
    
    
    
    
}
