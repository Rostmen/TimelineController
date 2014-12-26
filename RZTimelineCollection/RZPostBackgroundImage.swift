//
//  RZPostBackgroundImage.swift
//  RZTimelineCollection
//
//  Created by Rostyslav Kobizsky on 12/23/14.
//  Copyright (c) 2014 Rozdoum. All rights reserved.
//

import UIKit

@objc protocol RZPostBackgroundImageSource {
    var postBackgroundImage: UIImage { get }
    var postBackgroundHighlightedImage: UIImage { get }
}

class RZPostBackgroundImage: NSObject, RZPostBackgroundImageSource, NSCopying {
    var postBackgroundImage: UIImage
    var postBackgroundHighlightedImage: UIImage
    
    init(image: UIImage, highlightedImage: UIImage) {
        self.postBackgroundImage = image
        self.postBackgroundHighlightedImage = highlightedImage
    }
    
    func copyWithZone(zone: NSZone) -> AnyObject {
        let copy = RZPostBackgroundImage.allocWithZone(zone)
        copy.postBackgroundImage = UIImage(CGImage: postBackgroundImage.CGImage)!
        copy.postBackgroundHighlightedImage = UIImage(CGImage: postBackgroundHighlightedImage.CGImage)!
        return copy
    }
}