//
//  DataViewModel.swift
//  CochleariOS
//
//  Created by Quadir on 12/18/19.
//  Copyright © 2019 Quadir. All rights reserved.
//

import Foundation
import GooglePlaces
import GoogleMaps
import MapKit
import FirebaseCore
import FirebaseFirestore


protocol VCViewModelDelegate{
    
    func placeMarker(_ lat:Double,_ lon:Double,_ List: [Data])
    func presentAlert(alert:UIAlertController,animated:Bool,completion:(() -> Void)?)
    func presentScreen(screen:UIViewController,animated:Bool,completion:(() -> Void)?)

}

//  - ViewModel
public class VCViewModel {

    var locationManager = CLLocationManager()
    var mapView: GMSMapView!
    var listbutton:UIButton!
    var List: [Data] = []
    var vcviewmodeldelegate:VCViewModelDelegate?
    var db: Firestore!
    let url:String = "http://bit.ly/test-locations"
    
    
    public init(locationManager: CLLocationManager,mapView:GMSMapView,listbutton:UIButton) {
        self.locationManager = locationManager
        self.mapView = mapView
        self.listbutton = listbutton
    }
    
    public func fetchfromURL(){
        
        //code to fetch name and location from JSON URl
               guard let url = URL(string: url) else {return}
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
                   
                       //read from jsonArray
                       for dic in jsonArray{
                           guard let title = dic["name"] as? String else { return }
                           guard let lat = dic["lat"] as? Double else { return }
                           guard let lng = dic["lng"] as? Double else { return }
                           let location = CLLocationCoordinate2D(latitude: Double(lat) , longitude: Double(lng) )
                           
                           //add to array lists
                           self.List.append(Data(title, location, "",0))
                       
                           //place markers based on locations fetched from JSON
                           self.vcviewmodeldelegate?.placeMarker(Double(lat),Double(lng),self.List)

                       }
                       //compiler outout -  delectus aut autem//Response result
                    } catch let parsingError {
                       print("Error", parsingError)
                  }
               }
               task.resume()
        
    }
    
    public func fetchfromFirebase(){
            //initialize firebase database
        db = Firestore.firestore()

        db.collection("users").getDocuments() { (querySnapshot, err) in
               if let err = err {
                   print("Error getting documents: \(err)")
               } else {
                   for document in querySnapshot!.documents {
                       let lat = document.get("latitude").map(String.init(describing:)) ?? "nil"
                       let lon = document.get("longitude").map(String.init(describing:)) ?? "nil"
                       let title = document.get("title").map(String.init(describing:)) ?? "nil"
                       let info = document.get("note").map(String.init(describing:)) ?? "nil"
                    let location = CLLocationCoordinate2D(latitude: Double(lat)! , longitude: Double(lon)! )
                       
                       self.List.append(Data(title, location, info,0))
                    
                      //place markers based on locations fetched from Firebase
                    self.vcviewmodeldelegate?.placeMarker(Double(lat)!,Double(lon)!,self.List)
                   
                       
                   }
               }
           }
    }

    func displayInputAlert(marker : GMSMarker,coordinate: CLLocationCoordinate2D){
          
           // Create the alert controller.
           let alert = UIAlertController(title: "Location", message: "Enter a location name", preferredStyle: .alert)
                 
               // Add the text field. You can configure it however you need.
           alert.addTextField { (textField) in
                   textField.text = ""
               }
                 
              // Grab the value from the text field, and print it when the user clicks OK.
           alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                 let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
                 
                 
                 //display alert when no ext is entered
                if(textField?.text == ""){
                     // Create the alert controller.
                        let walert = UIAlertController(title: "Warning", message: "Please enter a location!", preferredStyle: .alert)
                          
                        walert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak walert] (_) in
                         marker.map = nil
                         walert?.dismiss(animated: true, completion: nil)
                          }))
                     
                    self.vcviewmodeldelegate?.presentAlert(alert: walert,animated: true,completion: nil)
                 }else{
                 
                 marker.title = textField?.text
                 let loc_str = "Loc : "
                 let snippet_text = loc_str + String(coordinate.latitude) + "," + String(coordinate.latitude)
                 marker.snippet = snippet_text
                 
                 //append to variables
                self.List.append(Data(marker.title ?? "", marker.position, "",0))
                 
                 // Add a new document with a generated ID
                 let docData: [String: Any] = [
                     "title": textField?.text as Any ,
                     "latitude": String(coordinate.latitude),
                     "longitude": String(coordinate.longitude),
                     "note": "",
                     ]
                 
               self.db.collection("users").document(String(coordinate.latitude)+","+String(coordinate.longitude)).setData(docData) { err in
                     if let err = err {
                         print("Error adding document: \(err)")
                     } else {
                         print("Document added successfully")
                     }
                 }
                 }
                 
                 
                 print("Text field: \(String(describing: textField?.text))")
               }))
                 
              alert.addAction(UIAlertAction(title: "CANCEL", style: .default, handler: { [weak alert] (_) in
                 marker.map = nil
                 print("alert dismissed")
                  }))
                 
               //Present the alert.
            self.vcviewmodeldelegate?.presentAlert(alert: alert, animated: true, completion: nil)

           
       }
    
    func displayDetailScreen(marker:GMSMarker){
        //declare storyboard
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let detailScreen = storyBoard.instantiateViewController(withIdentifier: "detailscreen") as! DetailScreen
        detailScreen.modalPresentationStyle = .fullScreen
        
        //fetch the indeces
        let index = List.firstIndex(where: {$0.location.latitude == marker.position.latitude && $0.location.longitude == marker.position.longitude}) // 0
        
        let lat = String(List[index!].location.latitude)
        let lon = String(List[index!].location.longitude)
        
        //display a detail screen
        if(index != nil){
            detailScreen.text = List[index!].title
            detailScreen.lat = lat
            detailScreen.lon = lon
            detailScreen.info = List[index!].info
            self.vcviewmodeldelegate?.presentScreen(screen: detailScreen, animated:true, completion:nil)
        }
    }

}
 
