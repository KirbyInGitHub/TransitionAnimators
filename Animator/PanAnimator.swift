//
//  PanAnimator.swift
//  ezbuy
//
//  Created by 王玎 on 16/5/3.
//  Copyright © 2016年 com.ezbuy. All rights reserved.
//

import Foundation
import UIKit

extension UIRectEdge {

    var normalizedOffset: CGVector {
    
        var vector = CGVector(dx: 0.0, dy: 0.0)
        
        if self.contains(UIRectEdge.top) {
            vector.dy -= 1
        }
        if self.contains(UIRectEdge.bottom) {
            vector.dy += 1
        }
        if self.contains(UIRectEdge.left) {
            vector.dx -= 1
        }
        if self.contains(UIRectEdge.right) {
            vector.dx += 1
        }
        return vector
    }
}

prefix func -(edge: UIRectEdge) -> UIRectEdge {

    var reval = UIRectEdge()
    if edge.contains(UIRectEdge.top) {
        reval.insert(UIRectEdge.bottom)
    }
    if edge.contains(UIRectEdge.bottom) {
        reval.insert(UIRectEdge.top)
    }
    if edge.contains(UIRectEdge.left) {
        reval.insert(UIRectEdge.right)
    }
    if edge.contains(UIRectEdge.right) {
        reval.insert(UIRectEdge.left)
    }
    return reval
}

extension CGRect {

    func offsetBy(_ normalized: CGVector) -> CGRect {
    
        return self.offsetBy(dx: self.width * normalized.dx, dy: self.height * normalized.dy)
    }
    
    mutating func offsetInPlace(_ normalized: CGVector) {
        
        self = self.offsetBy(normalized)
    }
}

extension TransitionAnimators {

    public static func makePanInAnimator(_ duration: TimeInterval, from edge: UIRectEdge) -> AbstractTransitionAnimator {
        
        return BasicTransitionAnimator(duration: duration).initial { container, from, to in

            guard let from = from, let to = to else { return }

            let offset = edge.normalizedOffset

            from.setViewFromStart()
            to.view.frame = from.initialFrame.offsetBy(offset)

        }.transit { container, from, to in
                
            guard let from = from, let to = to else { return }
            
            from.view.frame = from.initialFrame.offsetBy((-edge).normalizedOffset)
            to.setViewToEnd()
        }
    }
    
    public static func makePanOutAnimator(_ duration: TimeInterval, from edge: UIRectEdge) -> AbstractTransitionAnimator {
        
        return self.makePanInAnimator(duration, from: edge).reversed
    }
}
