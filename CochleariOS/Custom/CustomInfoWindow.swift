//
//  CustomInfoWindow.swift
//  CochleariOS
//
//  Created by Quadir on 12/14/19.
//  Copyright © 2019 Quadir. All rights reserved.
//

import UIKit

class CustomInfoWindow: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBOutlet weak var iw_title: UILabel!
    @IBOutlet weak var iw_snippet: UILabel!

    
    var customInfoWindow : CustomInfoWindow?
    var detailscreen : DetailScreen?
//    let vc = ViewController()
    
    override init(frame: CGRect) {
     super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
     super.init(coder: aDecoder)
    }
    func loadView() -> CustomInfoWindow{
        customInfoWindow = Bundle.main.loadNibNamed("CustomInfoWindow", owner: self, options: nil)?[0] as? CustomInfoWindow
        return customInfoWindow!
    }

}
