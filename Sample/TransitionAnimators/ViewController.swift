//
//  ViewController.swift
//  TransitionAnimators
//
//  Created by 张鹏 on 2017/7/2.
//  Copyright © 2017年 大白菜. All rights reserved.
//

import UIKit

enum SegueIdentifier: String {
    case dissolve
    case move
    case pan
    case scale
    
    init?(identifier: String?) {
        guard let identifier = identifier else { return nil }
        self.init(rawValue: identifier)
    }
}

extension SegueIdentifier {
    
    func makeTransitioningDelegate() -> UIViewControllerTransitioningDelegate {
        
        switch self {
        case .dissolve:
            return Dissolve()
        case .move:
            return Move()
        case .pan:
            return Pan()
        case .scale:
            return Scale()
        }
    }
}


class ViewController: UITableViewController {
    
    var transitioning: UIViewControllerTransitioningDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let segueIdentifier = SegueIdentifier(identifier: segue.identifier) else {
            return
        }
        self.transitioning = segueIdentifier.makeTransitioningDelegate()
        let dst = segue.destination
        dst.transitioningDelegate = transitioning
    }
}
