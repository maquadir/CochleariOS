//
//  DetailScreen.swift
//  CochleariOS
//
//  Created by Quadir on 12/14/19.
//  Copyright © 2019 Quadir. All rights reserved.
//

import UIKit
import GooglePlaces
import MapKit
import GoogleMaps
import FirebaseCore
import FirebaseFirestore
import Foundation

class DetailScreen: UIViewController {

    //local string variables
    var text:String = ""
    var location:CLLocationCoordinate2D? = nil
    var info:String = ""
    
    //firebase db variable
    var db: Firestore!
    
    //view elemnts
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var notesText: UITextField!
    
    override func viewDidLoad() {
          super.viewDidLoad()
        
        //assign text to labels
        let title = "Title : "
        titleLabel.text = title + text
        let lat = String(location!.latitude)
        let lon = String(location!.longitude)
        let loc = "Location : "
        locationLabel.text = loc + lat + "," + lon
        
        let note = "Notes : "
        if(info == ""){
            noteLabel.text = ""
        }else{
            noteLabel.text = note + info
        }
        
        //initialize firebase database
        db = Firestore.firestore()
    }

    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)

    }
    
    @IBAction func saveButton(_ sender: Any) {
           updateDb()

           //navigate back to main viewcontroller
           navigateToMain()
           
       }
    
    func updateDb(){
        
        // Update one field, creating the document if it does not exist.
        self.db.collection("users").document(String(location!.latitude)+","+String(location!.longitude)).setData([ "note": notesText.text ], merge: true)
        
    }
    
    func navigateToMain(){
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "vcontroller") as! ViewController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated:true, completion:nil)
        
    }
}
