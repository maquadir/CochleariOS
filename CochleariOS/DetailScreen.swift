//
//  DetailScreen.swift
//  CochleariOS
//
//  Created by Quadir on 12/14/19.
//  Copyright © 2019 Quadir. All rights reserved.
//

import Foundation
import UIKit


class DetailScreen: UIViewController {

    var text:String = ""
    var location:String = ""
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    override func viewDidLoad() {
          super.viewDidLoad()
        
        titleLabel.text = text
        locationLabel.text = location
    }

    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
//        let vc = ViewController()
//        self.present(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func saveButton(_ sender: Any) {
        
    }
}
