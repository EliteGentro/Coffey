//
//  ContentViewModel.swift
//  Coffey
//
//  Created by Humberto Genaro Cisneros Salinas on 05/11/25.
//

import Foundation
import Combine
import FoundationModels

@Observable
class ContentViewModel: ObservableObject{
    var arrContents = [Content]()
    private var session: LanguageModelSession = LanguageModelSession()
    private let baseURL = "https://coffey-api.vercel.app/content"
    
    func getContents() async throws {
        guard let url = URL(string: "\(baseURL)")
        else{
            print("Invalid URL")
            return
        }
        //Request
        let urlRequest = URLRequest(url: url)
        
        //Llamar HTTP
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            print("Error")
            return
        }
        
        let results = try JSONDecoder().decode([Content].self, from:data)
        self.arrContents = results
    }
}
