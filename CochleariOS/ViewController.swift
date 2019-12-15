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

 
    var db: Firestore!
    
    //GMSAutocompleteResultsViewController provides an interface that displays locations in a table view
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var mapView: GMSMapView!
    var zoomLevel: Float = 2.0
    

    // The currently selected place.
    var selectedPlace: GMSPlace?
    // A default location to use when location permission is not granted.
    let defaultLocation = CLLocation(latitude: -33.869405, longitude: 151.199)
    
    //variables for custom info window
    var tappedMarker : GMSMarker?
    var customInfoWindow : CustomInfoWindow?
    
    var note: [String] = []
    var clocation: [CLLocationCoordinate2D] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //initialize firebase database
        db = Firestore.firestore()
        
        //set the location manager
        setLocationManager()
       
        //display map and move camera to current location
        displayMap()

        // Add the map to the view, hide it until we've got a location update.
        view.addSubview(mapView)
        
        //add a button in maps
        addButton()
        
        self.mapView.isHidden = true
        
        //code for custom info window
        addinfoWindow()
        
        //code to fetch from JSON URl
        fetchfromURL()
        
        //code to fetch data from firebase database
        fetchfromFirebase()
 
       
    }
    
    func setLocationManager(){
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self as? CLLocationManagerDelegate

    }
    
    func displayMap(){
        let camera = GMSCameraPosition.camera(withLatitude: defaultLocation.coordinate.latitude,
                                              longitude: defaultLocation.coordinate.longitude,
                                              zoom: zoomLevel)
        self.mapView = GMSMapView.map(withFrame: view.bounds, camera: camera)
        self.mapView.settings.myLocationButton = true
        self.mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.mapView.isMyLocationEnabled = true
    }
    
    func addButton(){
        let button = UIButton(frame: CGRect(x: 15, y: 54, width: 70, height: 50))
        button.setTitle("List", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = .black
        button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        button.tag = 1
        self.mapView.addSubview(button)
    }
    
    func addinfoWindow(){
        self.tappedMarker = GMSMarker()
        self.customInfoWindow = CustomInfoWindow().loadView()
        self.mapView.delegate = self
    }
    
    @objc func buttonClicked(sender: UIButton!) {
        let btnsendtag: UIButton = sender
        if btnsendtag.tag == 1 {

          let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
          let listScreen = storyBoard.instantiateViewController(withIdentifier: "listscreen") as! ListScreen
            
          listScreen.note = note
          listScreen.clocation = clocation
          self.present(listScreen, animated:true, completion:nil)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        

    }
    
    
    func fetchfromURL(){
        guard let url = URL(string: "http://bit.ly/test-locations") else {return}
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
        guard let dataResponse = data,
                  error == nil else {
                  print(error?.localizedDescription ?? "Response Error")
                  return }
            do{
                //here dataResponse received from a network request
                let jsonResponse = try JSONSerialization.jsonObject(with:
                                       dataResponse, options: .allowFragments) as? [String:Any]
                let locations = jsonResponse?["locations"] as? [[String: Any]] ?? []
                guard let jsonArray = locations as? [[String: Any]] else {
                      return
                }
            
                //Now get title value
                guard let title = jsonArray[0]["name"] as? String else { return }
                for dic in jsonArray{
                    guard let title = dic["name"] as? String else { return }
                    guard let lat = dic["lat"] as? Double else { return }
                    guard let lng = dic["lng"] as? Double else { return }
                    let location = CLLocationCoordinate2D(latitude: Double(lat) , longitude: Double(lng) )
                    
                    //add to array lists
                    self.note.append(title)
                    self.clocation.append(location)
                
                    //place markers based on locations fetched from JSON
                  DispatchQueue.main.async {
                    let marker = GMSMarker()
                    marker.position = CLLocationCoordinate2D(latitude: Double(lat) , longitude: Double(lng) )
                    marker.map = self.mapView
                  }
                  

                }
                //compiler outout -  delectus aut autem//Response result
             } catch let parsingError {
                print("Error", parsingError)
           }
        }
        task.resume()
        
      
    
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
      
       //add a marker to tappped location
      let marker = GMSMarker()
      marker.position = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
      marker.map = mapView
        
    
        // Create the alert controller.
      let alert = UIAlertController(title: "Location", message: "Enter a location name", preferredStyle: .alert)
        
      // Add the text field. You can configure it however you need.
      alert.addTextField { (textField) in
          textField.text = ""
      }
        
     // Grab the value from the text field, and print it when the user clicks OK.
     alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
        let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
        marker.title = textField?.text
        let loc_str = "Loc : "
        let snippet_text = loc_str + String(coordinate.latitude) + "," + String(coordinate.latitude)
        marker.snippet = snippet_text
        
        // Add a new document with a generated ID
        let docData: [String: Any] = [
            "title": textField?.text as Any ,
            "latitude": String(coordinate.latitude),
            "longitude": String(coordinate.longitude),

            ]
        
      self.db.collection("users").document(String(coordinate.latitude)+","+String(coordinate.longitude)).setData(docData) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added successfully")
            }
        }
        
        
        print("Text field: \(String(describing: textField?.text))")
      }))
        
     alert.addAction(UIAlertAction(title: "CANCEL", style: .default, handler: { [weak alert] (_) in
        marker.map = nil
        print("alert dismissed")
         }))
        
      //Present the alert.
      self.present(alert, animated: true, completion: nil)
        
       //dismiss the custom info window when clicked anywhere on the map
       customInfoWindow?.removeFromSuperview()
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
     return customInfoWindow
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
       
        tappedMarker = marker
        
        //get position of tapped marker
        let position = marker.position
        mapView.animate(toLocation: position)
        let point = mapView.projection.point(for: position)
        let newPoint = mapView.projection.coordinate(for: point)
        let camera = GMSCameraUpdate.setTarget(newPoint)
        mapView.animate(with: camera)
        
        let loc = "Location : "
        
        //add data to customm info window
        if clocation.contains(where: {$0.latitude == marker.position.latitude && $0.longitude == marker.position.longitude}) {
            let index = clocation.index(where: {$0.latitude == marker.position.latitude && $0.longitude == marker.position.longitude})
           
            customInfoWindow?.iw_title.text = note[index!]
            customInfoWindow?.iw_snippet.text = loc + String(marker.position.latitude) + "," + String(marker.position.longitude)
            customInfoWindow?.layer.cornerRadius = 10
            customInfoWindow?.center = mapView.projection.point(for:position)
            self.mapView.addSubview(customInfoWindow!)
        }
        
        //code to reset marker
        
        
        
     return false
     }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
     let position = tappedMarker?.position
     customInfoWindow?.center = mapView.projection.point(for: position!)
     customInfoWindow?.center.y -= 100
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
       
        print("info window tapped")
       let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
       let detailScreen = storyBoard.instantiateViewController(withIdentifier: "detailscreen") as! DetailScreen
       let index = clocation.index(where: {$0.latitude == marker.position.latitude && $0.longitude == marker.position.longitude}) // 0
       let loc = "Location : "
       let location = loc + String(marker.position.latitude) + "," + String(marker.position.longitude)
        detailScreen.text = note[index!]
        detailScreen.location = location
       self.present(detailScreen, animated:true, completion:nil)
    }

    func fetchfromFirebase(){
        db.collection("users").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                let loc = "Location : "
                for document in querySnapshot!.documents {
                
                    let lat = document.get("latitude").map(String.init(describing:)) ?? "nil"
                    let lon = document.get("longitude").map(String.init(describing:)) ?? "nil"
                    let title = document.get("title").map(String.init(describing:)) ?? "nil"
                    let snippet = loc + lat + "," + lon
                    
                    //add a marker to tappped location
                    let marker = GMSMarker()
                    marker.position = CLLocationCoordinate2D(latitude: Double(lat)! , longitude: Double(lon)! )
                    marker.map = self.mapView
                    
                    self.note.append(title)
                    self.clocation.append(marker.position)
                }
            }
        }
    }
    
}


extension ViewController: CLLocationManagerDelegate {

  // Handle incoming location events.
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    let location: CLLocation = locations.last!
    print("Location: \(location)")

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


