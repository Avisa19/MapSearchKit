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

    fileprivate let MARKER_ID = "Marker Id"
    
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
    
    fileprivate var textField = UITextField()
    
    fileprivate lazy var pinAddress: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Pin Address", for: .normal)
        button.setTitleColor(UIColor.systemBlue.withAlphaComponent(0.5), for: .normal)
        button.layer.borderColor = UIColor.systemBlue.withAlphaComponent(0.5).cgColor
        button.layer.borderWidth = 0.5
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handlePinAddress), for: .touchUpInside)
        return button
    }()
    
    @objc fileprivate func handlePinAddress() {
        let alertController = UIAlertController(title: "Enter Address", message: "We need your address for GeoCoder", preferredStyle: .alert)
        
        alertController.addTextField { (tf) in
            
        }
        let saveButton = UIAlertAction(title: "Pin Address", style: .default) { (_) in
            if let tf = alertController.textFields?.first {
                print(tf.text)
            }
        }
        alertController.addAction(saveButton)
        present(alertController, animated: true, completion: nil)
    }
    
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
        
        bg.addSubview(pinAddress)
        
        pinAddress.topAnchor.constraint(equalTo: bg.topAnchor, constant: 5).isActive = true
        pinAddress.centerXAnchor.constraint(equalTo: bg.centerXAnchor).isActive = true
        pinAddress.widthAnchor.constraint(equalToConstant: 125).isActive = true
        pinAddress.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        segmentedControl.centerXAnchor.constraint(equalTo: bg.centerXAnchor).isActive = true
        segmentedControl.centerYAnchor.constraint(equalTo: bg.centerYAnchor).isActive = true
        segmentedControl.heightAnchor.constraint(equalToConstant: 30).isActive = true
        segmentedControl.widthAnchor.constraint(equalToConstant: 300).isActive = true
        
        // location Manager
        locationManager.delegate = self
        mapView.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.startUpdatingLocation()
        mapView.showsUserLocation = true
        
        segmentedControl.addTarget(self, action: #selector(handleSwitch), for: .valueChanged)
        
        /* addAnnotationMap() */
    }
    
    fileprivate func addAnnotationMap() {
        let annotation = MKPointAnnotation()
        annotation.coordinate = mapView.userLocation.coordinate
        annotation.title = "AvisaCodes"
        annotation.subtitle = "apple lover iOS concepts"
        mapView.addAnnotation(annotation)
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
    
    fileprivate func setupMapSnapShot(annoation: MKAnnotationView) {
        
        let option = MKMapSnapshotter.Options()
        option.size = .init(width: 200, height: 200)
        option.mapType = .satelliteFlyover
        let center = annoation.annotation?.coordinate ?? CLLocationCoordinate2D(latitude: 20, longitude: 20)
        option.camera = MKMapCamera(lookingAtCenter: center, fromDistance: 150, pitch: 50, heading: 0)
        
        let snapShotter = MKMapSnapshotter(options: option)
        snapShotter.start { (snapshot, err) in
            if let err = err {
                print("Failed to take a snapshot: \(err.localizedDescription)")
                return
            }
            
            if let snapshot = snapshot {
                let imageView = UIImageView(frame: .init(x: 50, y: 50, width: 100, height: 100))
                imageView.image = snapshot.image
                annoation.detailCalloutAccessoryView = imageView
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
        let region = MKCoordinateRegion(center: mapView.userLocation.coordinate, latitudinalMeters: 10, longitudinalMeters: 10)
        mapView.setRegion(region, animated: true)
        addAnnotationMap()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation { return nil }
        let marker = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: MARKER_ID)
        marker.glyphText = "Hello"
        marker.canShowCallout = true
        marker.leftCalloutAccessoryView = UIImageView(image: #imageLiteral(resourceName: "baseline_explore_black_18dp"))
        marker.rightCalloutAccessoryView = UIImageView(image: #imageLiteral(resourceName: "baseline_navigate_next_black_18dp"))
       /* marker.glyphImage = #imageLiteral(resourceName: "baseline_explore_black_18dp") */
        marker.tintColor = .systemBlue
        setupMapSnapShot(annoation: marker)
        return marker
    }
}
