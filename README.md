# TransitionAnimators

## Features
* dissolve Animator
* move Animator
* pan Animator
* scale Animator
* source Animator

## Communication
* If you **found a bug**, open an issue, typically with related pattern.
* If you **have a feature request**, open an issue.
 
## Requirements

- iOS 8.0+
- Xcode 8.3.2+
- Swift 3.0+

## Installation
### CocoaPods
```ruby
pod 'TransitionAnimators'
```

## Usage

### dissolve
```swift
class Dissolve: NSObject, UIViewControllerTransitioningDelegate  {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return TransitionAnimators.makeDissolveAnimator(1)
    }
}
```

##### in viewController:
 
```swift
lazy var transitioning = Dissolve()
 
vc.transitioningDelegate = dissolve

self.present(vc, animated: true, completion: nil)
```

### move
```swift
class Move: NSObject, UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return TransitionAnimators.makeMoveInAnimator(1, from: .left)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TransitionAnimators.makeMoveOutAnimator(1, to: .left)
    }
}
```

##### in viewController:
 
```swift
lazy var transitioning = Move()
 
vc.transitioningDelegate = move

self.present(vc, animated: true, completion: nil)
```

##### Other animated transitions are similar to the code
