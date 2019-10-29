//
//  DeviceCell.swift
//  LocalServiceMdns
//
//  Created by Dilyana Yankova on 29.10.19.
//  Copyright © 2019 Dilyana Yankova. All rights reserved.
//

import Foundation
import UIKit

class DeviceCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let nameLabel : UILabel = {
        let label = UILabel()
        label.text = "Task"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor  = UIColor.purple
        return label
        
    }()
   
     func setupViews(){
        addSubview(nameLabel)
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[v0]-18-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0" : nameLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[v0]-18-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0" : nameLabel]))
            
    }
}
