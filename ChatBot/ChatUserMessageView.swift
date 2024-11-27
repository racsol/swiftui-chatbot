//
//  ChatMessageView.swift
//  ChatBot
//
//  Created by Carlos Silva on 13/11/2024.
//

import SwiftUI
import MarkdownUI

struct ChatUserMessageView: View {
    let message: String
    
    var body: some View {
        HStack{
            Spacer()
            VStack(alignment: .leading){
                Markdown(message)
                    .markdownTextStyle(\.text) {
                        ForegroundColor(Color.white)
                    }
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            .background(Color.accentColor)
            .cornerRadius(10.0)
        }

    }
}

#Preview {
    ScrollView{
        ChatUserMessageView(message: """
    Lorem markdownum senilem an medium refeci letum at mittor vittas summa armenta. Mihi adflatuque isse tot sententia; latus post ergo Phoebus! Gregibus captaeque virgine, vultus fluctus locum, et **multa redimitus denique** lambit minata animoque, **felix**. Sidonis, mirarique tamen, esse sine?
    """)
        .padding()
    }
}
