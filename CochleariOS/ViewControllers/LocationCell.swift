//
//  LocationCell.swift
//  CochleariOS
//
//  Created by Quadir on 12/15/19.
//  Copyright © 2019 Quadir. All rights reserved.
//

import UIKit

class LocationCell: UITableViewCell {

    var delegate: LocationCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if(selected == true){

            delegate?.moveToDetail(title: titleLabel.text ?? "",note: noteLabel.text ?? "",latitude: latLabel.text ?? "", longitude: lonLabel.text ?? "")
            
        }
      
        // Configure the view for the selected state
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
        
       }
    
       
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        addSubview(cellView)
        cellView.addSubview(dayLabel)
        cellView.addSubview(latLabel)
        cellView.addSubview(lonLabel)
        cellView.addSubview(titleLabel)
        cellView.addSubview(noteLabel)
        self.selectionStyle = .none
        
        NSLayoutConstraint.activate([
            cellView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            cellView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10),
            cellView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
            cellView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        dayLabel.heightAnchor.constraint(equalToConstant: 200).isActive = true
        dayLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
        dayLabel.centerYAnchor.constraint(equalTo: cellView.centerYAnchor).isActive = true
        dayLabel.leftAnchor.constraint(equalTo: cellView.leftAnchor, constant: 20).isActive = true

    }
    
    
    let cellView: UIView = {
          let view = UIView()
        view.backgroundColor = UIColor.black
          view.layer.cornerRadius = 10
          view.translatesAutoresizingMaskIntoConstraints = false
          return view
      }()
      
      let dayLabel: UILabel = {
          let label = UILabel()
          label.text = "Day 1"
          label.textColor = UIColor.white
          label.font = UIFont.boldSystemFont(ofSize: 16)
          label.translatesAutoresizingMaskIntoConstraints = false
          return label
      }()
    
    let titleLabel: UILabel = {
             let label = UILabel()
             label.text = ""
             label.textColor = UIColor.white
             label.font = UIFont.boldSystemFont(ofSize: 16)
             label.translatesAutoresizingMaskIntoConstraints = false
             label.isHidden = true
             return label
         }()
    
    let noteLabel: UILabel = {
             let label = UILabel()
             label.text = ""
             label.textColor = UIColor.white
             label.font = UIFont.boldSystemFont(ofSize: 16)
             label.isHidden = true
             label.translatesAutoresizingMaskIntoConstraints = false
             return label
       }()
  
    let latLabel: UILabel = {
           let label = UILabel()
           label.text = ""
           label.textColor = UIColor.white
           label.isHidden = true
           label.font = UIFont.boldSystemFont(ofSize: 16)
           label.translatesAutoresizingMaskIntoConstraints = false
           return label
       }()
    
    let lonLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = UIColor.white
        label.isHidden  = true
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

}

//delegate protocol
protocol LocationCellDelegate {
    func moveToDetail(title:String,note:String,latitude:String,longitude:String)
}
