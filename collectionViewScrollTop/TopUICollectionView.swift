//
//  顶部UICollectionView.swift
//
//
//  Created by Grandre on 16/7/22.
//  Copyright © 2016年 革码者. All rights reserved.
//

import UIKit

class TopUICollectionView: UICollectionView,UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate {

    var collectionBackgroundIMG:BlueEffectImageViewClass!
    var dataArr = [String]()
    var indicator:UIPageControl!
    var inset:CGFloat!
    var timer2:NSTimer!
    init(frm:CGRect){
        
        super.init(frame: frm, collectionViewLayout: UICollectionViewLayout())
        self.frame = frm
        self.inset = (UIScreen.mainScreen().bounds.width - 150)/2
        self.layer.borderWidth = 5
        self.layer.borderColor = UIColor ( red: 0.6873, green: 0.6336, blue: 0.4753, alpha: 1.0 ).CGColor
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
      
//        自定义layout
        let layout = MYLayout1()
//        下面这句可以统一设置所有的sectionInset。但一般有多个sectionInset的话，是在代理中设置。
//        layout.sectionInset = UIEdgeInsets(top: 10, left: inset, bottom: 10, right: inset)
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 10
        
        
        self.collectionViewLayout = layout
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        self.dataSource = self
        self.delegate = self
//        注册一个cell
        self.registerClass(UICollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "cell")
       

//        初始化backgroundView
        self.backgroundColor = UIColor.clearColor()
        self.collectionBackgroundIMG = BlueEffectImageViewClass(frame: self.bounds)
        self.backgroundView = self.collectionBackgroundIMG
        
        
//        加载indicator
        self.indicator = UIPageControl(frame: CGRectMake(self.frame.width/2-150/2,self.frame.height-30,CGFloat(150),CGFloat(30)))
        self.indicator.tintColor = UIColor ( red: 0.792, green: 0.799, blue: 0.8813, alpha: 1.0 )
        self.indicator.currentPageIndicatorTintColor = UIColor ( red: 0.9373, green: 0.4863, blue: 0.5294, alpha: 1.0 )
        self.indicator.numberOfPages = 5
        self.indicator.currentPage = 1
        self.collectionBackgroundIMG.addSubview(self.indicator)
       
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()

    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
       
        if section == 0{
           return UIEdgeInsets(top: 10, left: inset, bottom: 10, right: inset)
        }
        return UIEdgeInsetsZero
    }
    
    //设置分区个数
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    //设置每个分区元素个数
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return  self.dataArr.count
    }
    
    //可以为某一个cell设置大小
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 150, height: 100)
    }
    //设置元素内容
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        //这里创建cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath)

        for view in cell.contentView.subviews{
            view.removeFromSuperview()
        }
        let imageV = UIImageView(frame: CGRectMake(0, 0, 150, 100))
        imageV.image = UIImage(named: "\(self.dataArr[indexPath.item])")
        imageV.contentMode = .ScaleAspectFill
        
        cell.contentView.addSubview(imageV)
        cell.contentView.bringSubviewToFront(imageV)
        cell.backgroundColor = UIColor.clearColor()
        cell.layer.cornerRadius = 30
        cell.layer.masksToBounds = true
        return cell
    }
    
    //    ---------------
    func collectionView(collectionView: UICollectionView, canMoveItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    func collectionView(collectionView: UICollectionView, moveItemAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        print("----move item")
    }
    
    
    //    -------delegate-------
    //点击元素
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
        print("点击了第\(indexPath.section) 分区 ,第\(indexPath.row) 个元素")
    }
    //    这里不会执行这句
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("scrollViewDidEndDragging")
    }
//    下面这个是手动滑动结束时调用
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        print("scrollViewDidEndDecelerating")
        if self.timer2 != nil{
            print("---self.timer2不为空")
            self.timer2Set()
        }
        
    }
//   下面这个是代码是scroll滚动时调用，因为代码改变contentOffset时使用了animate为true。
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        print("scrollViewDidEndScrollingAnimation")
        if self.timer2 != nil{
            print("---self.timer2不为空")
            self.timer2Set()
        }
    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
        print("-----在 滚动----")
        if self.timer2 != nil{
            print("---关掉定时器")
            self.timer2.invalidate()
        }
       
        let point = CGPointMake(self.contentOffset.x + self.bounds.width/2.0, self.bounds.height/2.0)
        if let index = self.indexPathForItemAtPoint(point){

            self.collectionBackgroundIMG.image = UIImage(named: "\(self.dataArr[index.item])")
            self.indicator.currentPage = index.row
        }
    }
    
    
//    从其他页面切换回来时或者滚动视图时会执行
    func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        print("---didEndDisplayingCell")
    }
    func collectionView(collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, atIndexPath indexPath: NSIndexPath) {
        print("didEndDisplayingSupplementaryView")
    }
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func drawRect(rect: CGRect) {
   
        // Drawing code
    }

    func timer2Set(){
        self.timer2 = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: #selector(self.timer2Act), userInfo: nil, repeats: true)
    }
    func timer2Act() -> Void {
        print("----timer ----")
        if self.indicator.currentPage == self.dataArr.count-1{
            self.setContentOffset(CGPointMake(0, 0), animated: true)

        }else{

            let index = NSIndexPath(forItem: self.indicator.currentPage+1, inSection: 0)
            self.layer.removeAllAnimations()
            self.scrollToItemAtIndexPath(index, atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally, animated: true)
        }


    }



}
