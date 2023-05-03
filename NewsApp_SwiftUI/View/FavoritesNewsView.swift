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
    
    @State private var items: [News] = []
    
    var body: some View {
        NavigationView {
            List {
                ForEach(items) { article in
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
            items = try viewContext.fetch(request)
        } catch let error {
            print("Error fetching items: \(error.localizedDescription)")
        }
    }
    
    func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach { item in
                viewContext.delete(item)
            }
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
        print("Удалена")
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesNewsView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
