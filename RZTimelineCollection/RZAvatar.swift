//
//  RZAvatarImageDataSource.swift
//  RZTimelineCollection
//
//  Created by Rostyslav Kobizsky on 12/23/14.
//  Copyright (c) 2014 Rozdoum. All rights reserved.
//

import UIKit
import ObjectiveC

@objc protocol RZAvatarImageDataSource {
    /**
    *  @return The avatar image for a regular display state.
    *
    *  @discussion You may return `nil` from this method while the image is being downloaded.
    */
    var avatarImage: UIImage? { get }
    
    /**
    *  @return The avatar image for a highlighted display state.
    *
    *  @discussion You may return `nil` from this method if this does not apply.
    */
    var avatarHighlightedImage: UIImage? { get }
    
    /**
    *  @return A placeholder avatar image to be displayed if avatarImage is not yet available, or `nil`.
    *  For example, if avatarImage needs to be downloaded, this placeholder image
    *  will be used until avatarImage is not `nil`.
    *
    *  @discussion If you do not need support for a placeholder image, that is, your images
    *  are stored locally on the device, then you may simply return the same value as avatarImage here.
    *
    *  @warning You must not return `nil` from this method.
    */
    var avatarPlaceholderImage: UIImage { get }
}

class RZAvatarImage: NSObject, RZAvatarImageDataSource, NSCopying {
    /**
    *  @return The avatar image for a regular display state.
    *
    *  @discussion You may return `nil` from this method while the image is being downloaded.
    */
    var avatarImage: UIImage?
    
    /**
    *  @return The avatar image for a highlighted display state.
    *
    *  @discussion You may return `nil` from this method if this does not apply.
    */
    var avatarHighlightedImage: UIImage?
    
    /**
    *  @return A placeholder avatar image to be displayed if avatarImage is not yet available, or `nil`.
    *  For example, if avatarImage needs to be downloaded, this placeholder image
    *  will be used until avatarImage is not `nil`.
    *
    *  @discussion If you do not need support for a placeholder image, that is, your images
    *  are stored locally on the device, then you may simply return the same value as avatarImage here.
    *
    *  @warning You must not return `nil` from this method.
    */
    var avatarPlaceholderImage: UIImage
    
    init(image: UIImage?, highlightImage: UIImage?, placeholderImage: UIImage) {
        avatarImage = image
        avatarHighlightedImage = highlightImage
        avatarPlaceholderImage = placeholderImage
    }
    
    convenience init(image: UIImage) {
        self.init(image: image, highlightImage: image, placeholderImage: image)
    }
    
    convenience init(placeholder: UIImage) {
        self.init(image: nil, highlightImage: nil, placeholderImage: placeholder)
    }
    
    // MARK: NSCopying
    
    func copyWithZone(zone: NSZone) -> AnyObject {
        let copy = RZAvatarImage.allocWithZone(zone)
        copy.avatarImage = avatarImage
        copy.avatarHighlightedImage = avatarHighlightedImage
        copy.avatarPlaceholderImage = avatarPlaceholderImage
        return copy
    }
}