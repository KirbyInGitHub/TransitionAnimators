//
//  SlideInAnimator.swift
//  ezbuy
//
//  Created by Rocke on 16/4/26.
//  Copyright © 2016年 com.ezbuy. All rights reserved.
//

import UIKit

extension TransitionAnimators {

    public static func makeMoveInAnimator(_ duration: TimeInterval = 0.3, from edge: UIRectEdge) -> AbstractTransitionAnimator {

        let backgroundView = UIView(frame: CGRect.zero)
        backgroundView.backgroundColor = UIColor.black
        
        return BasicTransitionAnimator(duration: duration).initial { container, from, to in

            guard let from = from, let to = to else { return }
            
            from.setViewFromStart()
            to.view.frame = to.finalFrame.offsetBy(edge.normalizedOffset)
            
            backgroundView.frame = container.frame
            container.addSubview(backgroundView)
            backgroundView.alpha = 0.0
            
            container.bringSubview(toFront: backgroundView)
            container.bringSubview(toFront: to.view)
            
        }.transit { container, from, to in
                
            guard let to = to else { return }
            
            to.setViewToEnd()
            backgroundView.frame = container.frame
            backgroundView.alpha = 0.7
            
        }.end { container, from, to in
            
            to?.setViewToEnd()
            backgroundView.removeFromSuperview()
        }
    }
    
    public static func makeMoveOutAnimator(_ duration: TimeInterval, to edge: UIRectEdge) -> AbstractTransitionAnimator {
        
        return self.makeMoveInAnimator(duration, from: edge).reversed
    }
}
