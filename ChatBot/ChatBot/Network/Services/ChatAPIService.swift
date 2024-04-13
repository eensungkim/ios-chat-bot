//
//  ChatAPIService.swift
//  ChatBot
//
//  Created by EUNJU on 4/1/24.
//

import Foundation

import Alamofire
import RxAlamofire
import RxSwift

final class ChatAPIService {
    
    typealias API = ChatAPI
    
    private let provider = NetworkProvider<API>()
    
    func createChat(systemContent: String, userContent: String) -> Single<ChatResponseModel?> {
        return provider.request(.createChat(systemContent: systemContent, userContent: userContent))
    }
    
    func createChats(contents: [Message]) -> Single<ChatResponseModel?> {
        return provider.request(.createChats(contents: contents))
    }
}
