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
                            Image(systemName: article.favourites ? "heart.fill" : "heart")
                                .font(.system(size: 28))
                                .padding(.trailing, 20)
                                .gesture(TapGesture().onEnded {
                                    if article.favourites {
                                        deleteItem(with: article.title ?? "")
                                    } else {
                                        addItem(title: article.title ?? "", urlImage: article.urlToImage ?? "", date: article.publishedAt ?? "", fav: article.favourites)
                                    }
                                    articles[index].favourites.toggle()
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
                loadData()
            }
            .navigationTitle("Новости")
        }
    }
    
    func addItem(title: String, urlImage: String, date: String, fav: Bool) {
        withAnimation {
            let newItem = News(context: viewContext)
            newItem.title = title
            newItem.date = date
            newItem.urlImage = urlImage
            newItem.favorites = true
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
        print("Добавлена")
    }
    
    func deleteItem(with title: String) {
        let fetchRequest: NSFetchRequest<News> = News.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@", title)

        guard let item = try? viewContext.fetch(fetchRequest).first else { return }

        viewContext.delete(item)

        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    func loadData() {
        NetworkManager().getArticles { articles in
            self.articles = articles.map { article in
                var modifiedArticle = article
                if let matchingItem = news.first(where: { $0.title == article.title }) {
                    modifiedArticle.favourites = matchingItem.favorites
                }
                return modifiedArticle
            }
        }
    }
}
