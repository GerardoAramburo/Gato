//
//  CirclePath.swift
//  gato
//
//  Created by Gerardo on 22/04/34.
//

import UIKit

class CirclePath: UIBezierPath {
    private var position = [[0, 0, 0],
                            [0, 0, 0],
                            [0, 0, 0]]
    
    private var coordinates: CGPoint
    
    required init(ovalIn rect: CGRect) {
        self.coordinates = rect.origin
        
        super.init()
        
        self.addArc(withCenter: CGPoint(x: rect.minX, y: rect.minY), radius: rect.size.width / 2, startAngle: 0, endAngle: Double.pi * 2, clockwise: false)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
