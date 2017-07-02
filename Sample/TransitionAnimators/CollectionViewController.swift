//
//  CollectionViewController.swift
//  TransitionAnimators
//
//  Created by 张鹏 on 2017/7/2.
//  Copyright © 2017年 大白菜. All rights reserved.
//

import UIKit

class CollectionViewController: UICollectionViewController {
    
    let images: [UIImage] = {
        
        let i1 = UIImage(named: "1")
        
        let images = ["1", "2", "3", "4", "5", "6", "7", "1", "5", "3"].map { UIImage(named: $0) }
    
        return images.flatMap { $0 }
        
    }()
    
    var transitioning: UIViewControllerTransitioningDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath)
        let imageView = cell.viewWithTag(501) as? UIImageView
        imageView?.image = images[indexPath.row]
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let cell = collectionView.cellForItem(at: indexPath), let imageView = cell.viewWithTag(501) as? UIImageView else { return }

        let transitioning = Source(sourceView: imageView, dismissTargetView: imageView)

        self.transitioning = transitioning

        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SecondViewController") as! SecondViewController
        vc.transitioningDelegate = self.transitioning

        self.present(vc, animated: true, completion: nil)
    }

}
