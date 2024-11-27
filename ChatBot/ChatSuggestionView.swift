//
//  ChatSuggestionView.swift
//  ChatBot
//
//  Created by Carlos Silva on 15/11/2024.
//

import SwiftUI

struct ChatSuggestionView: View {
    let message: String
    @ObservedObject var model: ChatViewDataModel
    
    func sendSuggestion() {
        model.enteredText = message
        Task {
            await model.sendMessage()
        }
    }
    
    var body: some View {
        Button(action: sendSuggestion){
            Text(message)
                .padding(.vertical, 6)
                .padding(.horizontal, 10)
                .font(.caption)
                .fontWeight(.bold)
        }
        .buttonStyle(.borderedProminent)
        .cornerRadius(20.0)
    }
}

#Preview {
    ChatSuggestionView(message: "Why is my package delayed?", model: ChatViewDataModel())
        .padding()
}
