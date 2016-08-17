//
//  BlueEffectImageViewClass.swift
//  DBDT
//
//  Created by Grandre on 16/1/2.
//  Copyright © 2016年 革码者. All rights reserved.
//

import UIKit

class BlueEffectImageViewClass: UIImageView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentMode = .ScaleAspectFill
        self.clipsToBounds = true
        self.blueEffect()
        
    }
    
    func blueEffect(){
        let blueE = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let blueEV = UIVisualEffectView(effect: blueE)
        blueEV.frame = self.bounds
        self.addSubview(blueEV)
    }

}
