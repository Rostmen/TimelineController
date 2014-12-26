//
//  RZPostImageFactory.swift
//  RZTimelineCollection
//
//  Created by Rostyslav Kobizsky on 12/23/14.
//  Copyright (c) 2014 Rozdoum. All rights reserved.
//

import UIKit

class RZPostImageFactory: NSObject {
    var capInstes = UIEdgeInsetsZero
    var backgroundImage = UIImage.rz_postCompactImage()!
    
    init(image: UIImage, capInstes: UIEdgeInsets) {
        self.backgroundImage = image
        self.capInstes = capInstes
        super.init()
        
        if UIEdgeInsetsEqualToEdgeInsets(capInstes, UIEdgeInsetsZero) {
           self.capInstes = centerPointEdgeInsetsForImageSize(image.size)
        }
    }
    
    convenience override init() {
        self.init(image: UIImage.rz_postCompactImage()!, capInstes: UIEdgeInsetsZero)
    }
    
    func postBackgroundImageLeft(tintColor: UIColor) -> RZPostBackgroundImage {
        return postBackgroundImage(tintColor, flipped: false)
    }

    func postBackgroundImageRight(tintColor: UIColor) -> RZPostBackgroundImage {
        return postBackgroundImage(tintColor, flipped: true)
    }

    func postBackgroundImage(tintColor: UIColor, flipped: Bool) -> RZPostBackgroundImage {
        var normalImage = backgroundImage.rz_imageMaskedWithColor(tintColor)
        var highlightedImage = backgroundImage.rz_imageMaskedWithColor(tintColor.darkeningColorWithValue(0.12))
        
        if flipped {
            normalImage = normalImage.rz_imageWithOrientation(UIImageOrientation.UpMirrored)
            highlightedImage = highlightedImage.rz_imageWithOrientation(UIImageOrientation.UpMirrored)
        }
        
        normalImage = normalImage.resizableImageWithCapInsets(capInstes, resizingMode: UIImageResizingMode.Stretch)
        highlightedImage = highlightedImage.resizableImageWithCapInsets(capInstes, resizingMode: UIImageResizingMode.Stretch)
        
        return RZPostBackgroundImage(image: normalImage, highlightedImage: highlightedImage)
    }
    
    func centerPointEdgeInsetsForImageSize(imageSize: CGSize) -> UIEdgeInsets {
        let center = CGPoint(x: imageSize.width / 2, y: imageSize.height / 2)
        return UIEdgeInsets(top: center.y + 6, left: center.x, bottom: center.y - 6, right: center.x)
    }
}

class RZPostImageMaskerFactory: NSObject {
    var imageFactory: RZPostImageFactory

    init(imageFactory: RZPostImageFactory) {
        self.imageFactory = imageFactory
    }
    
    override convenience init() {
        self.init(imageFactory: RZPostImageFactory())
    }
    
    class func applyPostBackgroundImageMaskToView(view: UIView, flipped: Bool) {
        let factory = RZPostImageMaskerFactory()
        factory.applyPostBackgroundImageMaskToView(view, flipped: flipped)
    }
    
    func applyPostBackgroundImageMaskToView(view: UIView, flipped: Bool) {
        let backgroundImageData = imageFactory.postBackgroundImage(UIColor.whiteColor(), flipped: flipped)
        self.rz_maskView(view, withImage: backgroundImageData.postBackgroundImage)
    }
    
    private func rz_maskView(view: UIView, withImage image: UIImage) {
        let imageViewMask = UIImageView(image: image)
        imageViewMask.frame = CGRectInset(view.frame, 2, 2)
        
        view.layer.mask = imageViewMask.layer
    }
}
