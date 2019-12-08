//
//  AudioMedia.swift
//  QChat
//
//  Created by ÇağkanTaştekin on 2019. 12. 08..
//  Copyright © 2019. ÇağkanTaştekin. All rights reserved.
//

import Foundation
import IQAudioRecorderController

class AudioViewController{
    var delegate: IQAudioRecorderViewControllerDelegate
    
    init(delegate_ : IQAudioRecorderViewControllerDelegate) {
        delegate = delegate_
    }
    
    func presentAudioRecorder(target: UIViewController) {
        let controller = IQAudioRecorderViewController()
        
        controller.delegate = delegate
        controller.title = "Record"
        controller.maximumRecordDuration = kAUDIOMAXDURATION // 2 min. if change jump defination
        controller.allowCropping = true
        
        target.presentBlurredAudioRecorderViewControllerAnimated(controller)
    }
}
