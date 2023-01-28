//
//  MemeCollectionViewController.swift
//  MemeMe
//  Udacity Nanodegree Project
//  Created by Andreas Kremling on 16.06.22.
//

import Foundation
import UIKit

class MemeCollectionViewController : UICollectionViewController {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var memes: [Meme]! {
        //Get memes from array in AppDelegate
        let object = UIApplication.shared.delegate
        let appDelegate  = object as! AppDelegate
        return appDelegate.memes
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        //Width of each cell is 1/3 of the size of the window
        let space:CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / space

        //Size and spacing of layout
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView.reloadData()
    }
    

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Create a cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionViewCell", for: indexPath) as! MemeCollectionViewCell
        // Get the meme
        let meme = self.memes[(indexPath as NSIndexPath).row]
        
        // set image to ImageView
        cell.memeImage?.image = meme.memedImage
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Get the view controller
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        
        detailController.meme = self.memes[(indexPath as NSIndexPath).row]
        
        self.navigationController!.pushViewController(detailController, animated: true)
    }
}
