//
//  TransitionAnimator.swift
//  ezbuy
//
//  Created by Rocke on 16/4/19.
//  Copyright © 2016年 com.ezbuy. All rights reserved.
//

import UIKit

public struct TransitioningComponent {
    
    public let view: UIView
    public let viewController: UIViewController
    public let initialFrame: CGRect
    public let finalFrame: CGRect
    
    public func setViewFromStart() {
        view.frame = initialFrame
    }
    
    public func setViewToEnd() {
        view.frame = finalFrame
    }
    
    public var reversed: TransitioningComponent {
        return TransitioningComponent(view: self.view, viewController: self.viewController, initialFrame: self.finalFrame, finalFrame: self.initialFrame)
    }
}

public typealias TransitionInfo = (container: UIView, fromComponent: TransitioningComponent?, toComponent: TransitioningComponent?)
public typealias TransitionHandler = (TransitionInfo) -> Void


extension AbstractTransitionAnimator: NSCopying {

    public func copy(with zone: NSZone? = nil) -> Any {
        let reval = type(of: self).init(duration: self.duration)
        
        reval.initialHandler = self.initialHandler
        reval.transitingHandler = self.transitingHandler
        reval.completionHandler = self.completionHandler
        
        return reval
    }
    
    public var reversed: AbstractTransitionAnimator {
        
        guard let copy = self.copy() as? AbstractTransitionAnimator else {
            fatalError("Copy must be instance of AbstractTransitionAnimator")
        }
        
        if let transitingHandler = self.transitingHandler {
            copy.initialHandler = { container, from, to in
                transitingHandler((container: container, fromComponent: to?.reversed, toComponent: from?.reversed))
            }
        } else {
            copy.initialHandler = nil
        }
        
        if let initialHandler = self.initialHandler {
            copy.transitingHandler = { container, from, to in
                initialHandler((container: container, fromComponent: to?.reversed, toComponent: from?.reversed))
            }
        } else {
            copy.transitingHandler = nil
        }
        
        return copy
    }
}

open class AbstractTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    public required init(duration: TimeInterval = 0.3) {
        self.duration = duration
        super.init()
    }
    
    public let duration: TimeInterval
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.duration
    }
    
    static let defaultInitialHanlder: TransitionHandler = { _, from, to in
        to?.setViewFromStart()
    }
    
    static let defaultTransitingnHandler: TransitionHandler = { _, from, to in
        to?.setViewToEnd()
    }
    
    fileprivate var initialHandler: TransitionHandler? = BasicTransitionAnimator.defaultInitialHanlder
    
    fileprivate var transitingHandler: TransitionHandler? = BasicTransitionAnimator.defaultTransitingnHandler
    
    fileprivate var completionHandler: TransitionHandler? = BasicTransitionAnimator.defaultTransitingnHandler
    
    public func initial(_ handler: TransitionHandler?) -> Self {
        self.initialHandler = handler
        return self
    }
    
    public func transit(_ handler: TransitionHandler?) -> Self {
        self.transitingHandler = handler
        return self
    }
    
    public func end(_ handler: TransitionHandler?) -> Self {
        self.completionHandler = handler
        return self
    }
    
    func makeTransitionInfo(with transitionContext: UIViewControllerContextTransitioning) -> TransitionInfo {
    
        let containerView = transitionContext.containerView
        
        let from = TransitioningComponent(context: transitionContext, forFromVC: true)
        let to = TransitioningComponent(context: transitionContext, forFromVC: false)
        
        if let toView = to?.view, toView.superview != containerView {
            containerView.addSubview(toView)
        }
        
        self.initialHandler?(container: containerView, fromComponent: from, toComponent: to)

        return (container: containerView, fromComponent: from, toComponent: to)
    }

    open func animating(with info: TransitionInfo, animation: @escaping () -> Void, completion: @escaping (Bool) -> Void) {
        
        fatalError("Not implemented")
    }
    
   public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let info = self.makeTransitionInfo(with: transitionContext)
        
        self.animating(with: info, animation: {
            
            self.transitingHandler?(info)
        }, completion: { finish in
        
            let wasCancelled = transitionContext.transitionWasCancelled
            
            if wasCancelled && info.toComponent?.view == info.container {
                info.toComponent?.view.removeFromSuperview()
            }
            
            self.completionHandler?(info)
            
            transitionContext.completeTransition(!wasCancelled)
        })
    }
}

extension TransitioningComponent {

    fileprivate init?(context: UIViewControllerContextTransitioning, forFromVC: Bool) {
        
        let vcKey: UITransitionContextViewControllerKey = forFromVC ?  UITransitionContextViewControllerKey.from : UITransitionContextViewControllerKey.to
        let vKey: UITransitionContextViewKey = forFromVC ? UITransitionContextViewKey.from : UITransitionContextViewKey.to
        
        guard let vc = context.viewController(forKey: vcKey), let view = context.view(forKey: vKey) else { return nil }
        
        self.init(view: view, viewController: vc, initialFrame: context.initialFrame(for: vc), finalFrame: context.finalFrame(for: vc))
    }
}

public class BasicTransitionAnimator: AbstractTransitionAnimator {
    
    public override func copy(with zone: NSZone?) -> Any {
        guard let reval = super.copy(with: zone) as? BasicTransitionAnimator else {
            fatalError("Copy must be instance of BasicTransitionAnimator")
        }
        reval.animationOptions = self.animationOptions
        return reval
    }
    
    fileprivate var animationOptions: UIViewAnimationOptions = [.curveEaseInOut]
    
    public func setAnimationOptions(_ options: UIViewAnimationOptions) -> Self {
        self.animationOptions = options
        return self
    }
    
    public override func animating(with info: TransitionInfo, animation: @escaping () -> Void, completion: @escaping (Bool) -> Void) {
        
        UIView.animate(withDuration: self.duration, delay: 0.0, options: self.animationOptions, animations: animation, completion: completion)
    }
}

public class KeyFramesTransitionAnimator: BasicTransitionAnimator {
    
    public override func copy(with zone: NSZone?) -> Any {
        guard let reval = super.copy(with: zone) as? KeyFramesTransitionAnimator else {
            fatalError("Copy must be instance of KeyFramesTransitionAnimator")
        }
        reval.keyFramesAnimationOptions = self.keyFramesAnimationOptions
        return reval
    }
    
    fileprivate var keyFramesAnimationOptions: UIViewKeyframeAnimationOptions = [.calculationModeCubic]
    
    public func setKeyFramesAnimationOptions(_ options: UIViewKeyframeAnimationOptions) -> Self {
        self.keyFramesAnimationOptions = options
        return self
    }
    
    public override func animating(with info: TransitionInfo, animation: @escaping () -> Void, completion: @escaping (Bool) -> Void) {
        
        UIView.animateKeyframes(withDuration: self.duration, delay: 0.0, options: self.keyFramesAnimationOptions, animations: animation, completion: completion)
    }
}
