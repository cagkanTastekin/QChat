//
//  PhotoMediaItem.swift
//  QChat
//
//  Created by ÇağkanTaştekin on 2019. 11. 13..
//  Copyright © 2019. ÇağkanTaştekin. All rights reserved.
//

import Foundation
import JSQMessagesViewController

class PhotoMediaItem: JSQPhotoMediaItem {
    override func mediaViewDisplaySize() -> CGSize {
        let defaultSize: CGFloat = 256
        var thumbSize: CGSize = CGSize(width: defaultSize, height: defaultSize)
        
        if (self.image != nil && self.image.size.height > 0 && self.image.size.width > 0) {
            let aspect: CGFloat = self.image.size.width / self.image.size.height
            if self.image.size.width > self.image.size.height { // if landscript
                thumbSize = CGSize(width: defaultSize, height: defaultSize / aspect)
            } else {
                thumbSize = CGSize(width: defaultSize * aspect, height: defaultSize)
            }
        }
        return thumbSize
    }
}
