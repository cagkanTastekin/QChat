//
//  BackgroundCollectionViewCont.swift
//  QChat
//
//  Created by ÇağkanTaştekin on 2019. 12. 15..
//  Copyright © 2019. ÇağkanTaştekin. All rights reserved.
//

// Storyboard ID & Restoration ID --> BackgroundVC

import UIKit
import ProgressHUD

class BackgroundCollectionViewCont: UICollectionViewController {
    
    var backgrounds: [UIImage] = []
    let userDefaults = UserDefaults.standard
    
    private let imageNamesArray = ["bg0", "bg1", "bg2", "bg3"]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.largeTitleDisplayMode = .never
        
        let resetButton = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(self.resetToDefault))
        self.navigationItem.rightBarButtonItem = resetButton
        setupImageArray()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return backgrounds.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! BackgroundCollectionCell
    
        cell.generateCell(image: backgrounds[indexPath.row])
    
        return cell
    }

    // MARK: UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        userDefaults.set(imageNamesArray[indexPath.row], forKey: kBACKGROUNDIMAGE)
        userDefaults.synchronize()
        ProgressHUD.showSuccess("Set! 👍")
    }
    
    // MARK: IBActions
    @objc func resetToDefault() {
        userDefaults.removeObject(forKey: kBACKGROUNDIMAGE)
        userDefaults.synchronize()
        ProgressHUD.showSuccess("Set! 👍")
    }
    
    // MARK: Helper Functions
    func setupImageArray() {
        for imageName in imageNamesArray {
            let image = UIImage(named: imageName)
            
            if image != nil {
                backgrounds.append(image!)
            }
        }
    }

}
