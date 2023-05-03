//
//  favoritesView.swift
//  NewsApp_SwiftUI
//
//  Created by Kristi on 03.05.2023.
//
import SwiftUI
import CoreData

struct FavoritesNewsView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var news: [News] = []
    
    let dataManager: DataManager
    
    init(dataManager: DataManager) {
        self.dataManager = dataManager
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(news) { article in
                    VStack {
                        TitleAndImageView(title: article.title ?? "", urlImage: article.urlImage ?? "")
                        
                        HStack {
                            DateView(date: article.date ?? "")
                        }
                    }
                }
                .onDelete(perform: deleteDataFromStorageByIndex)
                .padding()
            }
            .navigationTitle("Избранные")
            .onAppear {
                dataManager.loadDataFromStorage() { news in
                    self.news = news
                }
            }
        }
    }
    
    func deleteDataFromStorageByIndex(offsets: IndexSet) {
        withAnimation {
            offsets.map { news[$0] }.forEach { news in
                dataManager.deleteData(news: news)
            }
        }
    }
}
