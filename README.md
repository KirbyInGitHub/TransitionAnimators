# TransitionAnimators

# Installation
    pod 'TransitionAnimators'

# Usage
```swift
class Dissolve: NSObject, UIViewControllerTransitioningDelegate  {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return TransitionAnimators.makeDissolveAnimator(1)
    }
}
```

  in viewController:
 
 ```swift
lazy var transitioning = Dissolve()
 
vc.transitioningDelegate = dissolve

self.present(vc, animated: true, completion: nil)

```
