//
//  ChatViewDataModel.swift
//  ChatBot
//
//  Created by Carlos Silva on 11/11/2024.
//

import Foundation

struct ChatResponse: Codable {
    let id: String
    let object: String
    let created: Int
    let model: String
    let systemFingerprint: String?
    let choices: [Choice]

    enum CodingKeys: String, CodingKey {
        case id, object, created, model, choices
        case systemFingerprint = "system_fingerprint"
    }
}

struct Choice: Codable {
    let index: Int
    let delta: Delta?
    let logprobs: String?
    let finishReason: String?

    enum CodingKeys: String, CodingKey {
        case index, delta, logprobs
        case finishReason = "finish_reason"
    }
}

struct Delta: Codable {
    let role: String?
    let content: String?
}

struct Message: Identifiable {
    let id: UUID
    let role: String
    let content: String
}

class ChatViewDataModel: ObservableObject {
    @Published var enteredText = ""
    @Published var messages: [Message] = []
    @Published var processing = false
    @Published var error: String? = nil
    
    func clearEnteredText(){
        DispatchQueue.main.async {
            self.enteredText = ""
        }
    }
    
    func sendMessage() async {
        if(self.processing == true || self.enteredText.isEmpty){
            return;
        }
        DispatchQueue.main.async {
            self.error = nil
            self.processing = true
        }
        guard let url = URL(string: "http://192.168.0.234:1234/v1/chat/completions") else { return }
        
        var formattedMessages: [[String: String]] = messages.map { message in
            ["role": message.role, "content": message.content]
        }
        
        formattedMessages.append(["role": "user", "content": self.enteredText])

        let allMessages = systemMessages + formattedMessages
        
        
        let payload: [String: Any] = [
            "model": "llama-3.2-3b-instruct",
            "messages": allMessages,
            "stream": true,
            "temperature": 0.4
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: payload) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        do {
            let (stream, response) = try await URLSession.shared.bytes(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                DispatchQueue.main.async {
                    self.error = "Could not connect to the server."
                    self.processing = false
                }
                return
            }
            
            let messageId: UUID = UUID()
            DispatchQueue.main.async {
                self.messages.append((Message(id: UUID(), role: "user", content: self.enteredText)))
                self.clearEnteredText()
                self.messages.append(Message(id: messageId,role: "assistant", content: ""))
            }
            
            for try await line in stream.lines {
                let cleanedLine = line.replacingOccurrences(of: "data: ", with: "", options: .caseInsensitive)
                if let data = cleanedLine.data(using: .utf8) {
                    do {
                        let responseChunk = try JSONDecoder().decode(ChatResponse.self, from: data)
                        if let deltaContent = responseChunk.choices.first?.delta?.content {
                            DispatchQueue.main.async {
                                if let lastIndex = self.messages.lastIndex(where: { $0.role == "assistant" }) {
                                    var updatedMessage = self.messages[lastIndex].content
                                    updatedMessage += deltaContent
                                    self.messages[lastIndex] = Message(id: messageId, role: "assistant", content: updatedMessage)
                                }
                            }
                        }
                    } catch {}
                }
            }
            DispatchQueue.main.async {
                self.processing = false
            }
        } catch {
            DispatchQueue.main.async {
                self.error = error.localizedDescription;
                self.processing = false
            }
        }
    }
}
