//
//  FavoritesNewsViewModel.swift
//  NewsApp_SwiftUI
//
//  Created by Kristi on 04.05.2023.
//

import CoreData
import SwiftUI

class FavoritesNewsViewModel: ObservableObject {
    
    private let dataManager: DataManager
   
    @Published var news: [News] = []
    
    init(dataManager: DataManager) {
        self.dataManager = dataManager
        loadData()
    }
    
    func deleteDataFromStorageByIndex(offsets: IndexSet) {
        withAnimation {
            offsets.map { news[$0] }.forEach { news in
                dataManager.deleteData(news: news)
            }
        }
    }
    
    func loadData() {
        dataManager.loadDataFromStorage() { news in
            self.news = news
        }
    }
}
