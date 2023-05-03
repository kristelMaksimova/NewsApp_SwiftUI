//
//  News.swift
//  NewsApp_SwiftUI
//
//  Created by Kristi on 03.05.2023.
//

import Foundation

struct Post: Codable, Identifiable {
    let id = UUID()
    let articles: [Articles]
    
}
struct Articles: Codable, Identifiable {
    
    let id = UUID()
    let title: String?
    let urlToImage: String?
    let publishedAt: String?
    var favorites = false
    
    enum CodingKeys: String, CodingKey {
       
        case title
        case urlToImage
        case publishedAt
    }
}
