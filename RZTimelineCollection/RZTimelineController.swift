//
//  ViewController.swift
//  RZTimelineCollection
//
//  Created by Rostyslav Kobizsky on 12/18/14.
//  Copyright (c) 2014 Rozdoum. All rights reserved.
//

import UIKit

class RZTimelineController: UIViewController, RZPostCollectionViewDataSource, RZPostCollectionViewDelegateFlowLayout, RZPostCollectionViewCellDelegate  {

    @IBOutlet weak var collectionView: RZPostCollectionView!
    @IBOutlet weak var toolbar: UIToolbar!

    
    /**
    *  Asks the data source for the current sender's display name, that is, the current user who is sending post.
    *
    *  @return An initialized string describing the current sender to display in a `RZPostCollectionViewCell`.
    *
    *  @warning You must not return `nil` from this method. This value does not need to be unique.
    */
    var senderDisplayName: String!
    
    /**
    *  Asks the data source for the current sender's unique identifier, that is, the current user who is sending post.
    *
    *  @return An initialized string identifier that uniquely identifies the current sender.
    *
    *  @warning You must not return `nil` from this method. This value must be unique.
    */
    var senderId: String!
    
    var cellReuseIdentifier = RZPostCollectionViewCell.cellReuseIdentifier()
    var mediaCellReuseIdentifier = RZPostCollectionViewCell.mediaCellReuseIdentifier()
    
    class func nib() -> UINib {
        return UINib(nibName: "RZTimelineController", bundle: NSBundle.mainBundle())
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        RZTimelineController.nib().instantiateWithOwner(self, options: nil)
        configureCollectionView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        (collectionView.collectionViewLayout as RZTimelineCollectionLayout).mode = .Center
    }

    override func viewWillLayoutSubviews() {
        (collectionView.collectionViewLayout as RZTimelineCollectionLayout).invalidateLayout()
    }
    
    func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.registerNib(RZPostCollectionViewCell.nib(), forCellWithReuseIdentifier: RZPostCollectionViewCell.cellReuseIdentifier())
        collectionView.registerClass(RZGridline.self, forSupplementaryViewOfKind: RZCollectionElementKindTimeLine, withReuseIdentifier: RZGridline.elementReuseIndetifier())
        
        senderId = "RozdoumID"
        senderDisplayName = "Rozdoum ltd"
        updateCollectionViewInsets()
    }
    
    func updateCollectionViewInsets() {
        setCollectionViewInsetsTopValue(topLayoutGuide.length, bottomValue: CGRectGetMaxY(collectionView.frame) - CGRectGetMinY(toolbar.frame))
    }
    
    func setCollectionViewInsetsTopValue(top: CGFloat, bottomValue bottom: CGFloat) {
        let insets = UIEdgeInsets(top: top, left: 0, bottom: bottom, right: 0)
        collectionView.contentInset = insets
        collectionView.scrollIndicatorInsets = insets
    }
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let postObject = (collectionView.dataSource as RZPostCollectionViewDataSource).collectionView((collectionView as RZPostCollectionView), postDataForIndexPath: indexPath)
        let cellIdentifier = postObject.isMediaPost ? mediaCellReuseIdentifier : cellReuseIdentifier

        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as RZPostCollectionViewCell
        cell.delegate = self
        
        if postObject.isMediaPost {
            cell.mediaView = postObject.media?.mediaView != nil ? postObject.media?.mediaView : postObject.media?.mediaPlaceholderView
        } else {
            cell.textView.text = postObject.text
            if let backgroundImageDataSource = (collectionView.dataSource as RZPostCollectionViewDataSource).collectionView((collectionView as RZPostCollectionView), backgroundImageDataAtIndexPath: indexPath) {
                cell.postBackgroundImageView.image = backgroundImageDataSource.postBackgroundImage
                cell.postBackgroundImageView.highlightedImage = backgroundImageDataSource.postBackgroundHighlightedImage
            }
        }
        
        var labelInsets: CGFloat = 15
        
        let avatarSize = (collectionView.collectionViewLayout as RZTimelineCollectionLayout).avatarSize
        let needsAvatar = !CGSizeEqualToSize(avatarSize, CGSizeZero)
        if needsAvatar {
            if let avatarDataSource = (collectionView.dataSource as RZPostCollectionViewDataSource).collectionView!((collectionView as RZPostCollectionView), avatarImageDataAtIndexPath: indexPath) {
                if let avatarImage = avatarDataSource.avatarImage {
                    cell.avatarImageView.image = avatarImage
                    cell.avatarImageView.highlightedImage = avatarDataSource.avatarHighlightedImage
                } else {
                    cell.avatarImageView.image = avatarDataSource.avatarPlaceholderImage
                    cell.avatarImageView.highlightedImage = nil
                }
                labelInsets = avatarSize.width / 2
            }
        }
        
        cell.cellTopLabel.attributedText = (collectionView.dataSource as RZPostCollectionViewDataSource).collectionView?((collectionView as RZPostCollectionView), attributedTextForCellTopLabelAtIndexPath: indexPath)
        cell.cellBottomLabel.attributedText = (collectionView.dataSource as RZPostCollectionViewDataSource).collectionView?((collectionView as RZPostCollectionView), attributedTextForCellBottomLabelAtIndexPath: indexPath)
        
        cell.cellTopLabel.textInsets = UIEdgeInsets(top: 0, left: labelInsets, bottom: 0, right: 0)
        cell.cellBottomLabel.textInsets = UIEdgeInsets(top: 0, left: labelInsets, bottom: 0, right: 0)

        cell.textView.dataDetectorTypes = UIDataDetectorTypes.All
        cell.layer.rasterizationScale = UIScreen.mainScreen().scale
        cell.layer.shouldRasterize = true
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        return collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: RZGridline.elementReuseIndetifier(), forIndexPath: indexPath) as RZGridline
    }
    
    // MARK: RZPostCollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return (collectionViewLayout as RZTimelineCollectionLayout).sizeForItemAtIndexPath(indexPath)
    }
    
    func collectionView(collectionView: RZPostCollectionView, layout: RZTimelineCollectionLayout, heightForCellBottomLabelAtIndexPath idnexPath: NSIndexPath) -> CGFloat {
        return 1
    }
    
    func collectionView(collectionView: RZPostCollectionView, layout: RZTimelineCollectionLayout, heightForCellTopLabelAtIndexPath idnexPath: NSIndexPath) -> CGFloat {
        return 1
    }
    
    // MARK: RZPostCollectionViewDataSource
    
    func collectionView(collectionView: RZPostCollectionView, postDataForIndexPath indexPath: NSIndexPath) -> RZPostData {
        assert(false, "ERROR: required method not implemented: \(__FUNCTION__)")
    }
    
    func collectionView(collectionView: RZPostCollectionView, backgroundImageDataAtIndexPath indexPath: NSIndexPath) -> RZPostBackgroundImageSource? {
        return nil
    }
    
    func collectionView(collectionView: RZPostCollectionView, avatarImageDataAtIndexPath indexPath: NSIndexPath) -> RZAvatarImageDataSource? {
        return nil
    }
}

