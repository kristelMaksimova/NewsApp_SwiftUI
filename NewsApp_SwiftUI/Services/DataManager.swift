//
//  DataManager.swift
//  NewsApp_SwiftUI
//
//  Created by Kristi on 03.05.2023.
//

import Foundation
import CoreData
import SwiftUI

class DataManager {
    private let viewContext: NSManagedObjectContext
    
    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
    }
    
    func loadDataFromNetwork(items: FetchedResults<News>, completion: @escaping ([Articles]) -> ()) {
        NetworkManager().getArticles { articles in
            let modifiedArticles = articles.map { article in
                var modifiedArticle = article
                if let matchingItem = items.first(where: { $0.title == article.title }) {
                    modifiedArticle.favorites = matchingItem.favorites
                }
                return modifiedArticle
            }
            completion(modifiedArticles)
        }
    }
    
    func loadDataFromStorage(completion: @escaping ([News]) -> Void) {
        let request: NSFetchRequest<News> = News.fetchRequest()
        do {
            let items = try viewContext.fetch(request)
            completion(items)
        } catch let error {
            print("Error fetching items: \(error.localizedDescription)")
        }
    }
    
    func addDataToStorage(title: String, urlImage: String, date: String, favorites: Bool) {
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
    }
    
    func deleteDataFromStorageByTitle(with title: String) {
        let fetchRequest: NSFetchRequest<News> = News.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@", title)
        
        guard let news = try? viewContext.fetch(fetchRequest).first else { return }
        
        deleteData(news: news)
    }
    
    func deleteData(news: News) {
        viewContext.delete(news)
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
