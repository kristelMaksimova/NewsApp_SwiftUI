//
//  NetworkManager.swift
//  NewsApp_SwiftUI
//
//  Created by Kristi on 03.05.2023.
//

import Foundation
import SwiftUI

// Cсылка иногда не срабатывает и данные могут не отобразиться, это решается новой ссылкой 
enum Link: String {
    
    case link = "https://newsapi.org/v2/everything?q=tesla&from=2023-04-03&sortBy=publishedAt&apiKey=37eeec7e4c0f4bba8215989f3e6cef32"
}


class NetworkManager {

    func getArticles(completion: @escaping ([Articles]) -> ()) {
        guard let url = URL(string: Link.link.rawValue) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            
            do {
                let posts = try JSONDecoder().decode(Post.self, from: data!)
                DispatchQueue.main.async {
                    completion(posts.articles)
                }
            } catch {
                print("Error decoding data: \(error)")

                DispatchQueue.main.async {
                    completion([])
                }
            }
        }
        .resume()
    }
}

