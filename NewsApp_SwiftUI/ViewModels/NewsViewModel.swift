//
//  NewsViewModel.swift
//  NewsApp_SwiftUI
//
//  Created by Kristi on 04.05.2023.
//

import Foundation
import CoreData
import SwiftUI

class NewsViewModel: ObservableObject {
    private let dataManager: DataManager
    
    init(dataManager: DataManager) {
        self.dataManager = dataManager
    }
    
    @Published var articles: [Articles] = []
    
    func loadDataFromNetwork(items: FetchedResults<News>) {
        dataManager.loadDataFromNetwork(items: items) { articles in
            DispatchQueue.main.async {
                self.articles = articles
            }
        }
    }
    
    func interactionDataManager(favorites: Bool, title: String, urlImage: String, date: String) {
        if favorites {
            dataManager.deleteDataFromStorageByTitle(with: title)
        } else {
            dataManager.addDataToStorage(title: title, urlImage: urlImage, date: date, favorites: favorites)
        }
    }
}
