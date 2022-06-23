//
//  LinePath.swift
//  gato
//
//  Created by Gerardo on 26/04/22.
//

import UIKit

class LinePath: UIBezierPath {
    required init(pos1: CGPoint, pos2: CGPoint) {
        super.init()
        self.move(to: pos1)
        self.addLine(to: pos2)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
