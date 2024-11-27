//
//  ChatAssistantMessageView.swift
//  ChatBot
//
//  Created by Carlos Silva on 14/11/2024.
//

import SwiftUI
import MarkdownUI

struct ChatAssistantMessageView: View {
    let message: String
    var body: some View {
        HStack{
            VStack(alignment: .leading){
                Text("Assistant")
                    .fontWeight(.bold)
                Markdown(message)
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10.0)
            Spacer()
        }
        .padding(.trailing, 20)
    }
}

#Preview {
    ScrollView{
        ChatAssistantMessageView(message: """
        Lorem markdownum senilem an medium refeci letum at mittor vittas summa armenta. Mihi adflatuque isse tot sententia; latus post ergo Phoebus! Gregibus captaeque virgine, vultus fluctus locum, et **multa redimitus denique** lambit minata animoque, **felix**. Sidonis, mirarique tamen, esse sine?
        """)
        .padding()
    }
}
