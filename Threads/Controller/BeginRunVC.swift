//
//  FirstViewController.swift
//  Threads
//
//  Created by Artur Ratajczak on 10/03/2019.
//  Copyright © 2019 Artur Ratajczak. All rights reserved.
//

import UIKit
import MapKit

class BeginRunVC: LocationVC {

    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var lastRunCloseBtn: UIButton!
    @IBOutlet weak var paceLbl: UILabel!
    @IBOutlet weak var distanceLbl: UILabel!
    @IBOutlet weak var durationLbl: UILabel!
    
    @IBOutlet weak var lastRunBGView: UIView!
    @IBOutlet weak var lastRunStack: UIStackView!
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationAuthStatus()
        mapView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        manager?.delegate = self
        manager?.startUpdatingLocation()
        getLastRun()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        manager?.stopUpdatingLocation()
    }
    
    func getLastRun(){
        guard let lastRun = Run.getAllRuns()?.first else {
            toggleLastRunViewShow(isHidden: true)
            return
        }
        paceLbl.text = lastRun.pace.formatTimeDurationToString()
        distanceLbl.text = "\(lastRun.distance.metersToKilometers(places: 3)) km"
        durationLbl.text = lastRun.duration.formatTimeDurationToString()
        toggleLastRunViewShow(isHidden: false)
        
    }
    
    @IBAction func locationCenterBtnWasPressed(_ sender: Any) {
    }
    
    private func toggleLastRunViewShow(isHidden: Bool) {
        lastRunStack.isHidden = isHidden
        lastRunBGView.isHidden = isHidden
        lastRunCloseBtn.isHidden = isHidden
    }
    
    @IBAction func lastRunCloseBtnWasPressed(_ sender: Any) {
        toggleLastRunViewShow(isHidden: true)
    }
}

extension BeginRunVC : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            checkLocationAuthStatus()
            mapView.showsUserLocation = true
            mapView.userTrackingMode = .follow
        }
    }
}
