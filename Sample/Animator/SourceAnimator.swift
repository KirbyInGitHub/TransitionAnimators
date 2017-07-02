//
//  SourceAnimator.swift
//  TransitionAnimators
//
//  Created by 张鹏 on 2017/7/2.
//  Copyright © 2017年 大白菜. All rights reserved.
//

import Foundation
import UIKit

extension TransitionAnimators {
    
    public static func makeSourceInAnimator(_ duration: TimeInterval, from sourceView: UIView) -> AbstractTransitionAnimator {
        
        return BasicTransitionAnimator(duration: duration).initial { container, from, to in
            
            guard let to = to else { return }
            
            from?.setViewFromStart()
            
            to.view.alpha = 0.2
            
            let frame = sourceView.convert(sourceView.frame, to: UIApplication.shared.keyWindow)
            
            to.view.frame = frame
            
            container.bringSubview(toFront: to.view)
            
            }.transit { container, from, to in
                
                guard let to = to else { return }
                
                to.view.transform = CGAffineTransform.identity
                to.setViewToEnd()
                to.view.alpha = 1.0
                
            }.end { container, from, to in
                
                to?.setViewToEnd()
                to?.view.transform = CGAffineTransform.identity
                to?.view.alpha = 1.0
        }
    }
    
    public static func makeSourceOutAnimator(_ duration: TimeInterval, to targetView: UIView) -> AbstractTransitionAnimator {
        
        return self.makeSourceInAnimator(duration, from: targetView).reversed
    }
    
}
