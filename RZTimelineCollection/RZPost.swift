//
//  RZPost.swift
//  RZTimelineCollection
//
//  Created by Rostyslav Kobizsky on 12/22/14.
//  Copyright (c) 2014 Rozdoum. All rights reserved.
//

import UIKit

@objc protocol RZPostData {
    
    /**
    *  @return A string identifier that uniquely identifies the user who sent the post.
    *
    *  @discussion If you need to generate a unique identifier, consider using
    *  `[[NSProcessInfo processInfo] globallyUniqueString]`
    *
    *  @warning You must not return `nil` from this method. This value must be unique.
    */
    var senderId: String { get }
    
    /**
    *  @return The display name for the user who sent the post.
    *
    *  @warning You must not return `nil` from this method.
    */
    var senderDisplayName: String { get }
    
    /**
    *  @return The date that the post was sent.
    *
    *  @warning You must not return `nil` from this method.
    */
    var time: NSDate { get }
    
    /**
    *  This method is used to determine if the post data item contains text or media.
    *  If this method returns `true`, an instance of `RZPostControllerView` will ignore
    *  the `text` method of this protocol when dequeuing a `RZPostControllerViewCell`
    *  and only call the `media` method.
    *
    *  Similarly, if this method returns `false` then the `media` method will be ignored and
    *  and only the `text` method will be called.
    *
    *  @return A boolean value specifying whether or not this is a media post or a text post.
    *  Return `true` if this item is a media post, and `false` if it is a text post.
    */
    var isMediaPost: Bool { get }
    
    /**
    *  @return An integer that can be used as a table address in a hash table structure.
    */
    var hash: Int { get }
    
    /**
    *  @return The body text of the post.
    *
    *  @warning You must not return `nil` from this method.
    */
    var text: String? { get }
    
    /**
    *  @return The media item of the post.
    *
    *  @warning You must not return `nil` from this method.
    */
    var media: RZPostMediaData? { get }
}

class RZPost: NSObject, RZPostData, NSCoding, NSCopying {
   
    /**
    *  @return A string identifier that uniquely identifies the user who sent the post.
    *
    *  @discussion If you need to generate a unique identifier, consider using
    *  `[[NSProcessInfo processInfo] globallyUniqueString]`
    *
    *  @warning You must not return `nil` from this method. This value must be unique.
    */
    var senderId: String
    
    /**
    *  @return The display name for the user who sent the post.
    *
    *  @warning You must not return `nil` from this method.
    */
    var senderDisplayName: String
    
    /**
    *  @return The date that the post was sent.
    *
    *  @warning You must not return `nil` from this method.
    */
    var time: NSDate
    
    /**
    *  This method is used to determine if the post data item contains text or media.
    *  If this method returns `true`, an instance of `RZPostControllerView` will ignore
    *  the `text` method of this protocol when dequeuing a `RZPostControllerViewCell`
    *  and only call the `media` method.
    *
    *  Similarly, if this method returns `false` then the `media` method will be ignored and
    *  and only the `text` method will be called.
    *
    *  @return A boolean value specifying whether or not this is a media post or a text post.
    *  Return `true` if this item is a media post, and `false` if it is a text post.
    */
    var isMediaPost: Bool
    
    /**
    *  @return The body text of the post.
    *
    *  @warning You must not return `nil` from this method.
    */
    var text: String?
    
    /**
    *  @return The media item of the post.
    *
    *  @warning You must not return `nil` from this method.
    */
    var media: RZPostMediaData?

    
    init(senderId: String, senderDisplayName: String, time: NSDate, isMedia: Bool) {
        self.senderId = senderId
        self.senderDisplayName = senderDisplayName
        self.time = time
        self.isMediaPost = isMedia
    }
    
    convenience init(senderId: String, senderDisplayName: String, time: NSDate, media: RZPostMedia) {
        self.init(senderId: senderId, senderDisplayName: senderDisplayName, time: time, isMedia: true)
        self.media = media
    }
    
    convenience init(senderId: String, senderDisplayName: String, time: NSDate, text: String) {
        self.init(senderId: senderId, senderDisplayName: senderDisplayName, time: time, isMedia: false)
        self.text = text
    }
    
    // MARK: NSObject
    
    override func isEqual(object: AnyObject?) -> Bool {
        if self == object as RZPost {
            return true
        }
        
        if let post = object as? RZPost {
            if isMediaPost != post.isMediaPost {
                return false
            }
            
            if let hasEqualContent = isMediaPost ? media?.isEqual(post.media) : text == post.text {
                return senderId == post.senderId && senderDisplayName == senderDisplayName && time.compare(post.time) == NSComparisonResult.OrderedSame && hasEqualContent
            } else {
                return false
            }
        }
        
        return false
    }
    
    /**
    *  @return An integer that can be used as a table address in a hash table structure.
    */
    override var hash: Int {
        get {
            let contentHash = isMediaPost ? media!.hash : text!.hash
            return senderId.hash ^ time.hash ^ contentHash
        }
    }
    
    override var description: String {
        get {
            return "<RZPost: senderId=\(senderId), senderDisplayName=\(senderDisplayName), isMediaMessage=\(isMediaPost), text=\(text), media=\(media)"
        }
    }
    
    // MARK: NSCoding
    
    required init(coder aDecoder: NSCoder) {
        self.senderId = aDecoder.decodeObjectForKey("senderId") as String
        self.senderDisplayName = aDecoder.decodeObjectForKey("senderDisplayName") as String
        self.time = aDecoder.decodeObjectForKey("time") as NSDate
        self.isMediaPost = aDecoder.decodeBoolForKey("isMediaPost")
        self.text = aDecoder.decodeObjectForKey("text") as? String
        self.media = aDecoder.decodeObjectForKey("media") as? RZPostMedia
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(senderId, forKey: "senderId")
        aCoder.encodeObject(senderDisplayName, forKey: "senderId")
        aCoder.encodeObject(time, forKey: "time")
        aCoder.encodeBool(isMediaPost, forKey: "isMediaPost")
        aCoder.encodeObject(text, forKey: "text")
        
        if media != nil {
            if media!.conformsToProtocol(NSCoding) {
                aCoder.encodeObject(media, forKey: "media")
            }
        }
    }
    
    // MARK: NSCopying
    
    func copyWithZone(zone: NSZone) -> AnyObject {
        let copy =  RZPost.allocWithZone(zone)
        copy.senderId = senderId
        copy.senderDisplayName = senderDisplayName
        copy.time = time
        copy.isMediaPost = isMediaPost
        copy.text = text
        copy.media = media
        return copy
    }
}
