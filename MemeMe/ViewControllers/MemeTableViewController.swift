//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Andreas Kremling on 16.06.22.
//

import Foundation
import UIKit

class MemeTableViewController : UITableViewController  {
    
//Outlet
    @IBOutlet var memesTableView: UITableView!
    
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate  = object as! AppDelegate
        return appDelegate.memes
    }
    
    //Reloading the latest memes
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        memesTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the height of the row to 1/6 the height of the window
        let dimension = (view.frame.size.height  / 6)
        memesTableView.rowHeight = dimension
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeCell", for: indexPath) as! MemeTableViewCell
        let meme = self.memes[(indexPath as NSIndexPath).row]
        
        //Assigning meme and titles to cell
        cell.mImage.image = meme.memedImage
        //Having title in two lines
        cell.mName.text = "\(meme.topText) \n \(meme.bottomText)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Setting up the view controller for detailed view on meme
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        
        // Get the meme and navigate to it
        detailController.meme = self.memes[(indexPath as NSIndexPath).row]
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    
}
