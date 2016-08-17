//
//  ViewController.swift
//  collectionView
//
//  Created by Grandre on 16/6/28.
//  Copyright © 2016年 革码者. All rights reserved.
//

import UIKit
//import QuartzCore
class ViewController: UIViewController{
    
    var colletionView:TopUICollectionView!
    var dataArr = ["1","2","3","4","5"]
    
    override func viewWillAppear(animated: Bool) {
        print("viewWillAppear")
        self.colletionView.dataArr = self.dataArr
        self.colletionView.reloadData()
        self.initFirstBlueBackGround()

    }
    //    控制器没注销的话，切换界面时只在第一次执行
    override func viewDidLayoutSubviews() {
        print("viewDidLayoutSubviews")
        self.colletionView.contentOffset.x = 155
    
    }
//    在viewDidAppear调用的时候开始启动定时器
    override func viewDidAppear(animated: Bool) {
        print("viewdidappear")
        self.colletionView.timer2Set()
    }
    override func viewDidLoad() {
        print("viewdidloal")
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.initTopcollectionView()
    }
    
    override func viewWillDisappear(animated: Bool) {
        print("will disappear")
        if self.colletionView.timer2 != nil{
            self.colletionView.timer2.invalidate()
        }
        
    }
    override func viewDidDisappear(animated: Bool) {
        print("disappear")
    }
    /**
     初始化collectionView
     */
    func initTopcollectionView(){
        self.automaticallyAdjustsScrollViewInsets = false
        self.colletionView = TopUICollectionView(frm: CGRectMake(0, 65, self.view.bounds.width, 180))
        self.view.addSubview(self.colletionView!)
    }
    
    /**
     初始化第一次虚化背景
     */
    func initFirstBlueBackGround() -> Void {
        if self.colletionView.contentOffset.x == 155{
            /// 初始化第一张虚化背景
            self.colletionView.collectionBackgroundIMG.image = UIImage(named: "\(self.dataArr[1])")
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

