//
//  RandomImageVM.swift
//  LuckyFool (iOS)
//
//  Created by Ryan Perrigo on 6/19/22.
//

import SwiftUI
import Combine

enum Winner: String {
    case playerOne
    case playerTwo
    case both
    case house
    case none
}

class RandomImageVM: ObservableObject {
    @Published var displayNumber: Int = 0
    @Published var playerOneChosenNumber: String
    @Published var playerTwoChosenNumber: String
    @Published var isWinner: Bool = false
    @Published var localCount: Int = 0
    
    private var cancelables: Set<AnyCancellable> = []
    var winner: Winner = .none
    var playerOneScore: Int = 0
    var playerTwoScore: Int = 0
    var roundFinished: Bool = false
    var winningNumber: Int = -1
    var numberRange: ClosedRange<Int>
    var count = 18
    var timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()
    
    var buttonIsDisabled: Bool {
        playerOneChosenNumber.isEmpty || playerTwoChosenNumber.isEmpty
    }
    
    init(numberRange: ClosedRange<Int>, playerChosenNumber: String) {
        self.numberRange = numberRange
        self.playerOneChosenNumber = ""
        self.playerTwoChosenNumber = ""
    }
    
    func checkWinner() {
        let graceNumber = 1
        
        $playerOneChosenNumber.combineLatest($playerTwoChosenNumber)
            .sink { [unowned self] p1guess , p2guess in
                let safeP1Guess = Int(p1guess) ?? -5
                let safeP2Guess = Int(p2guess) ?? -5
                let upperP1Range = safeP1Guess ... (safeP1Guess + graceNumber)
                let lowerP1Range = (safeP1Guess - graceNumber) ... safeP1Guess
                let upperP2Range = safeP2Guess ... (safeP2Guess + graceNumber)
                let lowerP2Range = (safeP2Guess - graceNumber) ... safeP2Guess
                
                if roundFinished {
                    winningNumber = displayNumber

                  
                    if !upperP1Range.contains(winningNumber) || !lowerP1Range.contains(winningNumber) && !upperP2Range.contains(winningNumber) || !lowerP2Range.contains(winningNumber) {
                        self.winner = .house
                        isWinner = true
                    }
                    if upperP1Range.contains(winningNumber) || lowerP1Range.contains(winningNumber) && upperP2Range.contains(winningNumber) || lowerP2Range.contains(winningNumber) {
                        self.winner = .both
                        isWinner = true
                        
                    }
                    if upperP1Range.contains(winningNumber) || lowerP1Range.contains(winningNumber) {
                        self.winner = .playerOne
                        isWinner = true
                       
                    }
                    if upperP2Range.contains(winningNumber) || lowerP2Range.contains(winningNumber) {
                        self.winner = .playerTwo
                        isWinner = true
                    }
                }
            }
            .store(in: &cancelables)
    }
    
    func timerAction() {
        pickRandomNumber()
        
        if localCount == 0 {
            roundFinished = true
            checkWinner()
            cancelables.removeAll()
        }
    }
    
    func pickRandomNumber() {
            localCount -= 1
            let randomNumber = self.numberRange.randomElement() ?? 8008135
            self.displayNumber = randomNumber
    }
    
    func onGoClicked() {
        if localCount <= 0 {
            localCount = count
        }
        self.timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()
        
    }
    
    func getAlertString() -> String {
        if winner == .house {
            return "You couldn't beat the house! Don't worry, you'll get 'em next time!"
        } else {
            return "Congrats \(winner.rawValue)!! you won!"
        }
    }
}
