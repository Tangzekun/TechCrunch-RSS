//
//  ArticleCell.swift
//  FavoriteRSSReader
//
//  Created by TangZekun on 6/22/16.
//  Copyright © 2016 TangZekun. All rights reserved.
//

import UIKit

class ArticleCell: UITableViewCell
{
    

    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var hearButtonPress1: UIButton!



    
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
      
    }

    override func setSelected(selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

     
    }

}
