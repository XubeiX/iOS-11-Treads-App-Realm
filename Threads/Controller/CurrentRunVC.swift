//
//  CurrentRunVC.swift
//  Threads
//
//  Created by Artur Ratajczak on 10/03/2019.
//  Copyright © 2019 Artur Ratajczak. All rights reserved.
//

import UIKit

class CurrentRunVC: LocationVC {

    @IBOutlet weak var swipeBGImageView: UIImageView!
    @IBOutlet weak var sliderImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swipeGesture = UIPanGestureRecognizer( target: self, action: #selector( endRunSwiped( sender: ) ) )
        sliderImageView.addGestureRecognizer( swipeGesture )
        sliderImageView.isUserInteractionEnabled = true
        swipeGesture.delegate = self as? UIGestureRecognizerDelegate
    }
    
    @objc func endRunSwiped( sender: UIPanGestureRecognizer ){
        let minAdjust: CGFloat = 70
        let maxAdjust: CGFloat = 125
        if let sliderView = sender.view {
            if sender.state == .began || sender.state == .changed {
                let translation = sender.translation( in: self.view )
                if sliderView.center.x >= ( swipeBGImageView.center.x - minAdjust ) && sliderView.center.x <= ( swipeBGImageView.center.x + maxAdjust ) {
                    sliderView.center.x = sliderView.center.x + translation.x
                } else if ( sliderView.center.x >= ( swipeBGImageView.center.x + maxAdjust ) ) {
                    sliderView.center.x = swipeBGImageView.center.x + maxAdjust
                    //TODO: end run code here
                    dismiss(animated: true, completion: nil)
                } else {
                    sliderView.center.x = swipeBGImageView.center.x - minAdjust
                }
                sender.setTranslation(CGPoint.zero, in: self.view)
            } else if sender.state == .ended {
                UIView.animate(withDuration: 0.2) {
                    self.sliderImageView.center.x = self.swipeBGImageView.center.x - minAdjust
                }
            }
        }
    }
}
