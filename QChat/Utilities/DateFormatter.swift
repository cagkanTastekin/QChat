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

func timeElapsed(date: Date) -> String {
    let seconds = NSDate().timeIntervalSince(date)
    var elapsed: String?
    
    if (seconds < 60) {
        elapsed = "Just Now"
    } else if (seconds < 60 * 60){
        let minutes = Int(seconds / 60)
        var minText = "min"
        if minutes > 1 {
            minText = "mins"
        }
        elapsed = "\(minutes) \(minText)"
    } else if (seconds < 24 * 60 * 60){
        let hours = Int(seconds / (60 * 60))
        var hourText = "hour"
        if hours > 1 {
            hourText = "hours"
        }
        elapsed = "\(hours) \(hourText)"
    } else {
        let currentDateFormatter = dateFormatter()
        currentDateFormatter.dateFormat = "dd/MM/YYYY"
        elapsed = "\(currentDateFormatter.string(from: date))"
    }
    
    return elapsed!
}
