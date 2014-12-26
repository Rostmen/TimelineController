//
//  RZPostCollectionViewCell.swift
//  RZTimelineCollection
//
//  Created by Rostyslav Kobizsky on 12/18/14.
//  Copyright (c) 2014 Rozdoum. All rights reserved.
//

import UIKit

@objc protocol RZPostCollectionViewCellDelegate {
    optional func postCollectionViewCellDidTapAvatar(cell: RZPostCollectionViewCell)
    optional func postCollectionViewCellDidTapContent(cell: RZPostCollectionViewCell)
    optional func postCollectionViewCellDidTapCell(cell: RZPostCollectionViewCell, atPoint point: CGPoint)
}

class RZPostCollectionViewCell: UICollectionViewCell {
    
    weak var delegate: RZPostCollectionViewCellDelegate?
    /**
    *  Returns the label that is pinned to the top of the cell.
    *  This label is most commonly used to display message timestamps.
    */
    @IBOutlet weak var cellTopLabel: RZPostLabel!
    
    /**
    *  Returns the label that is pinned to the bottom of the cell.
    *  This label is most commonly used to display message delivery status.
    */
    @IBOutlet weak var cellBottomLabel: RZPostLabel!
    
    /**
    *  Returns the text view of the cell. This text view contains the message body text.
    *
    *  @warning If mediaView returns a non-nil view, then this value will be `nil`.
    */
    @IBOutlet weak var textView: RZPostCellTextView!
    
    /**
    *  Returns the background image view of the cell that is responsible for displaying post background images.
    *
    *  @warning If mediaView returns a non-nil view, then this value will be `nil`.
    */
    @IBOutlet weak var postBackgroundImageView: UIImageView!
    
    /**
    *  Returns the post container view of the cell. This view is the superview of
    *  the cell's textView and messageBubbleImageView.
    *
    *  @discussion You may customize the cell by adding custom views to this container view.
    *  To do so, override `collectionView:cellForItemAtIndexPath:`
    *
    *  @warning You should not try to manipulate any properties of this view, for example adjusting
    *  its frame, nor should you remove this view from the cell or remove any of its subviews.
    *  Doing so could result in unexpected behavior.
    */
    @IBOutlet weak var postContainerView: UIView!
    
    /**
    *  Returns the avatar image view of the cell that is responsible for displaying avatar images.
    */
    @IBOutlet weak var avatarImageView: UIImageView!
    
    /**
    *  Returns the avatar container view of the cell. This view is the superview of
    *  the cell's avatarImageView.
    *
    *  @discussion You may customize the cell by adding custom views to this container view.
    *  To do so, override `collectionView:cellForItemAtIndexPath:`
    *
    *  @warning You should not try to manipulate any properties of this view, for example adjusting
    *  its frame, nor should you remove this view from the cell or remove any of its subviews.
    *  Doing so could result in unexpected behavior.
    */
    @IBOutlet weak var avatarContainerView: UIView!
    
    @IBOutlet private weak var postContainerWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet private weak var textViewTopVerticalSpaceConstraint: NSLayoutConstraint!
    @IBOutlet private weak var textViewBottomVerticalSpaceConstraint: NSLayoutConstraint!
    @IBOutlet private weak var textViewAvatarHorizontalSpaceConstraint: NSLayoutConstraint!
    @IBOutlet private weak var textViewMarginHorizontalSpaceConstraint: NSLayoutConstraint!
    
    @IBOutlet private weak var cellTopLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var cellBottomLabelHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet private weak var avatarContainerViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet private weak var avatarContainerViewHeightConstraint: NSLayoutConstraint!
    

    private var textViewFrameInsets: UIEdgeInsets {
        set(newValue) {
            if UIEdgeInsetsEqualToEdgeInsets(textViewFrameInsets, newValue) {
                rz_updateConstraint(textViewTopVerticalSpaceConstraint, withConstant: newValue.top)
                rz_updateConstraint(textViewBottomVerticalSpaceConstraint, withConstant: newValue.bottom)
                rz_updateConstraint(textViewMarginHorizontalSpaceConstraint, withConstant: newValue.left)
                rz_updateConstraint(textViewAvatarHorizontalSpaceConstraint, withConstant: newValue.right)
            }
        }
        get {
            return UIEdgeInsetsMake(
                textViewTopVerticalSpaceConstraint.constant,
                textViewMarginHorizontalSpaceConstraint.constant,
                textViewBottomVerticalSpaceConstraint.constant,
                textViewAvatarHorizontalSpaceConstraint.constant
            )
        }
    }
    
    private var avatarViewSize: CGSize {
        set(newValue) {
            if (!CGSizeEqualToSize(avatarViewSize, newValue)) {
                rz_updateConstraint(avatarContainerViewWidthConstraint, withConstant: newValue.width)
                rz_updateConstraint(avatarContainerViewHeightConstraint, withConstant: newValue.height)
            }
        }
        get {
            return CGSize(width: avatarContainerViewWidthConstraint.constant, height: avatarContainerViewHeightConstraint.constant)
        }
    }
    
    weak var mediaView: UIView? {
        willSet {
            if (newValue != mediaView && newValue != nil) {
                postBackgroundImageView.removeFromSuperview()
                textView.removeFromSuperview()
                newValue!.setTranslatesAutoresizingMaskIntoConstraints(true)
                newValue!.frame = postContainerView.bounds
                
                postContainerView.addSubview(newValue!)
                postContainerView.rz_pinAllEdgesOfSubview(newValue!)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    for index in 0..<self.postContainerView.subviews.count {
                        if (self.postContainerView.subviews[index] as? UIView) != newValue {
                            (self.postContainerView.subviews[index] as? UIView)?.removeFromSuperview()
                        }
                    }
                })
            }
        }
    }
    
    var tapGestureRecognizer: UITapGestureRecognizer!
    
    override var bounds: CGRect {
        didSet {
            if UIDevice.rz_isCurrentDeviceBeforeiOS8() {
                contentView.frame = bounds
            }
        }
    }
    
    override var selected: Bool {
        didSet {
            postBackgroundImageView.highlighted = selected
        }
    }

    override var highlighted: Bool {
        didSet {
            postBackgroundImageView.highlighted = highlighted
        }
    }

    
    override var backgroundColor: UIColor? {
        didSet {
            cellTopLabel.backgroundColor = backgroundColor
            cellBottomLabel.backgroundColor = backgroundColor
            
            postBackgroundImageView.backgroundColor = backgroundColor
            postContainerView.backgroundColor = backgroundColor
            
            avatarImageView.backgroundColor = backgroundColor
            avatarContainerView.backgroundColor = backgroundColor
        }
    }
    
    // MARK: Methods

    class func nib() -> UINib {
        return UINib(nibName: "RZPostCollectionViewCell", bundle: NSBundle.mainBundle())
    }
    class func cellReuseIdentifier() -> String {
        return "RZPostCollectionViewCell"
    }
    class func mediaCellReuseIdentifier() -> String {
        return cellReuseIdentifier() + "_RZMedia"
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.clearColor()
        
        avatarViewSize = CGSizeZero
        
        cellTopLabelHeightConstraint.constant = 0
        cellBottomLabelHeightConstraint.constant = 0

        cellTopLabel.textAlignment = NSTextAlignment.Center
        cellTopLabel.font = UIFont.boldSystemFontOfSize(12)
        cellTopLabel.textColor = UIColor.lightGrayColor()
        
        cellBottomLabel.font = UIFont.systemFontOfSize(12)
        cellBottomLabel.textColor = UIColor.lightGrayColor()

        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "handleTapGesture:")
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        cellTopLabel.text = nil
        cellBottomLabel.text = nil
        
        textView.dataDetectorTypes = UIDataDetectorTypes.None
        textView.text = nil
        textView.attributedText = nil
        
        avatarImageView.image = nil
        avatarImageView.highlightedImage = nil
    }
    
    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes) {
        super.applyLayoutAttributes(layoutAttributes)
        
        let customAttributes = (layoutAttributes as RZPostCollectionViewLayoutAttribures)
        if (textView.font != customAttributes.postFont) {
            textView.font = customAttributes.postFont
        }
        
        if !UIEdgeInsetsEqualToEdgeInsets(textView.textContainerInset, customAttributes.textViewTextContainerInsets) {
            textView.textContainerInset = customAttributes.textViewTextContainerInsets
        }
        
        textViewFrameInsets = customAttributes.textViewFrameInsets
        
        rz_updateConstraint(postContainerWidthConstraint, withConstant: customAttributes.postContainerViewWidth)
        rz_updateConstraint(cellTopLabelHeightConstraint, withConstant: customAttributes.cellTopLabelHeight)
        rz_updateConstraint(cellBottomLabelHeightConstraint, withConstant: customAttributes.cellBottomLabelHeight)
        
        avatarViewSize = customAttributes.avatarViewSize
    }
    
    func rz_updateConstraint(constraint: NSLayoutConstraint, withConstant constant: CGFloat) {
        if constraint.constant == constant {
            return
        }
        constraint.constant = constant
    }
    
    func handleTapGesture(sender: UITapGestureRecognizer) {
        let location = sender.locationInView(self)
        if CGRectContainsPoint(avatarContainerView.frame, location) {
            delegate?.postCollectionViewCellDidTapAvatar?(self)
        } else if CGRectContainsPoint(postContainerView.frame, location) {
            delegate?.postCollectionViewCellDidTapContent?(self)
        } else {
            delegate?.postCollectionViewCellDidTapCell?(self, atPoint: location)
        }
    }
}
