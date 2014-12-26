//
//  RZPostCellTextView.swift
//  RZTimelineCollection
//
//  Created by Rostyslav Kobizsky on 12/18/14.
//  Copyright (c) 2014 Rozdoum. All rights reserved.
//

import UIKit
import CoreText

class RZPostCellTextView: UITextView {

    override var selectedRange: NSRange {
        get {
            return super.selectedRange
        }
        set(newValue) {
            super.selectedRange = NSMakeRange(NSNotFound, 0)
        }
    }

    override func awakeFromNib() {
        textColor = UIColor.whiteColor()
        editable = false
        selectable = true
        userInteractionEnabled = true
        dataDetectorTypes = UIDataDetectorTypes.None
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        scrollEnabled = false
        backgroundColor = UIColor.clearColor()
        contentInset = UIEdgeInsetsZero
        scrollIndicatorInsets = UIEdgeInsetsZero
        contentOffset = CGPointZero
        textContainerInset = UIEdgeInsetsZero
        textContainer.lineFragmentPadding = 0
        
        linkTextAttributes = [
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSUnderlineStyleAttributeName: NSNumber(integer: NSUnderlineStyle.StyleSingle.rawValue)
        ]
    }
    
    override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        //  ignore double-tap to prevent copy/define/etc. menu from showing
        if gestureRecognizer is UITapGestureRecognizer {
            if (gestureRecognizer as UITapGestureRecognizer).numberOfTouchesRequired == 2 {
                return false
            }
        }
        return true
    }

}
