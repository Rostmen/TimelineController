//
//  RZPostMedia.swift
//  RZTimelineCollection
//
//  Created by Rostyslav Kobizsky on 12/23/14.
//  Copyright (c) 2014 Rozdoum. All rights reserved.
//

import UIKit

@objc protocol RZPostMediaData: NSObjectProtocol {
    /**
    *  @return An initialized `UIView` object that represents the data for this media object.
    *
    *  @discussion You may return `nil` from this method while the media data is being downloaded.
    */
    var mediaView: UIView? { get }
    /**
    *  @return The frame size for the mediaView when displayed in a `RZPostControllerViewCell`.
    *
    *  @discussion You should return an appropriate size value to be set for the mediaView's frame
    *  based on the contents of the view, and the frame and layout of the `RZPostControllerViewCell`
    *  in which mediaView will be displayed.
    *
    *  @warning You must return a size with non-zero, positive width and height values.
    */
    var mediaViewDisplaySize: CGSize { get }
    
    /**
    *  @return A placeholder media view to be displayed if mediaView is not yet available, or `nil`.
    *  For example, if mediaView will be constructed based on media data that must be downloaded,
    *  this placeholder view will be used until mediaView is not `nil`.
    *
    *  @discussion If you do not need support for a placeholder view, then you may simply return the
    *  same value here as mediaView. Otherwise, consider using `RZPostPlaceholderView`.
    *
    *  @warning You must not return `nil` from this method.
    *
    *  @see RZPostPlaceholderView.
    */
    var mediaPlaceholderView: UIView { get }
    
    /**
    *  @return An integer that can be used as a table address in a hash table structure.
    */
    var hash: Int { get }
}

class RZPostMedia: NSObject, RZPostMediaData, NSCopying {
    
    // MARK: RZPostMediaData
    
    /**
    *  @return An initialized `UIView` object that represents the data for this media object.
    *
    *  @discussion You may return `nil` from this method while the media data is being downloaded.
    */
    
    var mediaView: UIView? {
        get {
            assert(false, "Error: required method not implemented in subclass. Need to implement \(__FUNCTION__)")
        }
    }
    
    /**
    *  @return The frame size for the mediaView when displayed in a `RZPostControllerViewCell`.
    *
    *  @discussion You should return an appropriate size value to be set for the mediaView's frame
    *  based on the contents of the view, and the frame and layout of the `RZPostControllerViewCell`
    *  in which mediaView will be displayed.
    *
    *  @warning You must return a size with non-zero, positive width and height values.
    */

    var mediaViewDisplaySize: CGSize {
        get {
            return CGSize(width: 210, height: 150)
        }
    }
    
    /**
    *  @return An integer that can be used as a table address in a hash table structure.
    */
    override var hash: Int {
        get {
            return NSNumber(bool: true).hash
        }
    }
    
    /**
    *  A boolean value indicating whether this media item should apply
    *  an left or right background image mask to its media views.
    *  Specify `true` for an outgoing mask, and `false` for an incoming mask.
    *  The default value is `true`.
    */
    var left: Bool = false
    
    private var _cachedPlaceholderView: UIView?
    var mediaPlaceholderView: UIView {
        get {
            if _cachedPlaceholderView == nil {
                let size = mediaViewDisplaySize
                let view = RZPostPlaceholderView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
                view.frame = CGRect(origin: CGPointZero, size: size)
                RZPostImageMaskerFactory.applyPostBackgroundImageMaskToView(view, flipped: left)
                _cachedPlaceholderView = view
            }
            return _cachedPlaceholderView!
        }
    }
    
    // MARK: NSObject
    
    // MARK: NSCoding
    
    // MARK: NSCopying
    
    func copyWithZone(zone: NSZone) -> AnyObject {
        let copy = RZPostMedia.allocWithZone(zone)
        return copy
    }
}
