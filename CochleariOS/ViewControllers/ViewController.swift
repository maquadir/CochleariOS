//
//  ViewController.swift
//  CochleariOS
//
//  Created by Quadir on 12/13/19.
//  Copyright © 2019 Quadir. All rights reserved.
//

import UIKit
import GooglePlaces
import MapKit
import GoogleMaps
import FirebaseCore
import FirebaseFirestore


class ViewController: UIViewController,GMSMapViewDelegate {

    //variables
    var locationManager = CLLocationManager()
    var mapView: GMSMapView!
    var zoomLevel: Float = 2.0
    var selectedPlace: GMSPlace?
    var tappedMarker : GMSMarker?
    var listbutton: UIButton!
    var List: [Data] = []
    var db: Firestore!
    let defaultLocation = CLLocation(latitude: -33.869405, longitude: 151.199)
    
    //view model
    var viewModel: VCViewModel! {
        didSet {
            
           //set location manager for current location
           locationManager.desiredAccuracy = kCLLocationAccuracyBest
           locationManager.requestAlwaysAuthorization()
           locationManager.distanceFilter = 50
           locationManager.startUpdatingLocation()
           locationManager.delegate = self as? CLLocationManagerDelegate
            
           //set mapview
           self.mapView.settings.myLocationButton = true
           self.mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
           self.mapView.isMyLocationEnabled = true
            
           //add button
           listbutton.setTitle("List", for: .normal)
           listbutton.setTitleColor(UIColor.white, for: .normal)
           listbutton.backgroundColor = .black
           listbutton.layer.cornerRadius = 10
           listbutton.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
           listbutton.tag = 1
        }
    }

    override func viewDidLoad() {
       
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //1.set the location manager
        setLocationManager()
       
        //2.set map
        setMap()
        
        //3.set list button
        setButton()
        
        //4.set view model
        setViewModel()
        
        //5.setup view
        setupViews()
        
        //6.set map marker
        setmapMarker()
        
        //7.code to fetch from JSON URl
        viewModel.fetchfromURL()
        
        //8.code to fetch data from firebase database
        viewModel.fetchfromFirebase()
 
    }
    
    func setLocationManager(){
       
        //code to setup location manager
        locationManager = CLLocationManager()

    }
    
    func setMap(){
       
        //code to display the map on screen
        let camera = GMSCameraPosition.camera(withLatitude: defaultLocation.coordinate.latitude,
                                              longitude: defaultLocation.coordinate.longitude,
                                              zoom: zoomLevel)
        self.mapView = GMSMapView.map(withFrame: view.bounds, camera: camera)

    }
    
    func setButton(){
       
        //code to add a custom button on map
        listbutton = UIButton(frame: CGRect(x: 15, y: 54, width: 60, height: 40))
        
    }
    
    func setViewModel(){
        
        viewModel = VCViewModel(locationManager:locationManager,mapView:mapView, listbutton: listbutton)
        viewModel.vcviewmodeldelegate = self
        
    }
    
    func setupViews(){
        
        self.view.addSubview(mapView)
        self.mapView.addSubview(listbutton)
        self.mapView.isHidden = true
        
    }
    
    func setmapMarker(){
       
        //code to add a custom info window for marker
        self.tappedMarker = GMSMarker()
        self.mapView.delegate = self
        
    }
    
    @objc func buttonClicked(sender: UIButton!) {
        
        //code to display the List Screen of all llocations
           let btnsendtag: UIButton = sender
           if btnsendtag.tag == 1 {

             let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
             let listScreen = storyBoard.instantiateViewController(withIdentifier: "listscreen") as! ListScreen
               
             listScreen.tList = List
             self.present(listScreen, animated:true, completion:nil)
           }
       }
    
    //when tapped on map
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
      
       //add a marker to tappped location
      let marker = GMSMarker()
      marker.position = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
      marker.map = mapView
        
      //code to display input alert
      viewModel.displayInputAlert(marker: marker,coordinate: coordinate )
      
    }
    
    //display marker info window
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
     
        return nil
        
    }
    
    //display a detail screen on marker click
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        viewModel.displayDetailScreen(marker:marker)
        
        return false
        
     }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
    
        //commented code
//       let position = tappedMarker?.position
        
    }
    
    //when info window is tapped
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
       
        print("info window tapped")
    
    }
    
    
}

//extension to View controller
extension ViewController: CLLocationManagerDelegate {

  // Handle incoming location events.
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
   
        let location: CLLocation = locations.last!
        print("Location: \(location)")
        
        //animate camera to current location
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                            longitude: location.coordinate.longitude,
                                            zoom: zoomLevel)
        
        if mapView.isHidden {
            mapView.isHidden = false
            mapView.camera = camera
        } else {
            mapView.animate(to: camera)
        }

  }

  // Handle authorization for the location manager.
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
    switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            // Display the map using the default location.
            mapView.isHidden = false
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        }
    }

  // Handle location manager errors.
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    
    locationManager.stopUpdatingLocation()
    print("Error: \(error)")
    
  }
}


extension ViewController: VCViewModelDelegate{
    
    func presentScreen(screen: UIViewController, animated: Bool, completion: (() -> Void)?) {
         self.present(screen, animated: animated, completion: completion)
    }
    
    
    func presentAlert(alert: UIAlertController, animated: Bool, completion: (() -> Void)?) {
         self.present(alert, animated: animated, completion: completion)
    }
    

    func placeMarker(_ lat: Double, _ lon: Double,_ List:[Data]) {
        DispatchQueue.main.async {
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: lat , longitude: lon )
            marker.map = self.mapView
            self.List = List
        }
    }
    
    
    
}

