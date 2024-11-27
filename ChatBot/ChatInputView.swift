//
//  ChatInputView.swift
//  ChatBot
//
//  Created by Carlos Silva on 14/11/2024.
//

import SwiftUI

struct ChatInputView: View {
    @ObservedObject var model: ChatViewDataModel

    var body: some View {
        HStack{
            TextField("How can we help you...", text: $model.enteredText)
                .textFieldStyle(.plain)
                .onSubmit {
                    Task {
                        await model.sendMessage()
                    }
                }
            Button(action: {
                Task {
                    await model.sendMessage()
                }
            }) {
                if(model.processing){
                    ProgressView()
                        .controlSize(.small)
                } else {
                    Image(systemName: "paperplane.fill")
                }
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.extraLarge)
            .padding(.trailing, 5)
            .padding(.bottom, 5)

        }
        .padding(10)
        .padding(.leading, 10)
        .background(.gray.opacity(0.1))
    }
}

#Preview {
    ChatInputView(model: ChatViewDataModel())
}
