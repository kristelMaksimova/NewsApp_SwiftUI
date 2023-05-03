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
                .onDelete(perform: deleteItems)
                .padding()
            }
            .navigationTitle("Новости")
            .onAppear {
                loadData()
            }
        }
    }
    
    func loadData() {
        let request: NSFetchRequest<News> = News.fetchRequest()
        do {
            news = try viewContext.fetch(request)
        } catch let error {
            print("Error fetching items: \(error.localizedDescription)")
        }
    }
    
    func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { news[$0] }.forEach { item in
                viewContext.delete(item)
            }
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

