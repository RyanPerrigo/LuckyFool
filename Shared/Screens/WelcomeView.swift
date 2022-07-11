//
//  WelcomeView.swift
//  LuckyFool (iOS)
//
//  Created by Ryan Perrigo on 6/20/22.
//

import SwiftUI

struct WelcomeView: View {
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                VStack(alignment: .center, spacing: 50){
                    Text("🤪")
                        .font(Font.system(size: 200))
                    Text("Welcome to Lucky Fool")
                        .multilineTextAlignment(.center)
                        .padding()
                        .font(.largeTitle)
                }
                Spacer()
                NavigationLink("Play Game") {
                    RandomImageScreen(viewModel: RandomImageVM(
                        numberRange: 1...10,
                        playerChosenNumber: "")
                    )
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(.orange)
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
