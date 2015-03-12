//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Jeff Corpac on 3/11/15.
//  Copyright (c) 2015 Jeff Corpac. All rights reserved.
//

import Foundation

class RecordedAudio:NSObject {
    var filePathURL: NSURL!
    var title: NSString!
    
    init(url:NSURL!, title:NSString!) {
        self.filePathURL = url
        self.title = title
    }
}