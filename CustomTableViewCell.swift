//
//  CustomTableViewCell.swift
//  MusicProject
//
//  Created by Shreeya Sharda on 3/23/25.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var label1: UILabel! // This is for the Song name (the album name is covered by a default text box provided by a prototype cell)
  
   // This will hopefully make the images circular instead of rectangles
    override func layoutSubviews() {
        super.layoutSubviews()
        iconImageView.layer.cornerRadius = iconImageView.frame.height / 2
        //iconImageView.clipsToBounds = true
    }

        
    
    
    
    
    
    
}
