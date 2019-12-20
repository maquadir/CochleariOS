//
//  DistanceTests.swift
//  CochleariOSTests
//
//  Created by Quadir on 12/20/19.
//  Copyright © 2019 Quadir. All rights reserved.
//

import XCTest

class ButtonTapTests: XCTestCase {

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
    
    func testCalculateDistance(){
         //declare storyboard
                   
    }
    
    //to test input alert dialog
    func testMarkerButtonTap(){
        
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
                        walert?.dismiss(animated: true, completion: nil)
                        }))
                }
                print("Text field: \(String(describing: textField?.text))")
                }))
                
            alert.addAction(UIAlertAction(title: "CANCEL", style: .default, handler: { [weak alert] (_) in
                
                print("alert dismissed")
                }))
                        
                      //Present the alert.
     
             UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
        
             let expectation = XCTestExpectation(description: "testExample")
             DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
              XCTAssertTrue(UIApplication.shared.keyWindow?.rootViewController?.presentedViewController is UIAlertController)
                 expectation.fulfill()
             })
             wait(for: [expectation], timeout: 2.5)
         
    }
    
    //to test displaying list screen
    func testDisplayListScreen(){
       
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let listScreen = storyBoard.instantiateViewController(withIdentifier: "listscreen")
        XCTAssertTrue(((UIApplication.shared.keyWindow?.rootViewController?.present(listScreen, animated:true, completion:nil)) != nil))
        
    }
    
    //to test displaying detail screen
    func testDisplayDetailScreen(){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let detailScreen = storyBoard.instantiateViewController(withIdentifier: "detailscreen")
        detailScreen.modalPresentationStyle = .fullScreen
        XCTAssertTrue(((UIApplication.shared.keyWindow?.rootViewController?.present(detailScreen, animated:true, completion:nil)) != nil))
        }
    

}
