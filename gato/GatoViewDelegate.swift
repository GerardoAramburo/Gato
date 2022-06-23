//
//  GatoViewDelegate.swift
//  gato
//
//  Created by Gerardo on 26/04/22
//

import Foundation


protocol GatoViewDelegate {
    //result -> 0-draw, 1-circles, 2-crosses
    func gameEnded(result: Int)
}
