//
//  EffectiveClass.swift
//  ColorSynchronization
//
//  Created by iOS123 on 2019/3/15.
//  Copyright © 2019年 iOS123. All rights reserved.
//

import UIKit

class EffectiveClass: NSObject {

    //晃动效果
    class func shade(view:UIView) {
        UIView.animate(withDuration: 0.5, animations: {
            view.transform = CGAffineTransform.init(rotationAngle: 0.2)
        }, completion: { (Bool) in
            UIView.animate(withDuration: 0.5, animations: {
                view.transform = CGAffineTransform.init(rotationAngle: -0.2)
            }, completion: { (Bool) in
                UIView.animate(withDuration: 0.5, animations: {
                    view.transform = CGAffineTransform.init(rotationAngle: 0)
                })
            })
        })
    }
    
    //顺时针旋转效果
    class func rotateLeft(view:UIView) {
        UIView.animate(withDuration: 0.5, animations: {
            view.transform = CGAffineTransform.init(rotationAngle: 180)
        }, completion: { (Bool) in
            UIView.animate(withDuration: 0.5, animations: {
                view.transform = CGAffineTransform.init(rotationAngle: -180)
            }, completion: { (Bool) in
                UIView.animate(withDuration: 0.5, animations: {
                    view.transform = CGAffineTransform.init(rotationAngle: 0)
                })
            })
        })
    }
    
    //旋转放缩效果
    class func rotateAndScale(view:UIView) {
        UIView.animate(withDuration: 0.5, animations: {
            view.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5).concatenating(CGAffineTransform.init(rotationAngle: 0.5))
        }, completion: { (Bool) in
            UIView.animate(withDuration: 0.5, animations: {
            }, completion: { (Bool) in
                UIView.animate(withDuration: 0.5, animations: {
                    view.transform = CGAffineTransform.init(scaleX: 2, y: 2).concatenating(CGAffineTransform.init(rotationAngle: 0))
                })
            })
        })
    }
    
    //翻转效果
    class func reverse(view:UIView){
        UIView.setAnimationTransition(UIView.AnimationTransition.curlUp, for: view, cache: true)
        UIView.setAnimationDuration(0.5)
        
    }
}
