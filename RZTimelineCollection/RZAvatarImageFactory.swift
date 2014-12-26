//
//  RZAvatarImageFactory.swift
//  RZTimelineCollection
//
//  Created by Rostyslav Kobizsky on 12/26/14.
//  Copyright (c) 2014 Rozdoum. All rights reserved.
//

import UIKit

class RZAvatarImageFactory: NSObject {
    
    class func postIconImage(diameter: Int) -> RZAvatarImage? {
        if let icon = UIImage(named: "RZPostAssets.bundle/Images/post-icon") {
            return avatarImageWithImage(icon, diameter: diameter)
        } else {
            return nil
        }
    }
    
    class func avatarImageWithImage(image: UIImage, diameter: Int) -> RZAvatarImage {
        let avatar = circularAvatarImage(image, diameter: diameter)
        let highlightedAvatar = circularAvatarImage(image, diameter: diameter)
        return RZAvatarImage(image: avatar, highlightImage: highlightedAvatar, placeholderImage: avatar)
    }
    
    
    class func circularAvatarImage(image: UIImage, diameter: Int) -> UIImage {
        return circularImage(image, diameter: diameter, highlightedColor: nil)
    }
    
    class func circularImage(image: UIImage, diameter: Int, highlightedColor: UIColor?) -> UIImage {
        assert(diameter > 0, "'diameter' for circular image should be more the 0")
        let frame = CGRect(x: 0, y: 0, width: diameter, height: diameter)
        var newImage: UIImage
        
        UIGraphicsBeginImageContextWithOptions(frame.size, false, UIScreen.mainScreen().scale)
        
        let context = UIGraphicsGetCurrentContext()
        CGContextSaveGState(context)
        
        let imgPath = UIBezierPath(ovalInRect: frame)
        imgPath.addClip()
        image.drawInRect(frame)
        
        if highlightedColor != nil {
            CGContextSetFillColorWithColor(context, highlightedColor!.CGColor);
            CGContextFillEllipseInRect(context, frame);
        }
        
        newImage = UIGraphicsGetImageFromCurrentImageContext();
        
        CGContextRestoreGState(context);
        
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
