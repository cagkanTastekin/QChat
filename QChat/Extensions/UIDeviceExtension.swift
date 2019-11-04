//
//  UIDeviceExtension.swift
//  QChat
//
//  Created by ÇağkanTaştekin on 2019. 11. 04..
//  Copyright © 2019. ÇağkanTaştekin. All rights reserved.
//

import Foundation
import UIKit
/*
public extension UIDevice {
    
    enum ScreenType: String {
        case iPhone4_4S = "iPhone 4 or iPhone 4S"
        case iPhones_5_5s_5c_SE = "iPhone 5, iPhone 5s, iPhone 5c or iPhone SE"
        case iPhones_6_6s_7_8 = "iPhone 6, iPhone 6S, iPhone 7 or iPhone 8"
        case iPhones_6Plus_6sPlus_7Plus_8Plus = "iPhone 6 Plus, iPhone 6S Plus, iPhone 7 Plus or iPhone 8 Plus"
        case iPhoneXR = "iPhone XR"
        case iPhoneX_iPhoneXS = "iPhone X,iPhoneXS"
        case iPhoneXSMax = "iPhoneXS Max"
        case unknown
    }
    
    static var screenType: ScreenType {
        switch UIScreen.main.nativeBounds.height {
        case 960:
            return .iPhone4_4S
        case 1136:
            return .iPhones_5_5s_5c_SE
        case 1334:
            return .iPhones_6_6s_7_8
        case 1792:
            return .iPhoneXR
        case 1920, 2208:
            return .iPhones_6Plus_6sPlus_7Plus_8Plus
        case 2436:
            return .iPhoneX_iPhoneXS
        case 2688:
            return .iPhoneXSMax
        default:
            return .unknown
        }
    }
    
    static let deviceUUID = UIDevice.current.identifierForVendor?.uuidString
    
    static let osVersion = UIDevice.current.systemVersion
    
    /// This method let you know if current device is iPhone or not
    ///
    /// - returns: True if device is iPhone otherwise False
    static func isPhone() -> Bool {
        
        var phone: Bool = false
        let deviceIdiom: UIUserInterfaceIdiom = UIDevice.current.userInterfaceIdiom
        
        if deviceIdiom == UIUserInterfaceIdiom.phone {
            phone = true
        }
        return phone
    }
    
    /// This method used to know if device is iPad
    ///
    /// - returns: True for iPad, False for other device
    static func isPad() -> Bool {
        
        var pad: Bool = false
        let deviceIdiom: UIUserInterfaceIdiom = UIDevice.current.userInterfaceIdiom
        
        if deviceIdiom == UIUserInterfaceIdiom.pad {
            pad = true
        }
        return pad
    }
    
    /// This method returns if device is iPhone 4s or not
    ///
    /// - returns: True for iPhone 4s, False for others
    static func isDevice4s() -> Bool {
        if UIScreen.main.bounds.width <= 320 && UIScreen.main.bounds.height <= 480 {
            return true
        }
        return false
    }
    
    /// This method returns if device is iPhone 5 or not
    ///
    /// - returns: True for iPhone 5, False for others
    static func isDevice5() -> Bool {
        if UIScreen.main.bounds.width <= 320 && UIScreen.main.bounds.height == 568 {
            return true
        }
        return false
    }
    
    //    var isiPhoneX: Bool {
    //        return UIScreen.main.nativeBounds.height == 2436
    //    }
    
    static func isDeviceX() -> Bool {
        if UIScreen.main.bounds.width == 375 && UIScreen.main.bounds.height == 812 {
            return true
        }
        return false
    }
    
    
    /// This method used to get Width of device
    ///
    /// - returns: Device Width
    static func deviceWidth() -> CGFloat {
        return UIScreen.main.bounds.width
    }
    
    /// This method used to get Height of device
    ///
    /// - returns: Device Height
    static func deviceHeight() -> CGFloat {
        return UIScreen.main.bounds.height
    }
    
    /// This method used to get device language code
    ///
    /// - Returns: deviceLanguageCode
    static func deviceLanguageCode() -> String {
        return Locale.current.languageCode ?? "en"
    }
    
    /// This method used to get device language
    ///
    /// - Returns: deviceLanguage
    static func deviceLanguage() -> String {
        return Locale.current.localizedString(forLanguageCode: deviceLanguageCode()) ?? "English"
    }
    
}
*/
