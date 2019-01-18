//
//  ViewController.swift
//  virtualTourist
//
//  Created by Tawfeeq on 14/12/2018.
//  Copyright © 2018 tam. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MapVC: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    var pins = [Pin]() // array of DB pins
    var dataController:DataController! // CoreData context reference
    var selectedPin : Pin!   // initiated when the annotation is selected
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        let longGesture = UILongPressGestureRecognizer(target: self, action:#selector(longPress(_:)))
        mapView.addGestureRecognizer(longGesture)
        loadPins() // fill the pins array at view initiation
    }
    
    func loadPins() {
        pins = PinHelper.getPins(context: dataController.context)
        for pin in pins {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude)
            mapView.addAnnotation(annotation)
        }
    }
    
    @objc func longPress(_ sender: UIGestureRecognizer){
        if sender.state == .ended {
            let coordinate = mapView.convert(sender.location(in: mapView),toCoordinateFrom: mapView)
            selectedPin = PinHelper.add(latitude: coordinate.latitude, longitude: coordinate.longitude, context: dataController.context)
            loadPins()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "show", let vc = segue.destination as? AlbumVC {
            vc.pin = selectedPin
            vc.dataController = dataController
        }
    }
    

}


extension MapVC : MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "pin") as? MKPinAnnotationView
        if let annotationView = annotationView {
            annotationView.annotation = annotation
        }
        else {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            annotationView!.canShowCallout = true
            let btn = UIButton(type: .detailDisclosure)
            annotationView!.rightCalloutAccessoryView = btn
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        //extract the pin by the selected annotation selected coordination
        let pin = PinHelper.getPinByCoordination(pins: pins, coordinate: view.annotation?.coordinate)
        if let pin = pin {
            selectedPin = pin
            self.performSegue(withIdentifier: "show", sender: self)
        }
        // this is needed, so that you can select the annotation multiple times
        mapView.deselectAnnotation(view.annotation, animated: true)
        
    }

}

