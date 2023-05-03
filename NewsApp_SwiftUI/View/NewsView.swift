//
//  NewsView.swift
//  NewsApp_SwiftUI
//
//  Created by Kristi on 03.05.2023.
//

import SwiftUI
import CoreData

struct NewsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \News.title, ascending: true)], animation: .default)
    private var news: FetchedResults<News>
    
    @State private var articles: [Articles] = []
    
    let dataManager: DataManager
    
    init(dataManager: DataManager) {
        self.dataManager = dataManager
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(articles.indices, id: \.self) { index in
                    let article = articles[index]
                    VStack(alignment: .leading) {
                        
                        TitleAndImageView(title: article.title ?? "", urlImage: article.urlToImage ?? "")
                        
                        HStack {
                            DateView(date: article.publishedAt ?? "")
                            Spacer()
                            Image(systemName:article.favorites ? "heart.fill" : "heart")
                                .font(.system(size: 28))
                                .padding(.trailing, 20)
                                .gesture(TapGesture().onEnded {
                                    interactionDataManager(favorites: article.favorites, title: article.title ?? "", urlImage: article.urlToImage ?? "", date: article.publishedAt ?? "")
                                    articles[index].favorites.toggle()
                                })
                        }
                    }
                    .padding()
                    .contentShape(Rectangle())
                    .onTapGesture {
                    }
                    .background(Color.white)
                }
            }
            .onAppear {
                dataManager.loadDataFromNetwork(items: news) { articles in
                    self.articles = articles
                }
            }
            .navigationTitle("Новости")
        }
    }
}

extension NewsView {
    private func interactionDataManager(favorites: Bool, title: String, urlImage: String, date: String) {
        if favorites {
            dataManager.deleteDataFromStorageByTitle(with: title)
        } else {
            dataManager.addDataToStorage(title: title, urlImage: urlImage, date: date, favorites: favorites)
        }
    }
}
