//
//  FirstViewController.swift
//  Threads
//
//  Created by Artur Ratajczak on 10/03/2019.
//  Copyright © 2019 Artur Ratajczak. All rights reserved.
//

import UIKit
import MapKit
import RealmSwift

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
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mapView.delegate = self
        manager?.delegate = self
        manager?.startUpdatingLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupMapView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        manager?.stopUpdatingLocation()
    }
    
    func setupMapView() {
        if let overlay = addLastRunToMap() {
            clearMapOverlays()
            mapView.addOverlay(overlay)
            toggleLastRunViewShow(isHidden: false)
        } else {
            centerMapOnUserLocation()
            toggleLastRunViewShow(isHidden: true)
        }
    }
    
    func clearMapOverlays() {
        if mapView.overlays.count > 0 {
            mapView.removeOverlays(mapView.overlays)
        }
    }
    
    func addLastRunToMap() -> MKPolyline? {
        guard  let lastRun = Run.getAllRuns()?.first else {
            return nil
        }
        paceLbl.text = lastRun.pace.formatTimeDurationToString()
        distanceLbl.text = "\(lastRun.distance.metersToKilometers(places: 3)) km"
        durationLbl.text = lastRun.duration.formatTimeDurationToString()
        
        var coordinate = [CLLocationCoordinate2D]()
        for location in lastRun.locations {
            coordinate.append(CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))
        }
        
        mapView.userTrackingMode = .none
        mapView.setRegion(centerMapOnPreviousRoute(locations: lastRun.locations), animated: true)
        
        return MKPolyline(coordinates: coordinate, count: coordinate.count)
    }
    
    func centerMapOnUserLocation() {
        mapView.userTrackingMode = .follow
        let coordinateRegion = MKCoordinateRegion.init(center: mapView.userLocation.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func centerMapOnPreviousRoute(locations: List<Location>) -> MKCoordinateRegion {
        guard let initialLocation = locations.first else {
            return MKCoordinateRegion()
        }
        
        var minLat = initialLocation.latitude
        var minLng = initialLocation.longitude
        var maxLat = minLat
        var maxLng = minLng
        
        for location in locations {
            minLat = min(minLat, location.latitude)
            minLng = min(minLng, location.longitude)
            maxLat = max(maxLat, location.latitude)
            maxLng = max(maxLng, location.longitude)
        }
        
        
        return MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: ( minLat + maxLat ) / 2, longitude: ( minLng + maxLng) / 2 ),
                                  span: MKCoordinateSpan(latitudeDelta: (maxLat - minLat) * 1.2, longitudeDelta: ( maxLng - minLng) * 1.2))
    }
    
    @IBAction func locationCenterBtnWasPressed(_ sender: Any) {
        centerMapOnUserLocation()
    }
    
    private func toggleLastRunViewShow(isHidden: Bool) {
        lastRunStack.isHidden = isHidden
        lastRunBGView.isHidden = isHidden
        lastRunCloseBtn.isHidden = isHidden
    }
    
    @IBAction func lastRunCloseBtnWasPressed(_ sender: Any) {
        toggleLastRunViewShow(isHidden: true)
        clearMapOverlays()
        centerMapOnUserLocation()
    }
}

extension BeginRunVC : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            checkLocationAuthStatus()
            mapView.showsUserLocation = true
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polyline = overlay as! MKPolyline
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        renderer.lineWidth = 3
        return renderer
    }
}
