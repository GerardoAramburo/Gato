//
//  mViewController.swift
//  gato
//
//  Created by Gerardo on 29/04/22.
//

import UIKit

class MenuViewController: UIViewController {

    @IBAction func onePlayerBtnTouched(_ sender: Any) {
        let mainViewController = storyboard?.instantiateViewController(withIdentifier: "mainViewController") as! MainViewController
        mainViewController.gameType = 1
        navigationController?.pushViewController(mainViewController, animated: true)
        print("1 player selected")
    }
    @IBAction func towPlayersBtnToched(_ sender: Any) {
        let mainViewController = storyboard?.instantiateViewController(withIdentifier: "mainViewController") as! MainViewController
        mainViewController.gameType = 2
        navigationController!.pushViewController(mainViewController, animated: true)
        print("2 players selected")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
