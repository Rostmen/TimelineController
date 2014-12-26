//
//  RZPostLabel.swift
//  RZTimelineCollection
//
//  Created by Rostyslav Kobizsky on 12/18/14.
//  Copyright (c) 2014 Rozdoum. All rights reserved.
//

import UIKit

class RZPostLabel: UILabel {
    var textInsets: UIEdgeInsets {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        textInsets = UIEdgeInsetsZero
        super.init(frame: frame)
        self.setTranslatesAutoresizingMaskIntoConstraints(false)
    }

    required init(coder aDecoder: NSCoder) {
        textInsets = UIEdgeInsetsZero
        super.init(coder: aDecoder)
        self.setTranslatesAutoresizingMaskIntoConstraints(false)
    }
    
    override func drawTextInRect(rect: CGRect) {
        super.drawTextInRect(CGRect(
            x: CGRectGetMinX(rect) + textInsets.left,
            y: CGRectGetMinY(rect) + textInsets.top,
            width: CGRectGetWidth(rect) - textInsets.right,
            height: CGRectGetHeight(rect) - textInsets.bottom))
    }
}
