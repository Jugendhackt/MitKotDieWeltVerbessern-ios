//
//  MeldenViewController.swift
//  KotFuerDieWelt
//
//  Created by Fynn Kiwitt on 16.06.18.
//  Copyright © 2018 Fynn Kiwitt. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ReportViewController :UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate, CLLocationManagerDelegate, UITextViewDelegate{
    
    var scrollView :UIScrollView!
    var trashKindSelector :UITableView!
    let trashKinds = ["sharp-edged", "wet", "feces", "rotten", "multiple pieces"]
    let trashPictureView = UIButton(frame: CGRect(x: 5, y: 5, width: 90, height: 90))
    var locationLbl: UITextView = UITextView()
    let locationManager = CLLocationManager()

    var locationComplete: String = "Tap to add a location"
    
    
    var selectedTrashAttributes = [false, false, false, false, false]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Report"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        self.scrollView.contentSize = CGSize(width: self.view.bounds.width, height: 1000)
        scrollView.showsVerticalScrollIndicator = true
        scrollView.isScrollEnabled = true
        scrollView.isUserInteractionEnabled = true
        self.view.addSubview(scrollView)
        
        
        let backgroundColor = UIColor(red: (225/255), green: (225/255), blue: (225/255), alpha: 1)
        self.view.backgroundColor = backgroundColor
        trashKindSelector = UITableView(frame: CGRect(x: 0, y: 150, width: self.view.bounds.width, height: 250))
        trashKindSelector.register(UITableViewCell.self, forCellReuseIdentifier: "option")
        trashKindSelector.dataSource = self
        trashKindSelector.delegate = self
        trashKindSelector.isScrollEnabled = false
        trashKindSelector.rowHeight = 45
        trashKindSelector.backgroundColor = .white
        self.scrollView.addSubview(trashKindSelector)
        
        let submitBtn = UIBarButtonItem(title: "Submit", style: .done, target: self, action: #selector(submitTrash))
        self.navigationItem.rightBarButtonItem = submitBtn
        
        
        
        let overviewView = UIButton(frame: CGRect(x: 0, y: 10, width: self.view.bounds.width, height: 100))
        let headlineLbl = UILabel(frame: CGRect(x: 100, y: 5, width: self.view.bounds.width - 110, height: 30))
        locationLbl = UITextView(frame: CGRect(x: 100, y: 40, width: self.view.bounds.width - 110, height: 60))
        locationLbl.textContainerInset = UIEdgeInsets.zero
        locationLbl.textContainer.lineFragmentPadding = 0
        locationLbl.font = UIFont.systemFont(ofSize: 15)
        locationLbl.isUserInteractionEnabled = false
        overviewView.backgroundColor = .white
        headlineLbl.text = "New Trash"
        headlineLbl.font = UIFont.boldSystemFont(ofSize: 25)
        locationLbl.text = locationComplete
        trashPictureView.backgroundColor = .darkGray
        trashPictureView.addTarget(self, action: #selector(activateCamera(sender:)) , for: .touchUpInside)
        overviewView.addTarget(self, action: #selector(getPosition(sender:)), for: .touchUpInside)
        overviewView.addSubview(trashPictureView)
        overviewView.addSubview(headlineLbl)
        overviewView.addSubview(locationLbl)
        overviewView.backgroundColor = .white
        self.scrollView.addSubview(overviewView)
        
        
        let commentText = UITextView(frame: CGRect(x: 0, y: 420, width: self.view.bounds.width, height: 75))
        commentText.isUserInteractionEnabled = true
        commentText.text = "Comment(optional)"
        commentText.textColor = .lightGray
        commentText.font = UIFont.systemFont(ofSize: 15)
        commentText.autocorrectionType = .yes
        commentText.autocapitalizationType = .sentences
        commentText.backgroundColor = .white
        scrollView.delegate = self
        self.scrollView.addSubview(commentText)
    }
    
    
    func textViewDidBeginEditing(textView: UITextView) {
        print("function executed")
        print("Color: \(textView.textColor)")
        if textView.textColor == .lightGray {
            print("lightGray")
            textView.text = ""
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text.isEmpty{
            textView.text = "Comment(optional)"
            textView.textColor = .lightGray
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        adjustTableViewSize(tableView: self.trashKindSelector)
    }
    
    
    func adjustTableViewSize(tableView: UITableView){
        var newFrame = tableView.frame
        newFrame.size.height = tableView.contentSize.height
        tableView.frame = newFrame
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if cell?.accessoryType != .checkmark{
            cell?.accessoryType = .checkmark
            self.selectedTrashAttributes[indexPath.row] = true
        }else{
            cell?.accessoryType = .none
            self.selectedTrashAttributes[indexPath.row] = false
        }
        cell?.isSelected = false
    }
    
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "option")
        
        if tableView == trashKindSelector{
            cell?.textLabel?.text = trashKinds[indexPath.row]
        }
        
        cell?.backgroundColor = .white
        
        return cell!
    }
    
    //camera
    @objc func activateCamera(sender: UIButton) {

        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .camera
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        trashPictureView.setBackgroundImage(image, for: .normal)
        
        dismiss(animated: true, completion: nil)
    }
    
    @objc func getPosition(sender: UIButton) {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {(placemarks, error)->Void in
            
            if (error != nil) {
                print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
                return
            }
            
            if (placemarks?.count)! > 0 {
                let pm = placemarks?[0]
                self.displayLocationInfo(pm)
                print (self.displayLocationInfo(pm))
            } else {
                print("Problem with the data received from geocoder")
            }
        })
    }
    
    func displayLocationInfo(_ placemark: CLPlacemark?) {
        if let containsPlacemark = placemark {
            //stop updating location to save battery life
            locationManager.stopUpdatingLocation()
            
            let street = containsPlacemark.thoroughfare ?? ""
            let number = containsPlacemark.subThoroughfare ?? ""
            let city = containsPlacemark.locality ?? ""
            let postalCode = containsPlacemark.postalCode ?? ""
            let state = containsPlacemark.administrativeArea ?? ""
            let country = containsPlacemark.country ?? ""
            
            let fullAddress = "\(street) \(number), \(city) \(postalCode), \(state), \(country)"
            
            locationComplete = fullAddress
            locationLbl.text = locationComplete
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while updating location " + error.localizedDescription)
    }

    @objc func submitTrash(){
        let alert = UIAlertController(title: "Thanks", message: "Thank you for submitting!", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}
