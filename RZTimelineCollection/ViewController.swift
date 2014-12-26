//
//  ViewController.swift
//  RZTimelineCollection
//
//  Created by Rostyslav Kobizsky on 12/23/14.
//  Copyright (c) 2014 Rozdoum. All rights reserved.
//

import UIKit

class ViewController: RZTimelineController {
   

    var dataSource = [RZPost]()
    
    var postBackgroundImage = RZPostImageFactory().postBackgroundImageRight(UIColor.lightGrayColor())
    let postIcon = RZAvatarImageFactory.postIconImage(20)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        senderId = "MySenderID"
        senderDisplayName = "Rozdoum timeline"
        for index in 0...39 {
            let postSenderId = index % 3 == 0 ? senderId : ""
            let post =  RZPost(senderId: randomStringWithLength(10), senderDisplayName: randomStringWithLength(10), time: NSDate(), isMedia: false)
            post.text = randomStringWithLength(Int(arc4random_uniform(100)))
            dataSource.append(post)
            
            
        }
    }
    
    func randomStringWithLength (len : Int) -> NSString {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        var randomString : NSMutableString = NSMutableString(capacity: len)
        
        for (var i=0; i < len; i++){
            var length = UInt32 (letters.length)
            var rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.characterAtIndex(Int(rand)))
        }
        
        return randomString
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as RZPostCollectionViewCell

        cell.textView.textColor = UIColor.blackColor()
        
        return cell
    }
    
    override func collectionView(collectionView: RZPostCollectionView, layout: RZTimelineCollectionLayout, heightForCellTopLabelAtIndexPath idnexPath: NSIndexPath) -> CGFloat {
        return 20
    }
    
    func collectionView(collectionView: RZPostCollectionView, attributedTextForCellTopLabelAtIndexPath indexPath: NSIndexPath) -> NSAttributedString? {
        let post = dataSource[indexPath.item]
        return RZTimestampFormatter().attributedTimestampForDate(post.time)
    }
    
    // MARK: RZCollectionViewDataSource
    
    override func collectionView(collectionView: RZPostCollectionView, postDataForIndexPath indexPath: NSIndexPath) -> RZPostData {
        return dataSource[indexPath.item]
    }
    
    override func collectionView(collectionView: RZPostCollectionView, backgroundImageDataAtIndexPath indexPath: NSIndexPath) -> RZPostBackgroundImageSource? {
        return postBackgroundImage
    }
    
    override func collectionView(collectionView: RZPostCollectionView, avatarImageDataAtIndexPath indexPath: NSIndexPath) -> RZAvatarImageDataSource? {
        return postIcon
    }
    
}
