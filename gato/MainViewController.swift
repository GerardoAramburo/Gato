//
//  ViewController.swift
//  gato
//
//  Created by Gerardo on 05/04/22.
//

import UIKit
import SpriteKit
class MainViewController: UIViewController, GatoViewDelegate {
    
    @IBOutlet weak var circleScoreLabel: UILabel!
    @IBOutlet weak var crossesScoreLabel: UILabel!
    @IBOutlet weak var GView: GatoView!
    
    private var circlesScore = 0
    private var crossesScore = 0
    
    static let circlesScoreKey = "circle_score"
    static let crossScoreKey = "cross_score"
    
    public var gameType: Int! //1->1 player, 2->2 players
    
    let fGenerator = UINotificationFeedbackGenerator() //Haptics
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadDefaults()
        GView.gameType = self.gameType
        GView.setDelegate(self)
        view.backgroundColor = .systemBackground
    }
    
    func loadDefaults() {
        self.setCirclesScore(score: UserDefaults.standard.integer(forKey: Self.circlesScoreKey))

        self.setCrossesScore(score: UserDefaults.standard.integer(forKey: Self.crossScoreKey))
        
    }
    
    @IBAction func resetClicked(_ sender: Any) {
        GView.resetGame()
        GView.setNeedsDisplay()
    }
    
    @IBAction func resetScoreClicked(_sender: Any) {
        resetScore()
    }
 
    func gameEnded(result: Int) {
        var winner = "Empate"
        if result == 1 {
            setCirclesScore(score: getCirclesScore() + 1)
            winner = "Circulos han ganado"
        } else if result == 2 {
            setCrossesScore(score: getCrossesScore() + 1)
            winner = "Cruces han ganado"
        }
    
        let actions = UIAlertController(title: "Fin", message: winner, preferredStyle: .alert)
        let action = UIAlertAction(title: "Jugar de nuevo", style: .default) {[weak self] _ in
            self?.GView.resetGame()
            self?.GView.setNeedsDisplay()
        }
        actions.addAction(action)
        
        fGenerator.notificationOccurred(.success)
        
        saveScore()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: { [weak self] in
            self?.present(actions, animated: true)
        })
        
    }
    
    func setCirclesScore(score: Int) {
        self.circlesScore = score
        circleScoreLabel.text = "Circles: " + String(score)
        print("Set")
    }
    
    
    func getCirclesScore() -> Int {
        return self.circlesScore
    }
    
    func setCrossesScore(score: Int) {
        self.crossesScore = score
        crossesScoreLabel.text = "Crosses:  " + String(score)
    }
    
    func getCrossesScore() -> Int {
        return self.crossesScore
    }
    
    func saveScore() {
        
        UserDefaults.standard.set(getCirclesScore(), forKey: Self.circlesScoreKey)
        UserDefaults.standard.set(getCrossesScore(), forKey: Self.crossScoreKey)
        
        print(getCirclesScore())
    }
    
    func resetScore() {
        UserDefaults.standard.set(0, forKey: Self.circlesScoreKey)
        UserDefaults.standard.set(0, forKey: Self.crossScoreKey)
        
        setCirclesScore(score: 0)
        setCrossesScore(score: 0)
    }
}
