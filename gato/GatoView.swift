//
//  GatoView.swift
//  gato
//
//  Created by Gerardo on 06/04/22.
//

import UIKit
import AVFoundation

class GatoView: UIView {
    private var circles = [CAShapeLayer]()
    private var crosses = [CAShapeLayer]()
    private var winLine = CAShapeLayer()
    private var tColor = UIColor.blue
    private var sColor = UIColor.label
    private let lineWidth = CGFloat(10)
    private var game = [ [0, 0, 0],
                         [0, 0, 0],
                         [0, 0, 0] ] //Show the state of each cell(taken or available)
                            
    private var c = Bool.random()
    private var playerTurn = true // is player turn
    private var delegate: GatoViewDelegate?
    private var audioPlayer: AVAudioPlayer?
    
    public var gameType: Int! //1 -> 1 player(generate rival inputs), 2 -> 2 player
    
    
    override func draw(_ rect: CGRect) {
        print("Drawed")
        
        tColor.setStroke()
        let path = generatePath(frame: self.frame)
        path.stroke()
    }
    
    func getSColor() -> UIColor {
        return self.sColor
    }
    
    func getTColor() -> UIColor {
        return self.tColor
    }
    
    func setSColor(sColor: UIColor) {
        self.sColor = sColor
    }
    
    func setTColor(tColor: UIColor) {
        self.tColor = tColor
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchedPoint = touches.first!.location(in: self)
        
        var nPoint = CGPoint()
        
        let thirdWidth = self.frame.width / 3
        
        var mDistance = Double.infinity
        
        for i in 0..<3 {
            for j in 0..<3 {
                let p = CGPoint(x: (CGFloat(j) * thirdWidth) + (thirdWidth / 2), y: ((CGFloat(i) * thirdWidth) + (thirdWidth / 2)))
                
                
                let d = distance(p1: p, p2: touchedPoint)

                if d < mDistance {
                    mDistance = d
                    nPoint = p
                }
            }
        }
        
        
        self.playShapeDrawed()
        
        let xTaken = Int(nPoint.x / (self.frame.size.width / 3))
        let yTaken = Int(nPoint.y / (self.frame.size.height / 3))
        
        if game[yTaken][xTaken] == 0 && !isEnded() && playerTurn {
            if c {
                let circlePath = CirclePath(ovalIn: CGRect(x: nPoint.x, y: nPoint.y, width: 65, height: 65))
                var newPostition = [[0, 0, 0],
                                    [0, 0, 0],
                                    [0, 0, 0]]

                newPostition[xTaken][yTaken] = 1
                circlePath.lineWidth = 10
                //self.circles.append(circlePath)
                game[yTaken][xTaken] = 1
                
                let layer = CAShapeLayer()
                layer.path = circlePath.cgPath
                layer.fillColor = UIColor.clear.cgColor
                layer.strokeColor = sColor.cgColor
                layer.lineWidth = lineWidth
            
                self.layer.addSublayer(layer)
                self.circles.append(layer)
                animate(layer: layer, duration: 0.3)
            } else {
                let crossPath = CrossPath(large: 65, position: nPoint)
                var newPostition = [[0, 0, 0],
                                    [0, 0, 0],
                                    [0, 0, 0]]

                newPostition[xTaken][yTaken] = 1
                crossPath.lineWidth = lineWidth
                //self.crosses.append(crossPath)
                game[yTaken][xTaken] = 2
                
                let layer = CAShapeLayer()
                layer.path = crossPath.cgPath
                layer.fillColor = UIColor.clear.cgColor
                layer.strokeColor = sColor.cgColor
                layer.lineWidth = lineWidth
                
                self.layer.addSublayer(layer)
                animate(layer: layer, duration: 0.3)
                self.crosses.append(layer)
            }

            
            if isEnded() {
                print("Ended")
                let winner = getWinner()
                if winner == 1 {
                    print("Circles won")
                } else if getWinner() == 2 {
                    print("Crosses won")
                } else {
                    print("Draw")
                }
                
                self.delegate?.gameEnded(result: winner)
            } else if gameType == 1 { //Generate random move
                var i = Int.random(in: 0..<3)
                var j = Int.random(in: 0..<3)
                
                while (game[j][i] != 0) {
                    i = Int.random(in: 0..<3)
                    j = Int.random(in: 0..<3)
                }
                let pos = indexToPosition(i: i, j: j)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: { [weak self] in
                    if self!.c {
                        let circlePath = CirclePath(ovalIn: CGRect(x: pos.x, y: pos
                            .y, width: 65, height: 65))
                        var newPostition = [[0, 0, 0],
                                            [0, 0, 0],
                                            [0, 0, 0]]

                        newPostition[xTaken][yTaken] = 1
                        circlePath.lineWidth = 10
                        
                        let layer = CAShapeLayer()
                        layer.path = circlePath.cgPath
                        layer.fillColor = UIColor.clear.cgColor
                        layer.strokeColor = self?.sColor.cgColor ?? UIColor.black.cgColor
                        layer.lineWidth = self?.lineWidth ?? 10
                        
                        self?.layer.addSublayer(layer)
                        self?.animate(layer: layer, duration: 0.3)
                        self?.circles.append(layer)
                        
                        self!.game[j][i] = 1

                    } else {
                        let crossPath = CrossPath(large: 65, position: pos)
                        var newPostition = [[0, 0, 0],
                                            [0, 0, 0],
                                            [0, 0, 0]]

                        newPostition[xTaken][yTaken] = 1
                        crossPath.lineWidth = self?.lineWidth ?? 1
                        let layer = CAShapeLayer()
                        layer.path = crossPath.cgPath
                        layer.fillColor = UIColor.clear.cgColor
                        layer.strokeColor = self?.sColor.cgColor ?? UIColor.black.cgColor
                        layer.lineWidth = self?.lineWidth ?? 10
                        
                        self?.layer.addSublayer(layer)
                        self?.animate(layer: layer, duration: 0.3)
                        self?.crosses.append(layer)
                        self!.game[j][i] = 2
                    }
                    self?.playShapeDrawed()
                    self?.setNeedsDisplay()
                    self?.playerTurn = true
                    self?.c.toggle()

                    
                    if self!.isEnded() {
                        print("Ended")
                        let winner = self?.getWinner()
                        if winner == 1 {
                            print("Circles won")
                        } else if winner == 2 {
                            print("Crosses won")
                        } else {
                            print("Draw")
                        }
                        
                        self?.delegate?.gameEnded(result: winner!)
                    }
                })
                playerTurn = false
            }
            c.toggle()
            self.setNeedsDisplay()
        } else {
            print("Not your turn")
        }
    }
    
    
    func isEnded() -> Bool {
        return areAllCellTaken() || getWinner() >= 0
    }
    
    func areAllCellTaken() -> Bool{
        return game.allSatisfy { r in
            return r.allSatisfy { c in
                c > 0
            }
        }
    }
    
    func generatePath(frame: CGRect) -> UIBezierPath {
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: frame.width / 3, y: 0.0))

        path.addLine(to: CGPoint(x: frame.width / 3, y: frame.size.height))

        path.move(to: CGPoint(x: 2 * (frame.size.width / 3), y: 0))
        
        path.addLine(to: CGPoint(x: 2 * (frame.size.width / 3), y: frame.size.height))

        path.move(to: CGPoint(x: 0, y: frame.size.height / 3))
        
        path.addLine(to: CGPoint(x: frame.width, y: frame.size.height / 3))
        
        path.move(to: CGPoint(x: 0, y: 2 * (frame.height / 3)))
        
        path.addLine(to: CGPoint(x: frame.width, y: 2 * (frame.size.height / 3)))
        
        path.lineWidth = lineWidth
        return path
    }
    
    func getWinner() -> Int { // -1 -> not ended yet, 0 -> draw, 1 -> circles, 2 -> crosses
        for i in 0..<3 { // Horizontaly
            let row = game[i]
            var circlesCount = 0
            var crossCount = 0

            for cell in row {
                if cell == 1 {
                    circlesCount += 1
                } else if cell == 2 {
                    crossCount += 1
                }
            }
            if circlesCount == 3 {
                generateLine(i1: 0, j1: i, i2: 2, j2: i)
                return 1
            } else if crossCount == 3 {
                generateLine(i1: 0, j1: i, i2: 2, j2: i)
                return 2
            }
        }
        
        for i in 0..<3 { //Vertically
            var circlesCount = 0
            var crossCount = 0
            
            for j in 0..<3 {
                let cell = game[j][i]
                if cell == 1 {
                    circlesCount += 1
                } else if cell == 2 {
                    crossCount += 1
                }
            }
            
            if circlesCount == 3 {
                generateLine(i1: i, j1: 0, i2: i, j2: 2)
                return 1
            } else if crossCount == 3 {
                generateLine(i1: i, j1: 0, i2: i, j2: 2)
                return 2
            }
        }
        
        var crossesCount = 0
        var circlesCount = 0

        for i in 0..<3 { // Diagonally /
            let val = game[i][-1 * (i - 2)]
            
            if (val == 1) {
                circlesCount += 1
            } else if val == 2 {
                crossesCount += 1
            }
        }
        
        if circlesCount == 3 {
            generateLine(i1: 0, j1: 2, i2: 2, j2: 0)
            return 1
        } else if crossesCount == 3 {
            generateLine(i1: 0, j1: 2, i2: 2, j2: 0)
            return 2
        }
        
        crossesCount = 0
        circlesCount = 0
        
        for i in 0..<3 { // Diagonally \
            let val = game[i][i]
            
            if (val == 1) {
                circlesCount += 1
            } else if val == 2 {
                crossesCount += 1
            }
        }
        
        if circlesCount == 3 {
            generateLine(i1: 0, j1: 0, i2: 2, j2: 2)
            return 1
        } else if crossesCount == 3 {
            generateLine(i1: 0, j1: 0, i2: 2, j2: 2)

            return 2
        }
        
        
        return areAllCellTaken() ? 0 : -1
    }
    
    func generateLine(i1: Int, j1: Int, i2: Int, j2: Int) {
        let thirdWidth = self.frame.width / 3

        var p1 = CGPoint()
        var p2 = CGPoint()
        if j1 == j2 {
            p1 = CGPoint(x: (CGFloat(i1) * thirdWidth), y: ((CGFloat(j1) * thirdWidth) + (thirdWidth / 2)))
            p2 = CGPoint(x: (CGFloat(i2) * thirdWidth) + (thirdWidth), y: ((CGFloat(j2) * thirdWidth) + (thirdWidth / 2)))
        } else if i1 == i2 {
            p1 = CGPoint(x: (CGFloat(i1) * thirdWidth) + (thirdWidth / 2), y: ((CGFloat(j1) * thirdWidth)))
            p2 = CGPoint(x: (CGFloat(i2) * thirdWidth) + (thirdWidth / 2), y: ((CGFloat(j2) * thirdWidth) + (thirdWidth)))
        } else if i1 != j2 {
            p1 = CGPoint(x: (CGFloat(i1) * thirdWidth), y: ((CGFloat(j1) * thirdWidth)))
            p2 = CGPoint(x: (CGFloat(i2) * thirdWidth) + (thirdWidth), y: ((CGFloat(j2) * thirdWidth) + (thirdWidth)))
        } else {
            p1 = CGPoint(x: (CGFloat(i1) * thirdWidth), y: ((CGFloat(j1) * thirdWidth)) + (thirdWidth))
            p2 = CGPoint(x: (CGFloat(i2) * thirdWidth) + thirdWidth, y: ((CGFloat(j2) * thirdWidth) ))
        }
        
        let linePath = LinePath(pos1: p1, pos2: p2).cgPath
        
        winLine.path = linePath
        winLine.lineWidth = self.lineWidth * 1.5
        winLine.strokeColor = sColor.cgColor
        
        self.layer.addSublayer(winLine)
        
        animate(layer: winLine, duration: 0.5)
        
    }
    func distance(p1: CGPoint, p2: CGPoint) -> Double {
        return sqrt(pow((p2.y - p1.y) * (p2.x - p1.x), 2) )
    }
    
    func resetGame() {
        for circle in circles {
            circle.removeFromSuperlayer()
        }
        
        for cross in crosses {
            cross.removeFromSuperlayer()
        }
        
        self.circles.removeAll()
        self.crosses.removeAll()
        winLine.removeFromSuperlayer()
        
        self.layer.removeAllAnimations()
        
        self.game = [ [0, 0, 0],
                      [0, 0, 0],
                      [0, 0, 0] ]
        self.playerTurn = true
    }
    
    func indexToPosition(i: Int, j: Int) -> CGPoint {
        let thirdWidth = self.frame.width / 3
        return CGPoint(x: (CGFloat(i) * thirdWidth) + (thirdWidth / 2), y: ((CGFloat(j) * thirdWidth) + (thirdWidth / 2)))
    }
    func playShapeDrawed() {
        let path = Bundle.main.path(forResource: "pencil.wav", ofType: nil)!
        let url = URL(fileURLWithPath: path)
        audioPlayer = try! AVAudioPlayer(contentsOf: url)
        audioPlayer!.play()
    }
    func setDelegate(_ delegate: GatoViewDelegate) {
        self.delegate = delegate
    }
    
    func getDelegate() -> GatoViewDelegate? {
        return self.delegate
    }
    
    func animate(layer: CAShapeLayer, duration: Double) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = duration
        layer.add(animation, forKey: "line")
    }
}
