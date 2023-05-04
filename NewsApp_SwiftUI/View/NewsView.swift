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
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \News.title, ascending: true)],
                  animation: .default)
    
    private var news: FetchedResults<News>
    
    @ObservedObject var viewModel: NewsViewModel
    
    init(dataManager: DataManager) {
        self.viewModel = NewsViewModel(dataManager: dataManager)
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.articles.indices, id: \.self) { index in
                    let article = viewModel.articles[index]
                    VStack(alignment: .leading) {
                        
                        TitleAndImageView(title: article.title ?? "",
                                          urlImage: article.urlToImage ?? "")
                        
                        HStack {
                            DateView(date: article.publishedAt ?? "")
                            Spacer()
                            Image(systemName:article.favorites ? "heart.fill" : "heart")
                                .font(.system(size: 28))
                                .padding(.trailing, 20)
                                .gesture(TapGesture().onEnded {
                                    viewModel.interactionDataManager(favorites: article.favorites,
                                                                     title: article.title ?? "",
                                                                     urlImage: article.urlToImage ?? "",
                                                                     date: article.publishedAt ?? "")
                                    viewModel.articles[index].favorites.toggle()
                                })
                        }
                    }
                    .padding()
                    .contentShape(Rectangle())
                    .background(Color.white)
                }
            }
            .onAppear {
                viewModel.loadDataFromNetwork(items: news)
            }
            .navigationTitle("Новости")
        }
    }
}
