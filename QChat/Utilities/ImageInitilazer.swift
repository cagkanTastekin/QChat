//
//  ImageInitilazer.swift
//  QChat
//
//  Created by ÇağkanTaştekin on 2019. 10. 31..
//  Copyright © 2019. ÇağkanTaştekin. All rights reserved.
//

import Foundation
import UIKit

// MARK: ImageInitilazer
// If user will not select an avatar image, this method will create one. First letters of name and surname
func imageFromInitials(firstName: String?,lastName: String?, withBlock: @escaping(_ image: UIImage) -> Void){
    
    var string: String!
    var size = 36
    
    if firstName != nil && lastName != nil {
        string = String(firstName!.first!).uppercased() + String(lastName!.first!).uppercased()
    } else {
        string = String(firstName!.first!).uppercased()
        size = 72
    }
    
    let lblNameInitialize = UILabel()
    lblNameInitialize.frame.size = CGSize(width: 100, height: 100)
    lblNameInitialize.textColor = UIColor.clrWhite
    lblNameInitialize.font = UIFont(name: lblNameInitialize.font.fontName, size: CGFloat(size))
    lblNameInitialize.text = string
    lblNameInitialize.textAlignment = NSTextAlignment.center
    lblNameInitialize.backgroundColor = UIColor.clrLightGray
    lblNameInitialize.layer.cornerRadius = 25
    
    UIGraphicsBeginImageContext(lblNameInitialize.frame.size)
    lblNameInitialize.layer.render(in: UIGraphicsGetCurrentContext()!)
    
    let img = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    withBlock(img!)

}

func imageFromData(pictureData: String, withBlock: (_ image: UIImage?) -> Void) {
    var image:UIImage?
    let decodedData = NSData(base64Encoded: pictureData, options: NSData.Base64DecodingOptions(rawValue: 0))
    image = UIImage(data: decodedData! as Data)
    withBlock(image)
}
