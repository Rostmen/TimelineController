//
//  RZPostPlaceholderView.swift
//  RZTimelineCollection
//
//  Created by Rostyslav Kobizsky on 12/23/14.
//  Copyright (c) 2014 Rozdoum. All rights reserved.
//

import UIKit

class RZPostPlaceholderView: UIView {

    /**
    *  Returns the activity indicator view for this placeholder view, or `nil` if it does not exist.
    */
    private var _activityIndicatorView: UIActivityIndicatorView?
    var activityIndicatorView: UIActivityIndicatorView? { get { return _activityIndicatorView }}
    /**
    *  Returns the image view for this placeholder view, or `nil` if it does not exist.
    */
    private var _imageView: UIImageView?
    var imageView: UIImageView? { get { return _imageView }}
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.userInteractionEnabled = false
        self.clipsToBounds = true
        self.contentMode = UIViewContentMode.ScaleAspectFill
    }
    
    convenience init(frame: CGRect, backgroundColor: UIColor) {
        self.init(frame: frame)
        self.backgroundColor = backgroundColor
    }
    
    convenience init(frame: CGRect, backgroundColor: UIColor, activityIndicatorView: UIActivityIndicatorView) {
        self.init(frame: frame, backgroundColor: backgroundColor)
        self.addSubview(activityIndicatorView)
        _activityIndicatorView = activityIndicatorView
        _activityIndicatorView?.center = center
        _activityIndicatorView?.startAnimating()
        _imageView = nil
    }
    
    convenience init(activityIndicatorStyle: UIActivityIndicatorViewStyle) {
        let lightGrayColor = UIColor.lightGrayColor()
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
        let frame = CGRect(x: 0, y: 0, width: 200, height: 120)
        spinner.color = lightGrayColor.darkeningColorWithValue(0.4)
        self.init(frame: frame, backgroundColor: lightGrayColor, activityIndicatorView: spinner)
    }
    
    convenience init(frame: CGRect, imageView anImageView: UIImageView, backgroundColor: UIColor) {
        self.init(frame: frame, backgroundColor: backgroundColor)
        self.addSubview(anImageView)
        _imageView = imageView
        _imageView?.center = center
        _activityIndicatorView = nil
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        if _activityIndicatorView != nil {
            _activityIndicatorView?.center = self.center
        }
        
        if _imageView != nil {
            _imageView?.center = self.center
        }
    }
}
