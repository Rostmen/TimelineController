//
//  RZPostCollectionView.swift
//  RZTimelineCollection
//
//  Created by Rostyslav Kobizsky on 12/22/14.
//  Copyright (c) 2014 Rozdoum. All rights reserved.
//

import UIKit

class RZPostCollectionView: UICollectionView {

    private weak var _dataSource: RZPostCollectionViewDataSource?
    override var dataSource: UICollectionViewDataSource? {
        set(newValue) {
            self._dataSource = newValue as? RZPostCollectionViewDataSource
            super.dataSource = newValue
        }
        get {
            return self._dataSource
        }
    }
    
    private weak var _delegate: RZPostCollectionViewDelegateFlowLayout?
    override var delegate: UICollectionViewDelegate? {
        set(newValue) {
            self._delegate = newValue as? RZPostCollectionViewDelegateFlowLayout
            super.delegate = newValue
        }
        get {
            return self._delegate
        }
    }
    
    
    private var _collectionViewLayout: RZTimelineCollectionLayout!
    override var collectionViewLayout: UICollectionViewLayout {
        set(newValue) {
            super.collectionViewLayout = (newValue as RZTimelineCollectionLayout)
        }
        
        get {
            return super.collectionViewLayout
        }
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        _collectionViewLayout = (layout as RZTimelineCollectionLayout)
        configureCollectionView()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureCollectionView()
    }
    
    override func awakeFromNib() {
        configureCollectionView()
    }
    
    func configureCollectionView() {
        backgroundColor = UIColor.whiteColor()
        keyboardDismissMode = UIScrollViewKeyboardDismissMode.Interactive
        alwaysBounceVertical = true
        bounces = true
    }

    
    
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
