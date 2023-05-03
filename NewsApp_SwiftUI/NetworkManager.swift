//
//  NetworkManager.swift
//  NewsApp_SwiftUI
//
//  Created by Kristi on 03.05.2023.
//

import Foundation

enum NetworkError: Error {
    case decodingError
    case invalidURL
    case noData
}

struct Post: Codable, Identifiable {
    let id = UUID()
    let articles: [Articles]
    
}
struct Articles: Codable, Identifiable {
    
    let id = UUID()
    let title: String?
    let urlToImage: String?
    let publishedAt: String?
    var favourites = false
    
    enum CodingKeys: String, CodingKey {
           case title
           case urlToImage
           case publishedAt
       }
}

class NetworkManager {
    
    func getArticles(completion: @escaping ([Articles]) -> ()) {
        guard let url = URL(string: "https://newsapi.org/v2/everything?q=tesla&from=2023-04-03&sortBy=publishedAt&apiKey=37eeec7e4c0f4bba8215989f3e6cef32") else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            
          
            let posts = try! JSONDecoder().decode(Post.self, from: data!)
            
            DispatchQueue.main.async {
                completion(posts.articles)
            }
        }
        .resume()
    }
}

