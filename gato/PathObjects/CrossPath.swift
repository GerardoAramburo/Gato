//
//  CrossPath.swift
//  gato
//
//  Created by Gerardo on 22/04/34.
//

import UIKit

class CrossPath: UIBezierPath {
    private var position = [[0, 0, 0],
                            [0, 0, 0],
                            [0, 0, 0]]
    private var coordinates: CGPoint

    required init(large: CGFloat, position: CGPoint) {
        self.coordinates = position

        super.init()
        
                
        self.move(to: CGPoint(x: position.x - (large / 2), y: position.y + (large / 2) ))
        self.addLine(to: CGPoint(x: position.x + (large / 2), y: position.y - (large / 2)))
        self.move(to: CGPoint(x: position.x - (large / 2), y: position.y - (large / 2) ))
        
        self.addLine(to: CGPoint(x: position.x + (large / 2), y: position.y + (large / 2)))
        

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
