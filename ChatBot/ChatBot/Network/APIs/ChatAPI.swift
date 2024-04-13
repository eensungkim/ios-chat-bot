//
//  ChatAPI.swift
//  ChatBot
//
//  Created by EUNJU on 4/1/24.
//

import Alamofire

enum ChatAPI {
    case createChat(systemContent: String, userContent: String)
    case createChats(contents: [Message])
}

extension ChatAPI: BaseAPI {
    
    var urlPath: String {
        switch self {
        case .createChat(_, _), .createChats(_):
            return "/v1/chat/completions"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .createChat, .createChats(_):
            return .post
        }
    }
    
    var parameters: RequestParameter {
        switch self {
        case .createChat(let systemContent, let userContent):
            let body = ChatRequestModel(model: GPTModelFamilies.main.rawValue,
                                         messages: [
                                            Message(role: .system,
                                                    content: systemContent),
                                            Message(role: .user,
                                                    content: userContent)
                                         ])
            return .requestBody(body)
        case .createChats(let contents):
            let body = ChatRequestModel(
                model: GPTModelFamilies.main.rawValue,
                messages: contents)
            return .requestBody(body)
        }
    }
}
