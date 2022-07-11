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
    @Published var computerGuess: Int?
    @Published var isWinner: Bool = false
    @Published var localCount: Int = 0
    
    private var cancelables: Set<AnyCancellable> = []
    var winner: Winner = .none
    var playerOneScore: Int = 0
    var playerTwoScore: Int = 0
 
    var winningNumber: Int = -10
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
        self.computerGuess = nil
    }
    
    func checkWinner() {
        let graceNumber = 1
        computerGuess = numberRange.randomElement() ?? 8008135
        
        $playerOneChosenNumber.combineLatest($playerTwoChosenNumber)
            .sink { [unowned self] p1guess , p2guess in
                let safeP1Guess = Int(p1guess) ?? -5
                let safeP2Guess = Int(p2guess) ?? -5
               
                
                if abs(safeP1Guess - winningNumber ) <= graceNumber && abs(safeP2Guess - winningNumber ) <= graceNumber {
                    self.winner = .both
                    isWinner = true
                } else if abs(safeP1Guess - winningNumber ) <= graceNumber {
                    self.winner = .playerOne
                    isWinner = true
                } else if abs(safeP2Guess - winningNumber ) <= graceNumber {
                    self.winner = .playerTwo
                    isWinner = true
                } else if computerGuess == winningNumber {
                    self.winner = .house
                    isWinner = true
                }
               

            }
            .store(in: &cancelables)
    }
    
    func timerAction() {
        pickRandomNumber()
        
        if localCount == 0 {
            winningNumber = displayNumber
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
            return " The winning number was \(winningNumber)\n Congrats \(winner.rawValue)!! you won!"
        }
    }
}
