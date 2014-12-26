//
//  RZDecorationViews.swift
//  RZTimelineCollection
//
//  Created by Rostyslav Kobizsky on 12/24/14.
//  Copyright (c) 2014 Rozdoum. All rights reserved.
//

import UIKit

class RZGridline: UICollectionReusableView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.lightGrayColor()
    }
    
    class func elementReuseIndetifier() -> String {
        return "RZGridline"
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
}