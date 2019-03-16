//
//  CurrentRunVC.swift
//  Threads
//
//  Created by Artur Ratajczak on 10/03/2019.
//  Copyright © 2019 Artur Ratajczak. All rights reserved.
//

import UIKit
import MapKit

class CurrentRunVC: LocationVC {

    @IBOutlet weak var swipeBGImageView: UIImageView!
    @IBOutlet weak var sliderImageView: UIImageView!
    @IBOutlet weak var durationLbl: UILabel!
    @IBOutlet weak var paceLbl: UILabel!
    @IBOutlet weak var distanceLbl: UILabel!
    @IBOutlet weak var pauseBtn: UIButton!
    
    var startLocation: CLLocation!
    var lastLocation: CLLocation!
    var runDistance = 0.0
    
    var pace = 0
    
    var counter = 0
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swipeGesture = UIPanGestureRecognizer( target: self, action: #selector( endRunSwiped( sender: ) ) )
        sliderImageView.addGestureRecognizer( swipeGesture )
        sliderImageView.isUserInteractionEnabled = true
        swipeGesture.delegate = self as? UIGestureRecognizerDelegate
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        manager?.delegate = self
        manager?.distanceFilter = 10
        startRun();
    }
    
    func startRun(){
        manager?.startUpdatingLocation()
        startTimer()
        pauseBtn.setImage(#imageLiteral(resourceName: "pauseButton"), for: .normal)
    }
    
    func endRun(){
        manager?.stopUpdatingLocation()
        //TODO: add to realm
        Run.addRunToRealm(pace: pace, distance: runDistance, duration: counter)
    }
    
    func pauseRun(){
        startLocation = nil
        lastLocation = nil
        timer.invalidate()
        manager?.stopUpdatingLocation()
        pauseBtn.setImage(#imageLiteral(resourceName: "resumeButton"), for: .normal)
    }
    
    func startTimer(){
        durationLbl.text = counter.formatTimeDurationToString()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector( updateCounter ), userInfo: nil, repeats: true)
    }
    
    @objc func updateCounter(){
        counter += 1
        durationLbl.text = counter.formatTimeDurationToString()
    }
    
    func calculatePace(time secounds: Int, distance: Double ) -> String{
        pace = Int( Double(secounds) / distance )
        return pace.formatTimeDurationToString()
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
                    endRun()
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
    
    @IBAction func pauseBtnWasPressed(_ sender: Any) {
        if timer.isValid {
            pauseRun()
        } else {
            startRun()
        }
    }
    
}

extension CurrentRunVC : CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            checkLocationAuthStatus()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if startLocation == nil {
            startLocation = locations.first
        } else if let location = locations.last {
            runDistance += lastLocation.distance(from: location)
            distanceLbl.text = "\(runDistance.metersToKilometers(places: 3))"
            if counter > 0 && runDistance > 0 {
                paceLbl.text = calculatePace(time: counter, distance: runDistance.metersToKilometers(places: 3))
            }
        }
        lastLocation = locations.last
    }
}
