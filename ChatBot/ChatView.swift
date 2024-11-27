//
//  ChatView.swift
//  ChatBot
//
//  Created by Carlos Silva on 11/11/2024.
//

import SwiftUI

struct ChatView: View {
    @StateObject private var model = ChatViewDataModel()

    var body: some View {
        VStack(spacing: 0){
            ScrollViewReader { scrollViewProxy in
                ScrollView{
                    if (model.messages.isEmpty) {
                        Image("Chat")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100)
                            .padding(.top, 50)
                    }
                    if let message = model.error {
                        ErrorMesageView(message: message)
                    }
                    VStack{
                        ForEach(model.messages) { message in
                            if(message.role == "user"){
                                ChatUserMessageView(message: message.content)
                                    .id(message.id)
                            } else {
                                ChatAssistantMessageView(message: message.content)
                                    .id(message.id)
                            }
                        }
                    }
                    .padding()
                    .onChange(of: model.messages.last?.content.count) {
                        withAnimation {
                            if let lastMessage = model.messages.last {
                                scrollViewProxy.scrollTo(lastMessage.id, anchor: .bottom)
                            }
                        }
                    }
                }
            }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack{
                    ForEach(suggestions, id: \.self){ suggestion in
                        ChatSuggestionView(message: suggestion, model: model)
                    }
                }
                .padding(8)
            }
            .background(.gray.opacity(0.1))
            
            Divider()
            
            ChatInputView(model: model)
        }
    }
}

#Preview {
    ChatView()
}
