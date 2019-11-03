//
//  DateFormatter.swift
//  QChat
//
//  Created by ÇağkanTaştekin on 2019. 10. 31..
//  Copyright © 2019. ÇağkanTaştekin. All rights reserved.
//

import Foundation
import UIKit
import FirebaseFirestore

// MARK: DateFormatter
private let dateFormat = "yyyyMMddHHmmss"

func dateFormatter() -> DateFormatter {
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = TimeZone(secondsFromGMT: TimeZone.current.secondsFromGMT())
    dateFormatter.dateFormat = dateFormat
    return dateFormatter
}

