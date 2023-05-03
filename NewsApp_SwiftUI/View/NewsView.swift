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
                            Image(systemName: article.favorites ? "heart.fill" : "heart")
                                .font(.system(size: 28))
                                .padding(.trailing, 20)
                                .gesture(TapGesture().onEnded {
                                    if article.favorites {
                                        dataManager.deleteItem(with: article.title ?? "")
                                    } else {
                                        dataManager.addItem(title: article.title ?? "", urlImage: article.urlToImage ?? "", date: article.publishedAt ?? "", favorites: article.favorites)
                                    }
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
                dataManager.loadData(items: news) { articles in
                    self.articles = articles
                }
            }
            .navigationTitle("Новости")
        }
    }
}
