//
//  ErrorMesageView.swift
//  ChatBot
//
//  Created by Carlos Silva on 16/11/2024.
//

import SwiftUI

struct ErrorMesageView: View {
    let message: String

    var body: some View {
        Text(message)
            .padding(.horizontal)
            .padding(.vertical, 5)
            .background(.red)
            .cornerRadius(20.0)
    }
}

#Preview {
    ErrorMesageView(message: "Unable to connect")
        .padding()
}
