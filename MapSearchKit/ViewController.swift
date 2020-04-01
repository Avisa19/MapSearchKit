//
//  ViewController.swift
//  MapSearchKit
//
//  Created by Avisa Poshtkouhi on 3/31/20.
//  Copyright © 2020 Avisa Poshtkouhi. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    fileprivate var mapView: MKMapView = {
        let map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
    fileprivate let locationManager = CLLocationManager()
    
    fileprivate let segmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Standard", "Satelite", "Hybrid"])
        sc.isUserInteractionEnabled = true
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.selectedSegmentIndex = 0
        return sc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    fileprivate func setupUI() {
        
        view.addSubview(mapView)
        mapView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        mapView.heightAnchor.constraint(equalToConstant: 800).isActive = true
        
        let bg = UIView()
        view.addSubview(bg)
        bg.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.1)
        bg.addSubview(segmentedControl)
        bg.translatesAutoresizingMaskIntoConstraints = false
        bg.topAnchor.constraint(equalTo: mapView.bottomAnchor).isActive = true
        bg.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        bg.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        bg.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        
        segmentedControl.centerXAnchor.constraint(equalTo: bg.centerXAnchor).isActive = true
        segmentedControl.centerYAnchor.constraint(equalTo: bg.centerYAnchor).isActive = true
        segmentedControl.heightAnchor.constraint(equalToConstant: 50).isActive = true
        segmentedControl.widthAnchor.constraint(equalToConstant: 300).isActive = true
        
        locationManager.delegate = self
        mapView.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.startUpdatingLocation()
        mapView.showsUserLocation = true
        
        segmentedControl.addTarget(self, action: #selector(handleSwitch), for: .valueChanged)
    }


    @objc fileprivate func handleSwitch() {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .satellite
        case 2:
            mapView.mapType = .hybrid
        default:
            return
        }
    }
}

extension ViewController: CLLocationManagerDelegate {
    
}

extension ViewController: MKMapViewDelegate {
    
}
