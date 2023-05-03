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
    
    func addItem(title: String, urlImage: String, date: String, favorites: Bool) {
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
    
    func loadData(items: FetchedResults<News>, completion: @escaping ([Articles]) -> ()) {
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
}
