//
//  SammelnViewController.swift
//  KotFuerDieWelt
//
//  Created by Fynn Kiwitt on 16.06.18.
//  Copyright © 2018 Fynn Kiwitt. All rights reserved.
//

import UIKit
import MapKit

class SammelnViewController :UIViewController, CLLocationManagerDelegate, MKMapViewDelegate{
    private var mapView :MKMapView!
    private var popUpView :UIView!
    private var blurView :UIVisualEffectView!
    private let locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.title = "Sammeln"
        super.navigationController?.navigationBar.prefersLargeTitles = true
        
        mapView = MKMapView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        
        //GPS Authorization
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self as! CLLocationManagerDelegate
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        //mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(.follow, animated: true)
        mapView.register(MKAnnotationView.self, forAnnotationViewWithReuseIdentifier: "loc")

        
        addTrashcan(location: CLLocationCoordinate2D(latitude: 37.77919, longitude: -122.41914))
        //37.77919 -122.41914
        //latitude: 50.074558, longitude: 8.8686832
        
        self.view.addSubview(mapView)
        
        //openPopUp(isTrashcan: true, location: CLLocationCoordinate2D(latitude: 50.074558, longitude: 8.8686832), attributes: ["dog firendly"])
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        mapView.showsUserLocation = true
        print("position updated")
        print(locations)
    }
    
    func openPopUp(isTrashcan: Bool, location: CLLocationCoordinate2D, attributes:Array<String>){
        popUpView = UIView(frame: CGRect(x: self.view.bounds.width/2 - 150, y: self.view.bounds.height/2 - 100, width: 300, height: 200))
        popUpView.layer.cornerRadius = 20
        popUpView.layer.masksToBounds = true
        popUpView.backgroundColor = UIColor(displayP3Red: (225/255), green: (218/255), blue: (22/255), alpha: 1)
        
        let detailedMapView = MKMapView(frame: CGRect(x: 0, y: 0, width: self.popUpView.bounds.width, height: self.popUpView.bounds.height/2))
        
        detailedMapView.isScrollEnabled = false
        detailedMapView.isZoomEnabled = false
        detailedMapView.isRotateEnabled = false
        detailedMapView.isPitchEnabled = false
        
        
        let viewRegion = MKCoordinateRegionMake(location, MKCoordinateSpanMake(0.005, 0.005))
        detailedMapView.setRegion(viewRegion, animated: true)
        
        self.popUpView.addSubview(detailedMapView)
        
        let distanceLbl = UILabel(frame: CGRect(x: 5, y: self.popUpView.bounds.height/2 + 2, width: self.popUpView.bounds.width - 30, height: 50))
        distanceLbl.font = UIFont.boldSystemFont(ofSize: 30)
        distanceLbl.text = ""
        if isTrashcan{
            distanceLbl.text! += "Trashcan: "
        }else{
            distanceLbl.text! += "Trash: "
        }
        distanceLbl.text! += "0.8km"
        self.popUpView.addSubview(distanceLbl)
        
        
        var attributesLbl = UILabel(frame: CGRect(x: 10, y: self.popUpView.bounds.height/2 + 45, width: self.popUpView.bounds.height - 20, height: 25))
        attributesLbl.text = ""
        if isTrashcan{
            for attribute in attributes{
                attributesLbl.text! += attribute
                if attribute != attributes.last{
                    attributesLbl.text! += ", "
                }
            }
        }
        attributesLbl.font = UIFont.systemFont(ofSize: 17)
        self.popUpView.addSubview(attributesLbl)
        
        let blur = UIBlurEffect(style: .light)
        blurView = UIVisualEffectView(effect: blur)
        blurView.frame = self.view.bounds
        
        self.view.addSubview(blurView)
        self.view.addSubview(popUpView)
    }
    
    
    func closePopUp(){
        popUpView.removeFromSuperview()
        blurView.removeFromSuperview()
    }
    
    
    func addTrashcan(location: CLLocationCoordinate2D){
        let trashcan = MKPointAnnotation()
        trashcan.coordinate = location
        trashcan.title = "Trashcan"
        
        self.mapView.addAnnotation(trashcan)
        self.mapView.selectAnnotation(trashcan, animated: true)
    }
    
    /*func selectAnnotation(_ annotation: MKAnnotation, animated: Bool) {
        print ("did select Annotation")
    }
    */
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        print("Did select Annotation")
        openPopUp(isTrashcan: true, location: (view.annotation?.coordinate)!, attributes: ["dog friendly"])
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("Did select Annotation")
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        print("location updated again")
        self.mapView.showsUserLocation = true
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let view = MKAnnotationView.init(annotation: annotation, reuseIdentifier: "loc")
        view.canShowCallout = true
        let infoBtn = UIButton(type: .detailDisclosure)
        view.rightCalloutAccessoryView = infoBtn
        return view
    }
    
    
}
