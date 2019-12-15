//
//  ListScreen.swift
//  CochleariOS
//
//  Created by Quadir on 12/15/19.
//  Copyright © 2019 Quadir. All rights reserved.
//

import UIKit
import GooglePlaces
import MapKit
import GoogleMaps
import FirebaseCore
import FirebaseFirestore
import CoreLocation

class ListScreen: UIViewController, UITableViewDelegate,  UITableViewDataSource {
   
    
    @IBOutlet weak var tableView: UITableView!
    // cell reuse id (cells that scroll out of view can be reused)
    let cellReuseIdentifier = "cellId"
    var db: Firestore!
    var currentLocation: CLLocation!
    
    var note: [String] = []
    var clocation: [CLLocationCoordinate2D] = []
    var finalList = [String: Double]()
    var List = [String: Double]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //get current location of user
        getLocation()
        
        //order locations sorted by distance
        sortLocations()

        //setup table view
        setupTableView()
        
        
    }
    
    func getLocation(){
        var locManager = CLLocationManager()
        locManager.requestWhenInUseAuthorization()
        if( CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
                CLLocationManager.authorizationStatus() ==  .authorizedAlways){
              currentLocation = locManager.location

        }
    }
    
    func sortLocations(){
        print(clocation.count)

        for index in 0...clocation.count - 1 {
            let coordinate₁ = CLLocation(latitude: clocation[index].latitude, longitude: clocation[index].longitude)
            let distanceInMeters = currentLocation.distance(from: coordinate₁)
            List[note[index]] = distanceInMeters
        }
        
        for (k,v) in (Array(List).sorted {$0.1 < $1.1}) {
            finalList[k] = v
        }
    
    }
    
    func setupTableView(){
        
        // Register the table view cell class and its reuse id
        self.tableView.register(LocationCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return finalList.count
       }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! LocationCell
        cell.backgroundColor = UIColor.white
        print(indexPath.row)
        print(finalList.count)
        if(finalList.count != 0){
            cell.dayLabel.text = Array(finalList.keys)[indexPath.row]
        }
//        print(indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    @IBAction func closeScreen(_ sender: Any) {
           self.dismiss(animated: true)
    }
}
