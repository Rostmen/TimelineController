//
//  RZPostCollectionViewDataSource.swift
//  RZTimelineCollection
//
//  Created by Rostyslav Kobizsky on 12/22/14.
//  Copyright (c) 2014 Rozdoum. All rights reserved.
//

import UIKit

@objc protocol RZPostCollectionViewDelegateFlowLayout: UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: RZPostCollectionView, layout: RZTimelineCollectionLayout, heightForCellTopLabelAtIndexPath idnexPath: NSIndexPath) -> CGFloat
    func collectionView(collectionView: RZPostCollectionView, layout: RZTimelineCollectionLayout, heightForCellBottomLabelAtIndexPath idnexPath: NSIndexPath) -> CGFloat
}

@objc protocol RZPostCollectionViewDataSource: UICollectionViewDataSource {
    
    /**
    *  Asks the data source for the current sender's display name, that is, the current user who is sending post.
    *
    *  @return An initialized string describing the current sender to display in a `RZPostCollectionViewCell`.
    *
    *  @warning You must not return `nil` from this method. This value does not need to be unique.
    */
    var senderDisplayName: String! { get }
    
    /**
    *  Asks the data source for the current sender's unique identifier, that is, the current user who is sending post.
    *
    *  @return An initialized string identifier that uniquely identifies the current sender.
    *
    *  @warning You must not return `nil` from this method. This value must be unique.
    */
    var senderId: String! { get }
    
    /**
    *  Asks the data source for the post data that corresponds to the specified item at indexPath in the collectionView.
    *
    *  @param collectionView The object representing the collection view requesting this information.
    *  @param indexPath      The index path that specifies the location of the item.
    *
    *  @return An initialized object that conforms to the `RZPostData` protocol. You must not return `nil` from this method.
    */
    func collectionView(collectionView: RZPostCollectionView, postDataForIndexPath indexPath: NSIndexPath) -> RZPostData
    
    
    /**
    *  Asks the data source for the post background image data that corresponds to the specified message data item at indexPath in the collectionView.
    *
    *  @param collectionView The object representing the collection view requesting this information.
    *  @param indexPath      The index path that specifies the location of the item.
    *
    *  @return An initialized object that conforms to the `RZPostBackgroundImageSource` protocol. You may return `nil` from this method if you do not
    *  want the specified item to display a message bubble image.
    *
    *  @discussion It is recommended that you utilize `RZPostImageFactory` to return valid `RZPostBackgroundImage` objects.
    *  However, you may provide your own data source object as long as it conforms to the `RZPostBackgroundImageSource` protocol.
    *
    *  @warning Note that providing your own background image data source objects may require additional
    *  configuration of the collectionView layout object, specifically regarding its `postTextViewFrameInsets` and `postTextViewTextContainerInsets`.
    *
    *  @see RZPostImageFactory.
    *  @see RZTimelineCollectionLayout.
    */
    func collectionView(collectionView: RZPostCollectionView, backgroundImageDataAtIndexPath indexPath: NSIndexPath) -> RZPostBackgroundImageSource?

    
    /**
    *  Asks the data source for the avatar image data that corresponds to the specified message data item at indexPath in the collectionView.
    *
    *  @param collectionView The object representing the collection view requesting this information.
    *  @param indexPath      The index path that specifies the location of the item.
    *
    *  @return A initialized object that conforms to the `RZAvatarImageDataSource` protocol. You may return `nil` from this method if you do not want
    *  the specified item to display an avatar.
    *
    *  @discussion It is recommended that you utilize `RZAvatarImageFactory` to return valid `RZAvatarImage` objects.
    *  However, you may provide your own data source object as long as it conforms to the `JSQMessageAvatarImageDataSource` protocol.
    *
    *  @see RZAvatarImageFactory.
    *  @see RZTimelineCollectionLayout.
    */
    optional func collectionView(collectionView: RZPostCollectionView, avatarImageDataAtIndexPath indexPath: NSIndexPath) -> RZAvatarImageDataSource?
    
    /**
    *  Asks the data source for the text to display in the `cellTopLabel` for the specified
    *  message data item at indexPath in the collectionView.
    *
    *  @param collectionView The object representing the collection view requesting this information.
    *  @param indexPath      The index path that specifies the location of the item.
    *
    *  @return A configured attributed string or `nil` if you do not want text displayed for the item at indexPath.
    *  Return an attributed string with `nil` attributes to use the default attributes.
    *
    *  @see RZPostCollectionViewCell.
    */
    optional func collectionView(collectionView: RZPostCollectionView, attributedTextForCellTopLabelAtIndexPath indexPath: NSIndexPath) -> NSAttributedString?
    
    /**
    *  Asks the data source for the text to display in the `cellBottomLabel` for the specified
    *  message data item at indexPath in the collectionView.
    *
    *  @param collectionView The object representing the collection view requesting this information.
    *  @param indexPath      The index path that specifies the location of the item.
    *
    *  @return A configured attributed string or `nil` if you do not want text displayed for the item at indexPath.
    *  Return an attributed string with `nil` attributes to use the default attributes.
    *
    *  @see RZPostCollectionViewCell.
    */
    optional func collectionView(collectionView: RZPostCollectionView, attributedTextForCellBottomLabelAtIndexPath indexPath: NSIndexPath) -> NSAttributedString?
}