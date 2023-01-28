//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Andreas Kremling on 16.06.22.
//

import Foundation
import UIKit

class MemeDetailViewController : UIViewController {

    //Definition of variable
    var meme: Meme!
    
//Definition of outlet
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.imageView.image = meme.memedImage
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
}
