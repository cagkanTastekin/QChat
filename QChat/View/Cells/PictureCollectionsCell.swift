//
//  PictureCollectionsCell.swift
//  QChat
//
//  Created by ÇağkanTaştekin on 2019. 12. 12..
//  Copyright © 2019. ÇağkanTaştekin. All rights reserved.
//

// Identifier --> Cell

import UIKit

class PictureCollectionsCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    func generateCell(image: UIImage) {
        self.imageView.image = image
    }
}
