//
//  RZTimestampFormatter.swift
//  RZTimelineCollection
//
//  Created by Rostyslav Kobizsky on 12/26/14.
//  Copyright (c) 2014 Rozdoum. All rights reserved.
//

import UIKit

class RZTimestampFormatter: NSObject {
    var dateFormatter = NSDateFormatter()
    
    var dateTextAttributes: [NSString: AnyObject]?
    var timeTextAttributes: [NSString: AnyObject]?
    
    init(dateFormatter aDateFormatter: NSDateFormatter) {
        dateFormatter = aDateFormatter
    }
    
    convenience override init() {
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale.currentLocale()
        dateFormatter.doesRelativeDateFormatting = true
        
        self.init(dateFormatter: dateFormatter)
        
        let color = UIColor.lightGrayColor()
        let paragraphStyle = NSParagraphStyle.defaultParagraphStyle().mutableCopy() as NSMutableParagraphStyle
        paragraphStyle.alignment = NSTextAlignment.Center
        
        dateTextAttributes = [
            NSFontAttributeName: UIFont.boldSystemFontOfSize(12),
            NSForegroundColorAttributeName: color,
            NSParagraphStyleAttributeName: paragraphStyle
        ]
        
        timeTextAttributes = [
            NSFontAttributeName: UIFont.systemFontOfSize(12),
            NSForegroundColorAttributeName: color,
            NSParagraphStyleAttributeName: paragraphStyle
        ]
    }
    
    func attributedTimestampForDate(date: NSDate) -> NSAttributedString {
        let relativeDate = relativeDateForDate(date)
        let time = timeForDate(date)
        
        let timestamp = NSMutableAttributedString(string: relativeDate, attributes: dateTextAttributes)
        timestamp.appendAttributedString(NSAttributedString(string: " "))
        timestamp.appendAttributedString(NSAttributedString(string: time, attributes: timeTextAttributes))
        return NSAttributedString(attributedString: timestamp)
    }
    
    func timeForDate(date: NSDate) -> String {
        dateFormatter.dateStyle = NSDateFormatterStyle.NoStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        return dateFormatter.stringFromDate(date)
    }
    
    func relativeDateForDate(date: NSDate) -> String {
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        return dateFormatter.stringFromDate(date)
    }
}
