//
//  CircleView.swift
//  dev-social
//
//  Created by Xhien Yi Tan on 6/08/2016.
//  Copyright © 2016 Xavier TanXY. All rights reserved.
//

import UIKit

class CircleView: UIImageView {


    override func layoutSubviews() {
        layer.cornerRadius = self.frame.width / 2
        
    }
    
}
