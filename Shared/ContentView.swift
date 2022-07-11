//
//  ContentView.swift
//  Shared
//
//  Created by Ryan Perrigo on 6/19/22.
//


import SwiftUI
import Combine


struct RandomImageScreen: View {
    
    @ObservedObject var viewModel: RandomImageVM
    
    
    var body: some View {
        VStack {
            scoreView
            mainBody
            HStack {
                Spacer()
            }
            .padding()
            .background(Color.red)
            
        }.alert(viewModel.getAlertString(), isPresented: $viewModel.isWinner) {
            Button("okay") {
                
                switch viewModel.winner {
                case .playerOne:
                    viewModel.playerOneScore += 10
                case .playerTwo:
                    viewModel.playerTwoScore += 10
                case .both:
                    viewModel.playerOneScore += 10
                    viewModel.playerTwoScore += 10
                case .house:
                    if viewModel.playerOneScore > 0 {
                        viewModel.playerOneScore -= 5
                    }
                    if viewModel.playerTwoScore > 0 {
                        viewModel.playerTwoScore -= 5
                    }
                case .none:
                    break
                }
                
                
                viewModel.winningNumber = -1
                viewModel.playerOneChosenNumber = ""
                viewModel.playerTwoChosenNumber = ""
                
                
                viewModel.isWinner = false
            }
        }
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        .navigationBarHidden(true)
    }
    
    private func playerScoreView(player: String, score: Int) -> some View {
        HStack{
            Text("Player " + player)
            Spacer()
            HStack{
                Text("Score :")
                Text("\(score)")
                    .foregroundColor(.white)
            }
        }
    }
    
    private var mainBody: some View {
        ScrollView{
            computerGuessView
            displayNumberView
            HStack {
                playerGuessView(
                    labelText: "Player one guess",
                    textFieldText: $viewModel.playerOneChosenNumber
                )
               Spacer()
                playerGuessView(
                    labelText: "Player Two guess",
                    textFieldText: $viewModel.playerTwoChosenNumber
                )
            }
            .padding()
            
            Spacer()
            
            Button(action: {
                viewModel.onGoClicked()
            }, label: {
                battleButtonView
            })
            .disabled(viewModel.buttonIsDisabled)
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(lineWidth: 1))
            .foregroundColor(.red)
            .padding()
        }
    }
    
    @ViewBuilder private var battleButtonView: some View {
        if viewModel.buttonIsDisabled {
            Text("Battle")
                .frame(width: 175)
                .padding()
                .background(.black.opacity(0.3))
                .cornerRadius(12)
        } else {
            Text("Battle")
                .frame(width: 175)
                .padding()
                .background(.black)
                .cornerRadius(12)
        }
    }
    
    private func playerGuessView(labelText: String, textFieldText: Binding<String>) -> some View {
        VStack(spacing: 20){
            Text(labelText)
            TextField("0", text: textFieldText)
                .padding()
                .frame(width: 50)
        }
    }
    
    private var displayNumberView: some View {
        VStack(alignment: .center){
            Text(String(viewModel.displayNumber))
                .frame(maxWidth: .infinity)
                .padding()
                .cornerRadius(12)
                .font(.system(size: 65))
                .onReceive(viewModel.timer) { timer in
                    if viewModel.localCount == 0 {
                        viewModel.timer.upstream.connect().cancel()
                    } else {
                        viewModel.timerAction()
                    }
                }
            Text("Pick a number")
                .padding()
        }
        .padding(.top, 50)
        .padding(.horizontal, 10)
    }
    
    private var computerGuessView: some View {
        VStack {
            Image("RobotImage")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 100)
                .cornerRadius(50)
                .shadow(color: .black, radius: 25, x: 0, y: 15)
                .padding()
            HStack {
                if let computerGuess = viewModel.computerGuess {
                    Text("Guess:")
                    Text("\(computerGuess)")
                }
                
            }
        }
    }
    
    private var scoreView: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack{
                NavigationLink {
                    WelcomeView()
                        .navigationBarHidden(true)
                } label: {
                    Text("Back")
                        .underline()
                        .foregroundColor(.white.opacity(0.7))
                }
            }
            playerScoreView(player: "1", score: viewModel.playerOneScore)
            playerScoreView(player: "2", score: viewModel.playerTwoScore)
        }
        .padding(.horizontal)
        .padding(.bottom)
        .background(.red)
    }
}

struct RandomImageScreen_Previews: PreviewProvider {
    static var previews: some View {
        RandomImageScreen(
            viewModel: RandomImageVM(
                numberRange: 1...10,
                playerChosenNumber: ""
            )
        )
    }
}
