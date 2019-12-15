//
//  BackgroundCollectionCell.swift
//  QChat
//
//  Created by ÇağkanTaştekin on 2019. 12. 15..
//  Copyright © 2019. ÇağkanTaştekin. All rights reserved.
//

import UIKit

class BackgroundCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    
    func generateCell(image: UIImage) {
        self.imgView.image = image
    }
}
