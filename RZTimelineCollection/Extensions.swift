//
//  Extensions.swift
//  RZTimelineCollection
//
//  Created by Rostyslav Kobizsky on 12/18/14.
//  Copyright (c) 2014 Rozdoum. All rights reserved.
//

import UIKit

extension UIDevice {
    class func rz_isCurrentDeviceBeforeiOS8() -> Bool {
        let systemVersion = UIDevice.currentDevice().systemVersion as NSString
        return systemVersion.compare("8.0.0", options: NSStringCompareOptions.NumericSearch) == NSComparisonResult.OrderedAscending
    }
}

extension UIView {
    
    func rz_pinSubview(subview: UIView, toEdge attribute: NSLayoutAttribute) {
        self.addConstraint(NSLayoutConstraint(
            item: self,
            attribute: attribute,
            relatedBy: NSLayoutRelation.Equal,
            toItem: subview,
            attribute: attribute,
            multiplier: 1,
            constant: 0))
    }
    
    func rz_pinAllEdgesOfSubview(subview: UIView) {
        self.rz_pinSubview(subview, toEdge: NSLayoutAttribute.Bottom)
        self.rz_pinSubview(subview, toEdge: NSLayoutAttribute.Top)
        self.rz_pinSubview(subview, toEdge: NSLayoutAttribute.Leading)
        self.rz_pinSubview(subview, toEdge: NSLayoutAttribute.Trailing)
    }
}

extension UIFont {
    func rectOfString (string: NSString, constrainedToWidth width: CGFloat) -> CGRect {
        let combinedOptions = NSObject.combine(.UsesLineFragmentOrigin, with: .UsesFontLeading)
        return string.boundingRectWithSize(
            CGSize(width: width, height: CGFloat.max),
            options: combinedOptions,
            attributes: [NSFontAttributeName : self],
            context: nil)
    }
}

extension UIColor {
    func darkeningColorWithValue(value: CGFloat) -> UIColor {
        let totalComponents = CGColorGetNumberOfComponents(CGColor)
        let isGreyscale = totalComponents == 2 ? true : false
        
        let oldComponents = CGColorGetComponents(CGColor)
        var newComponents: [CGFloat] = [0, 0, 0, 0]
        
        if isGreyscale {
            newComponents[0] = oldComponents[0] - value < 0 ? 0 : oldComponents[0] - value
            newComponents[1] = oldComponents[0] - value < 0 ? 0 : oldComponents[0] - value
            newComponents[2] = oldComponents[0] - value < 0 ? 0 : oldComponents[0] - value
            newComponents[3] = oldComponents[1]
        } else {
            newComponents[0] = oldComponents[0] - value < 0 ? 0 : oldComponents[0] - value
            newComponents[1] = oldComponents[1] - value < 0 ? 0 : oldComponents[1] - value
            newComponents[2] = oldComponents[2] - value < 0 ? 0 : oldComponents[2] - value
            newComponents[3] = oldComponents[3]
        }
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let newColor = CGColorCreate(colorSpace, newComponents)

        return UIColor(CGColor: newColor)
    }
}

extension UIImage {
    func rz_imageMaskedWithColor(color: UIColor) -> UIImage {
        let imageRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(imageRect.size, false, self.scale)
        let context = UIGraphicsGetCurrentContext()
        CGContextScaleCTM(context, 1, -1);
        CGContextTranslateCTM(context, 0, -(imageRect.size.height));
        
        CGContextClipToMask(context, imageRect, CGImage);
        CGContextSetFillColorWithColor(context, color.CGColor);
        CGContextFillRect(context, imageRect);
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    class func rz_postImageFromBundleWithName(name: String) -> UIImage? {
        return UIImage(named: "RZPostAssets.bundle/Images/\(name)")
    }
    
    class func rz_postRegularImage() -> UIImage? {
        return UIImage.rz_postImageFromBundleWithName("bubble_regular")
    }
    
    class func rz_postRegularTaillessImage() -> UIImage? {
        return UIImage.rz_postImageFromBundleWithName("bubble_tailless")
    }
    
    class func rz_postRegularStrokedImage() -> UIImage? {
        return UIImage.rz_postImageFromBundleWithName("bubble_stroked")
    }
    
    class func rz_postRegularStrokedTaillessImage() -> UIImage? {
        return UIImage.rz_postImageFromBundleWithName("bubble_stroked_tailless")
    }
    
    class func rz_postCompactImage() -> UIImage? {
        return UIImage.rz_postImageFromBundleWithName("bubble_min")
    }
    
    class func rz_postCompactTaillessImage() -> UIImage? {
        return UIImage.rz_postImageFromBundleWithName("bubble_min_tailless")
    }
    
    class func rz_defaultAccessoryImage() -> UIImage? {
        return UIImage.rz_postImageFromBundleWithName("clip")
    }
    
    class func rz_defaultTypingIndicatorImage() -> UIImage? {
        return UIImage.rz_postImageFromBundleWithName("typing")
    }
    
    class func rz_defaultPlayImage() -> UIImage? {
        return UIImage.rz_postImageFromBundleWithName("play")
    }
    
    func rz_imageWithOrientation(orientation: UIImageOrientation) -> UIImage {
        return UIImage(CGImage: CGImage, scale: scale, orientation: orientation)!
    }
}