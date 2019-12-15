//
//  PicturesCollectionViewCont.swift
//  QChat
//
//  Created by ÇağkanTaştekin on 2019. 12. 12..
//  Copyright © 2019. ÇağkanTaştekin. All rights reserved.
//

// Storyboard ID & Restoration ID --> MediaVC

import UIKit
import SKPhotoBrowser

class PicturesCollectionViewCont: UICollectionViewController {
    
    var allImages: [UIImage] = []
    var allImageLinks: [String] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "All Pictures"
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
     
        
        if allImageLinks.count > 0 {
            downloadImages()
        }
        
    }

    

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allImages.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PictureCollectionsCell
        
        cell.generateCell(image: allImages[indexPath.row])
    
        return cell
    }
    
    // MARK: UICollectionView Delegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var images = [SKPhoto]()
        let photo = SKPhoto.photoWithImage(allImages[indexPath.row])
        images.append(photo)
        
        let browser = SKPhotoBrowser(photos: images)
        browser.initializePageIndex(indexPath.row)
        SKPhotoBrowserOptions.disableVerticalSwipe = false
        // Here set the photo browser swipe
        present(browser, animated: true, completion: nil)
    }
    
    // MARK: Download Images
    func downloadImages() {
        for imageLink in allImageLinks {
            downloadImage(imageUrl: imageLink) { (image) in
                if image != nil {
                    self.allImages.append(image!)
                    self.collectionView.reloadData()
                }
            }
        }
    }

}
