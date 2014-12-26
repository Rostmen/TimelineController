//
//  RZTimelineCollectionLayout.swift
//  RZTimelineCollection
//
//  Created by Rostyslav Kobizsky on 12/18/14.
//  Copyright (c) 2014 Rozdoum. All rights reserved.
//

import UIKit

let kPostCollectionViewAvatarSizeDefault: CGFloat = 30
let RZCollectionElementKindTimeLine = "CollectionElementKindTimeLine"

enum RZTimelineMode: Int {
    case Left
    case Center
    case Right
}

class RZTimelineCollectionLayout: UICollectionViewFlowLayout {
   
    private var _postsCacheSizes: NSCache!
    private var _postsCacheAttribures: NSCache!
    
    override var collectionView: RZPostCollectionView? {
        get {
           return super.collectionView as? RZPostCollectionView
        }
    }
    
    var postFont: UIFont = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
    var postImageAssetWidth = UIImage.rz_postCompactImage()?.size.width
    var postContainerLeftRigthMargin: CGFloat = 30
    var postTextViewFrameInsets = UIEdgeInsetsMake(0, 0, 0, 6)
    var postTextViewFrameTextContainerInsents = UIEdgeInsetsMake(7, 14, 7, 14)
    var avatarSize = CGSize(width: kPostCollectionViewAvatarSizeDefault, height: kPostCollectionViewAvatarSizeDefault)
    var visibleIndexPaths = NSMutableSet()
    var timelineInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
    var timelineXPosition: CGFloat = 0
    

    var mode = RZTimelineMode.Left
    
    private var _decorationViewsCache: NSCache!
    
    private var _dynamicAnimator: UIDynamicAnimator!
    
    private func configureFlowLayout() {
        scrollDirection = UICollectionViewScrollDirection.Vertical
        sectionInset = UIEdgeInsetsMake(10, 4, 10, 4)
        minimumLineSpacing = 4
        
        _postsCacheSizes = NSCache()
        _postsCacheSizes.name = "RZTimelineCollectionLayout.postsCacheSized"
        _postsCacheSizes.countLimit = 200
        
        _postsCacheAttribures = NSCache()
        _postsCacheAttribures.name = "RZTimelineCollectionLayout.postsCacheAttributes"
        _postsCacheAttribures.countLimit = 50
        
        _decorationViewsCache = NSCache()
        _decorationViewsCache.name = "RZTimelineCollectionLayout.decorationsCache"
        _decorationViewsCache.countLimit = 10
        
        //_dynamicAnimator = UIDynamicAnimator(collectionViewLayout: self)
    }
    
    
    override init() {
        super.init()
        configureFlowLayout()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureFlowLayout()
    }
    
    override func awakeFromNib() {
        configureFlowLayout()
    }
    
    override class func layoutAttributesClass() -> AnyClass {
        return RZPostCollectionViewLayoutAttribures.self
    }
    
    func itemWidth() -> CGFloat {

        return collectionView!.frame.size.width - sectionInset.left - sectionInset.right - timelineInsets.left - timelineInsets.right - timelineXPosition
    }
    
    override func prepareLayout() {
        super.prepareLayout()
        
    }
    
    override func invalidateLayout() {
        super.invalidateLayout()
        _postsCacheSizes.removeAllObjects()
    }
    
    override func finalizeCollectionViewUpdates() {
        for subview in collectionView!.subviews as [UIView] {
            if subview is RZGridline {
                subview.removeFromSuperview()
            }
        }
        collectionView!.reloadData()
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]? {
        var superLayoutAttributesForElementsInRect = super.layoutAttributesForElementsInRect(rect)

        if var attributesInRect = superLayoutAttributesForElementsInRect as? [UICollectionViewLayoutAttributes] {
            let timelineAttributes = layoutAttributesForSupplementaryViewOfKind(RZCollectionElementKindTimeLine, atIndexPath: NSIndexPath(forItem: 0, inSection: 0))
            attributesInRect.append(timelineAttributes)
            for attributesItem in attributesInRect {
                if attributesItem.representedElementCategory == UICollectionElementCategory.Cell {
                    configurePostCellLayoutAttributes(attributesItem as RZPostCollectionViewLayoutAttribures)
                } else {
                    attributesItem.frame = CGRect(x: timelineXPosition + timelineInsets.left - timelineInsets.right, y: collectionView!.contentOffset.y, width: 1, height: collectionView!.frame.size.height)
                    attributesItem.zIndex = 0
                }
            }
            
            return attributesInRect
        }
        
        return superLayoutAttributesForElementsInRect
    }
    
    func configurePostCellLayoutAttributes(layoutAttributes: RZPostCollectionViewLayoutAttribures) {
        let indexPath = layoutAttributes.indexPath
        
        let postSize = cellSizeForItemAtIndexPath(indexPath)
        layoutAttributes.postContainerViewWidth = postSize.width
        layoutAttributes.textViewFrameInsets = postTextViewFrameInsets
        layoutAttributes.textViewTextContainerInsets = postTextViewFrameTextContainerInsents
        layoutAttributes.postFont = postFont
        layoutAttributes.avatarViewSize = avatarSize
        
        layoutAttributes.cellTopLabelHeight = (collectionView?.delegate as RZPostCollectionViewDelegateFlowLayout).collectionView(collectionView!, layout: self , heightForCellTopLabelAtIndexPath: indexPath)
        layoutAttributes.cellBottomLabelHeight = (collectionView?.delegate as RZPostCollectionViewDelegateFlowLayout).collectionView(collectionView!, layout: self , heightForCellBottomLabelAtIndexPath: indexPath)
        layoutAttributes.frame = CGRect(
            x: timelineXPosition + timelineInsets.left - (avatarSize.width / 2) - timelineInsets.right,
            y: CGRectGetMinY(layoutAttributes.frame),
            width: CGRectGetWidth(layoutAttributes.frame),
            height: CGRectGetHeight(layoutAttributes.frame))
        layoutAttributes.zIndex = 100
    }
    

    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes! {
        let customAttributes = super.layoutAttributesForItemAtIndexPath(indexPath) as RZPostCollectionViewLayoutAttribures
        if (customAttributes.representedElementCategory == UICollectionElementCategory.Cell) {
            configurePostCellLayoutAttributes(customAttributes)
        }
        
        return customAttributes
    }
    
    override func layoutAttributesForSupplementaryViewOfKind(elementKind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes! {
        
        if let attributes = _decorationViewsCache.objectForKey(elementKind) as? UICollectionViewLayoutAttributes {
            return attributes
        } else {
            let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: elementKind, withIndexPath: NSIndexPath(forItem: 0, inSection: 0))
            _decorationViewsCache.setObject(attributes, forKey: elementKind)
            return attributes
        }
    }
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {

        return true
    }
    
    func sizeForItemAtIndexPath(indexPath: NSIndexPath) -> CGSize {
        let size = cellSizeForItemAtIndexPath(indexPath)
        let attributes = layoutAttributesForItemAtIndexPath(indexPath) as RZPostCollectionViewLayoutAttribures
        
        var finalHeight = size.height
        finalHeight += attributes.cellTopLabelHeight
        finalHeight += attributes.cellBottomLabelHeight
        
        return CGSize(width: itemWidth(), height: finalHeight)
    }
    
    override func prepareForCollectionViewUpdates(updateItems: [AnyObject]!) {
        super.prepareForCollectionViewUpdates(updateItems)
        
        NSArray(array: updateItems).enumerateObjectsUsingBlock { (updateItemObj, index, stop) -> Void in
            if let updateItem = updateItemObj as? UICollectionViewUpdateItem {
                if updateItem.updateAction == UICollectionUpdateAction.Insert {
                    let collectionViewHeight = CGRectGetHeight(self.collectionView!.bounds)
                    let attributes = RZPostCollectionViewLayoutAttribures(forCellWithIndexPath: updateItem.indexPathAfterUpdate)
                    if attributes.representedElementCategory == UICollectionElementCategory.Cell {
                        self.configurePostCellLayoutAttributes(attributes)
                    }
                    attributes.frame = CGRect(
                        x: self.timelineXPosition + self.timelineInsets.left,
                        y: collectionViewHeight + CGRectGetHeight(attributes.frame),
                        width: CGRectGetWidth(attributes.frame),
                        height: CGRectGetHeight(attributes.frame))
                }
            }
        }
    }
    
    func resetLayout() {
        _postsCacheSizes.removeAllObjects()
        _decorationViewsCache.removeAllObjects()
    }
    
    func cellSizeForItemAtIndexPath(indexPath: NSIndexPath) -> CGSize {
        let post = (collectionView?.dataSource as RZPostCollectionViewDataSource).collectionView(collectionView!, postDataForIndexPath: indexPath)
        if let  cachedSize = _postsCacheSizes.objectForKey(post.hash) as? NSValue {
            return cachedSize.CGSizeValue()
        } else {
            var finalSize = CGSizeZero
            if post.media != nil {
                finalSize = post.media!.mediaViewDisplaySize
            } else {
                //  from the cell xibs, there is a 0 point space between avatar and bubble
                let spaceBetweenAvatarAndBody: CGFloat = 0
                let horizontalContainerInsets = postTextViewFrameTextContainerInsents.left + postTextViewFrameTextContainerInsents.right
                let horizontalFrameInsets = postTextViewFrameInsets.left + postTextViewFrameInsets.right
                let horizontalInsetsTotal = horizontalContainerInsets + horizontalFrameInsets + spaceBetweenAvatarAndBody - timelineXPosition - timelineInsets.left
                let maximumTextWidth = self.itemWidth() - avatarSize.width - postContainerLeftRigthMargin - horizontalInsetsTotal
                
                let stringRect = postFont.rectOfString(post.text!, constrainedToWidth: maximumTextWidth)
                let stringSize = CGRectIntegral(stringRect).size
                
                let verticalContainerInsets = postTextViewFrameTextContainerInsents.top + postTextViewFrameTextContainerInsents.bottom
                let verticalFrameInsets = postTextViewFrameInsets.top + postTextViewFrameInsets.bottom
                
                let verticalInsets = verticalContainerInsets + verticalFrameInsets + 2
                let finalWidth = max(stringSize.width + horizontalInsetsTotal, postImageAssetWidth!)// + 2
                
                finalSize = CGSize(width: finalWidth, height: stringSize.height + verticalInsets)
            }
            
            _postsCacheSizes.setObject(NSValue(CGSize: finalSize), forKey: post.hash)
            return finalSize
        }
    }
    

    
}
