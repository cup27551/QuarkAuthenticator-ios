//
//  NSDate+Extension.swift
//  QuarkAuthenticator
//
//  Created by quark on 2019/7/15.
//  Copyright © 2019 lsw. All rights reserved.
//

import Foundation


extension Date {
    func descriptionTimeModel() {
        let formatter = DateFormatter.init()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        print(formatter.string(from: self))
    }
    
    func descriptionTimeModel() -> String {
        let formatter = DateFormatter.init()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: self)
    }
    
    func daysBetweenDate(toDate: Date) -> TimeInterval {
        return NSDate.init().timeIntervalSince1970 - toDate.timeIntervalSince1970
    }
}
