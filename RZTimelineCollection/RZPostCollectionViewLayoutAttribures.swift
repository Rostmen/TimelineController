//
//  RZPostCollectionViewLayoutAttribures.swift
//  RZTimelineCollection
//
//  Created by Rostyslav Kobizsky on 12/18/14.
//  Copyright (c) 2014 Rozdoum. All rights reserved.
//

import UIKit

class RZPostCollectionViewLayoutAttribures: UICollectionViewLayoutAttributes, NSCopying {
    
    /**
    *  The font used to display the body of a text message in a post within a `RZPostCollectionViewCell`.
    *  This value must not be `nil`.
    */
    var postFont: UIFont!
    
    private var _postContainerViewWidth: CGFloat = 210.0
    var postContainerViewWidth: CGFloat {
        set(newValue) {
            assert(newValue > 0, "postContainerViewWidth must be grater then 0")
            self._postContainerViewWidth = ceil(newValue)
        }
        get {
            return self._postContainerViewWidth
        }
    }
    var textViewTextContainerInsets = UIEdgeInsetsZero
    var textViewFrameInsets = UIEdgeInsetsZero
    
    
    private var _avatarViewSize = CGSize(width: 50, height: 50)
    /**
    *  The size of the `avatarImageView` of a `RZPostCollectionViewCell`.
    *  The size values should be greater than or equal to `0.0`.
    *
    *  @see RZPostCollectionViewCell.
    */
    var avatarViewSize: CGSize {
        set(newValue) {
            self._avatarViewSize = self.correctionAvatarSizeFromSize(newValue)
        }
        get {
            return self._avatarViewSize
        }
    }
    
    private var _cellTopLabelHeight: CGFloat = 21.0
    var cellTopLabelHeight: CGFloat {
        set(newValue) {
            assert(newValue > 0, "cellTopLabelHeight must be grater then 0")
            self._cellTopLabelHeight = self.correctionLabelHeigth(newValue)
        }
        get {
            return self._cellTopLabelHeight
        }
    }
    
    private var _cellBottomLabelHeight: CGFloat = 21.0
    var cellBottomLabelHeight: CGFloat {
        set(newValue) {
            assert(newValue > 0, "cellBottomLabelHeight must be grater then 0")
            self._cellBottomLabelHeight = self.correctionLabelHeigth(newValue)
        }
        get {
            return self._cellBottomLabelHeight
        }
    }
    
    override func isEqual(object: AnyObject?) -> Bool {

        
        if let layoutAttributes = object as? RZPostCollectionViewLayoutAttribures {
            
            if (self.representedElementCategory == UICollectionElementCategory.Cell) {
                if
                !layoutAttributes.postFont.isEqual(postFont) ||
                Int(layoutAttributes.postContainerViewWidth) != Int(postContainerViewWidth) ||
                !UIEdgeInsetsEqualToEdgeInsets(layoutAttributes.textViewTextContainerInsets, textViewTextContainerInsets) ||
                !UIEdgeInsetsEqualToEdgeInsets(layoutAttributes.textViewFrameInsets, textViewFrameInsets) ||
                !CGSizeEqualToSize(layoutAttributes.avatarViewSize, avatarViewSize) ||
                Int(layoutAttributes.cellTopLabelHeight) != Int(cellTopLabelHeight) ||
                Int(layoutAttributes.cellBottomLabelHeight) != Int(cellBottomLabelHeight)
                {
                    return false
                }
            }
        } else {
            return false
        }
        
        return super.isEqual(object)
    }
    
    func correctionAvatarSizeFromSize(size: CGSize) -> CGSize {
        let correctionWidth = max(ceil(size.width), 1)
        let correctionHeight = max(ceil(size.height), 1)
        return CGSize(width: correctionWidth, height: correctionHeight)
    }
    
    func correctionLabelHeigth(heigth: CGFloat) -> CGFloat {
        return max(ceil(heigth), 1)
    }
    
    override func copyWithZone(zone: NSZone) -> AnyObject {
        let copy = super.copyWithZone(zone) as RZPostCollectionViewLayoutAttribures
        if copy.representedElementCategory != UICollectionElementCategory.Cell {
            return copy
        }
        
        copy.postFont = postFont
        copy.postContainerViewWidth = postContainerViewWidth
        copy.textViewFrameInsets = textViewFrameInsets
        copy.textViewTextContainerInsets = textViewTextContainerInsets
        copy.avatarViewSize = avatarViewSize
        copy.cellTopLabelHeight = cellTopLabelHeight
        copy.cellBottomLabelHeight = cellBottomLabelHeight
        
        return copy
    }
}
