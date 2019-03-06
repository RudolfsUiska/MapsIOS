//
//  ViewController.swift
//  Maps
//
//  Created by Students on 06/03/2019.
//  Copyright © 2019 RudolfsUiska. All rights reserved.
//

import UIKit
import MapKit
class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationAuthorizationStatus()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
       
        let tinte = Descript(title: "Tinte", locationName: "Terbatas iela",coordinate: CLLocationCoordinate2D(latitude: 57.540835, longitude: 25.426447))
        let baznica = Descript(title: "Tirzas baznīca", locationName: "Tirza",coordinate: CLLocationCoordinate2D(latitude: 57.143376, longitude: 26.433543))
        let kebabnica = Descript(title: "Ausmeņa kebabs", locationName: "Rēzekne",coordinate: CLLocationCoordinate2D(latitude: 56.508136, longitude: 27.335644))
        mapView.addAnnotation(tinte)
        mapView.addAnnotation(baznica)
        mapView.addAnnotation(kebabnica)
        mapView.delegate = self
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark:  MKPlacemark(coordinate: baznica.coordinate, addressDictionary: nil))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: tinte.coordinate, addressDictionary: nil))
        request.requestsAlternateRoutes = true
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        
        directions.calculate { [unowned self] response, error in
            guard let unwrappedResponse = response else { return }
            
            for route in unwrappedResponse.routes {
                self.mapView.addOverlay(route.polyline)
                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = UIColor.blue
        return renderer
    }
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            guard let annotation = annotation as? Descript else { return nil }
            let identifier = "marker"
            var view: MKMarkerAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
                as? MKMarkerAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            }
            return view
        
    }


}

