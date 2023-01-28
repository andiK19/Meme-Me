//
//  MemeTableViewCell.swift
//  MemeMe
//  Udacity Nanodegree Project
//  Created by Andreas Kremling on 16.06.22.
//

import UIKit

class MemeTableViewCell: UITableViewCell {

    //Outlets
    @IBOutlet var mImage: UIImageView!
    @IBOutlet var mName: UILabel!
    
    //setting spaces to borders
    override func layoutSubviews() {
        super.layoutSubviews()
        //set the values for top,left,bottom,right margins
                let margins = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        contentView.frame = contentView.frame.inset(by: margins)
    }
}
