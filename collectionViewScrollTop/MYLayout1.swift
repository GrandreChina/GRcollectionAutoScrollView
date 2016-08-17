//
//  MYLayout1.swift
//  collectionView
//
//  Created by Grandre on 16/6/29.
//  Copyright © 2016年 革码者. All rights reserved.
//

import UIKit

class MYLayout1: UICollectionViewFlowLayout {
    
    var itemW: CGFloat = 150
    var itemH: CGFloat = 100
  
    override init() {
        super.init()
        
//        设置每一个元素的大小
//        self.itemSize = CGSizeMake(itemW, itemH)
//        设置滚动方向
        self.scrollDirection = .Horizontal
//        设置间距
//        self.minimumLineSpacing = 0.7 * itemW
        

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
 
//        苹果推荐，对一些布局的准备操作放在这里
    override func prepareLayout() {
        
//        设置边距(让第一张图片与最后一张图片出现在最中央)
//        self.sectionInset = UIEdgeInsetsMake(0, inset, 0, inset)
      
    }

    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
    
    /**
     用来计算出rect这个范围内所有cell的UICollectionViewLayoutAttributes，
     并返回。
     */
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        //取出rect范围内所有的UICollectionViewLayoutAttributes，然而
        //我们并不关心这个范围内所有的cell的布局，我们做动画是做给人看的，
        //所以我们只需要取出屏幕上可见的那些cell的rect即可
//        let array = super.layoutAttributesForElementsInRect(rect)
        
        
//        用copy items的方式，才是最正确的方式
        guard let superArray = super.layoutAttributesForElementsInRect(rect) else { return nil}
        
        guard let attributes = NSArray(array: superArray, copyItems: true) as? [UICollectionViewLayoutAttributes] else { return nil }
        //可见矩阵
        let visiableRect = CGRectMake(self.collectionView!.contentOffset.x, self.collectionView!.contentOffset.y, self.collectionView!.frame.width, self.collectionView!.frame.height)
//        如果用可视范围cell的属性数组，返回的数组元素个数不多，滚动起来不那么舒服。
//        let array = super.layoutAttributesForElementsInRect(visiableRect)

        //接下来的计算是为了动画效果
        let maxCenterMargin = self.collectionView!.bounds.width * 0.5 + itemW * 0.5;

        //获得collectionVIew中央的X值(即显示在屏幕中央的X)矢量中心
        let centerX = self.collectionView!.contentOffset.x + self.collectionView!.frame.size.width * 0.5;
        for attributes in attributes {
            //如果不在屏幕上，直接跳过
            if !CGRectIntersectsRect(visiableRect, attributes.frame) {continue}
            let scale = 1 + (0.3 - abs(centerX - attributes.center.x) / maxCenterMargin)
            attributes.transform = CGAffineTransformMakeScale(scale, scale)
        }
    
        return attributes
    }


  
    override func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        //实现这个方法的目的是：当停止滑动，时刻有一张图片是位于屏幕最中央的。
        //proposedContentOffset 是当前rect的offset。
        //获取滑动结束时当前的rect
        let lastRect = CGRectMake(proposedContentOffset.x, proposedContentOffset.y, self.collectionView!.frame.width, self.collectionView!.frame.height)
        //获得当前rect的中央X值(即显示在屏幕中央的X)
        let centerX = proposedContentOffset.x + self.collectionView!.frame.width * 0.5;
        //这个范围内所有的item的属性
        let array = self.layoutAttributesForElementsInRect(lastRect)
        
        //需要移动的距离
        var adjustOffsetX = CGFloat(MAXFLOAT);
        for item in array! {
            if abs(item.center.x - centerX) < abs(adjustOffsetX) {
                adjustOffsetX = item.center.x - centerX;
            }
        }
        
        return CGPointMake(proposedContentOffset.x + adjustOffsetX, proposedContentOffset.y)
    }

    
}
