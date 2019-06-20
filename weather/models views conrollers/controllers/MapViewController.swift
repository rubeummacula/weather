//
//  MapViewController.swift
//  weather
//
//  Created by Vladimir Psyukalov on 19.06.2019.
//  Copyright © 2019 Vladimir Psyukalov. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UpdaterProtocol {
    
    let defaultCoord = CLLocationCoordinate2D.init(latitude: 47.23135, longitude: 39.72328)
    
    let dist = 200000.0 // 200 km
    
    var focused = false;
    
    var touchLocation: TouchLocation?
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = NSLocalizedString("map_title", comment: "")
        focusOn(defaultCoord, animated: false)
        locationManager = CLLocationManager.init()
        locationManager.delegate = self
        locationManager.distanceFilter = 100.0
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.startUpdatingLocation()
        locationManager.requestWhenInUseAuthorization()
        let tapGR = UITapGestureRecognizer.init(target: self, action: #selector(tap(gesture:)))
        mapView.addGestureRecognizer(tapGR)
        Updater.shared.observers.append(self)
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .all
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
    
    @objc func tap(gesture: UITapGestureRecognizer) {
        let point = gesture.location(in: mapView)
        let view = mapView.hitTest(point, with: nil)
        if let annotationView = view as? MKAnnotationView {
            if let annotation = annotationView.annotation {
                mapView.selectAnnotation(annotation, animated: true)
            }
            return
        }
        let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
        if touchLocation == nil {
            touchLocation = TouchLocation()
            mapView.addAnnotation(touchLocation!)
        }
        for annotation in mapView.annotations {
            if annotation is MKPointAnnotation && !annotation.isEqual(touchLocation) {
                mapView.removeAnnotation(annotation)
            }
        }
        touchLocation!.coordinate = coordinate
        focusOn(coordinate)
        update(coordinate)
    }
    
    func update(_ coordinate: CLLocationCoordinate2D) {
        indicator.startAnimating()
        Updater.shared.update(coordinate.latitude, coordinate.longitude)
    }
    
    //MARK: UpdaterProtocol
    
    func didUpdate(data: [[String : Any]]?) {
        indicator.stopAnimating()
        if data != nil {
            for item in data! {
                guard let name = item[keyPath: "name"] as? String else {
                    return
                }
                guard let temp = item[keyPath: "main.temp"] as? Double else {
                    return
                }
                guard let lat = item[keyPath: "coord.lat"] as? Double else {
                    return
                }
                guard let long = item[keyPath: "coord.lon"] as? Double else {
                    return
                }
                let pointAnnotation = MKPointAnnotation()
                pointAnnotation.title = name
                pointAnnotation.subtitle = temp.fullString()
                pointAnnotation.coordinate = CLLocationCoordinate2D.init(latitude: lat, longitude: long)
                mapView.addAnnotation(pointAnnotation)
            }
        }
    }
    
    //MARK: focusOn
    
    func focusOn(_ coordinate: CLLocationCoordinate2D) {
        focusOn(coordinate, animated: true)
    }
    
    func focusOn(_ coordinate: CLLocationCoordinate2D, animated: Bool) {
        let region = MKCoordinateRegion.init(center: coordinate, latitudinalMeters: dist, longitudinalMeters: dist)
        mapView.setRegion(region, animated: animated)
    }
    
    //MARK: CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted, .denied, .notDetermined:
            focusOn(defaultCoord) // focus on RnD
        default:
            manager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            if (!focused) {
                focused = true
                manager.stopUpdatingLocation()
                focusOn(location.coordinate)
                update(location.coordinate)
            }
        }
    }
    
    //MARK: MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "annotationView"
        let annotationView = reusingAnnotaionView(identifier, annotation: annotation)
        annotationView.canShowCallout = false
        if annotation is MKUserLocation {
            annotationView.image = UIImage.init(named: "user_pin")
        }
        if annotation is MKPointAnnotation {
            annotationView.image = UIImage.init(named: "point_pin")
            annotationView.canShowCallout = true
        }
        if annotation is TouchLocation {
            annotationView.image = UIImage.init(named: "touch_pin")
        }
        return annotationView
    }
    
    func reusingAnnotaionView(_ identifier: String, annotation: MKAnnotation) -> MKAnnotationView {
        var annotationView: MKAnnotationView
        if let dequeueView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) {
            annotationView = dequeueView
            annotationView.annotation = annotation
        } else {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }
        return annotationView
    }
    
}
