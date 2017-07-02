//
//  ZoomOutAnimator.swift
//  ezbuy
//
//  Created by 王玎 on 16/4/27.
//  Copyright © 2016年 com.ezbuy. All rights reserved.
//

import Foundation
import UIKit

extension TransitionAnimators {
    /**
     放大效果，适用于present 和 push 动画

     - parameter duration:    动画持续时间
     - parameter sx:          宽度缩放比例，默认1.2
     - parameter sy:          高度缩放比例，默认1.2

     - returns: 实现UIViewControllerAnimatedTransitioning的实例
     */
    public static func makeScaleAndFadeInAnimator(_ duration: TimeInterval = 0.3, sx: CGFloat = 1.2, sy: CGFloat = 1.2) -> AbstractTransitionAnimator {

        return BasicTransitionAnimator(duration: duration).initial { container, from, to in

            guard let to = to else { return }

            from?.setViewFromStart()
            
            to.view.alpha = 0.0
            to.view.transform = CGAffineTransform(scaleX: sx, y: sy)
            
            container.bringSubview(toFront: to.view)

            }.transit { container, from, to in
                
                guard let to = to else { return }
                
                to.view.transform = CGAffineTransform.identity
                to.view.alpha = 1.0

            }.end { container, from, to in
                
                to?.setViewToEnd()
                to?.view.transform = CGAffineTransform.identity
                to?.view.alpha = 1.0
        }
    }
    
    public static func makeScaleAndFadeOutAnimator(_ duration: TimeInterval = 0.3, sx: CGFloat = 1.2, sy: CGFloat = 1.2) -> AbstractTransitionAnimator {
    
        return self.makeScaleAndFadeInAnimator(duration, sx: sx, sy: sy).reversed
    }
    
}
