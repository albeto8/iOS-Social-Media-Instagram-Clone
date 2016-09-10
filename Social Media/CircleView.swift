//
//  CircleView.swift
//  Social Media
//
//  Created by Mario Alberto Barragán Espinosa on 06/09/16.
//  Copyright © 2016 mario. All rights reserved.
//

import UIKit

class CircleView: UIImageView {

    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = self.frame.width / 2
    }

}
