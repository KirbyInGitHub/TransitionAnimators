//
//  TransitioningDelegate.swift
//  TransitionAnimators
//
//  Created by 张鹏 on 2017/7/2.
//  Copyright © 2017年 大白菜. All rights reserved.
//

import Foundation
import UIKit

class Dissolve: NSObject, UIViewControllerTransitioningDelegate  {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return TransitionAnimators.makeDissolveAnimator(1)
    }
}

class Move: NSObject, UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return TransitionAnimators.makeMoveInAnimator(1, from: .left)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TransitionAnimators.makeMoveOutAnimator(1, to: .left)
    }
}

class Pan: NSObject, UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return TransitionAnimators.makePanInAnimator(1, from: .left)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TransitionAnimators.makePanOutAnimator(1, from: .left)
    }
}

class Scale: NSObject, UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return TransitionAnimators.makeScaleAndFadeInAnimator(1, sx: 1.5, sy: 1.5)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TransitionAnimators.makeScaleAndFadeOutAnimator(1, sx: 1.5, sy: 1.5)
    }
}

class Source: NSObject, UIViewControllerTransitioningDelegate {
    
    let sourceView: UIView
    
    var targetView: UIView?
    
    init(sourceView: UIView, dismissTargetView: UIView? = nil) {
        self.sourceView = sourceView
        self.targetView = dismissTargetView
        super.init()
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return TransitionAnimators.makeSourceInAnimator(0.3, from: sourceView)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        guard let targetView = targetView else {
            return nil
        }
        
        return TransitionAnimators.makeSourceOutAnimator(0.3, to: targetView)
    }
}
