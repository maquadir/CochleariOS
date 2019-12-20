//
//  MapTests.swift
//  CochleariOSTests
//
//  Created by Quadir on 12/20/19.
//  Copyright © 2019 Quadir. All rights reserved.
//

import XCTest
import GooglePlaces
import MapKit
import GoogleMaps
import UIKit
import FirebaseCore
import FirebaseFirestore

class FetchFromSourcesTests: XCTestCase {
    
    var count:Int = 0
    var fcount:Int = 0
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    //function to test if entries are fetched from JSON
    func testFetchFromJSON(){
        
        
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
            
                //read from jsonArray
                for dic in jsonArray{
                    self.count = self.count + 1
                }
                
                  XCTAssertTrue(self.count > 0, "No Entries fetched from JSON")
                //compiler outout -  delectus aut autem//Response result
             } catch let parsingError {
                print("Error", parsingError)
           }
        }
        task.resume()
        
      
    }
    
    //function to test if entries are fetched from Firebase
    func testFetchFromFirebase(){
        //initialize firebase database
        let db = Firestore.firestore()
        
        db.collection("users").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                self.fcount = -1
            } else {
                for document in querySnapshot!.documents {
                    self.fcount = self.fcount + 1
               }
           }
            XCTAssertTrue(self.fcount > 0, "No entries fetched from Firebase")
       }
        
        
    }

}
