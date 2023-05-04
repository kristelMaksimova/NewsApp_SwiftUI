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
    
    @ObservedObject private var viewModel: FavoritesNewsViewModel
    
    init(viewModel: FavoritesNewsViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.news) { article in
                    VStack {
                        TitleAndImageView(title: article.title ?? "",
                                          urlImage: article.urlImage ?? "")
                        
                        HStack {
                            DateView(date: article.date ?? "")
                        }
                    }
                }
                .onDelete(perform: viewModel.deleteDataFromStorageByIndex)
                .padding()
            }
            .navigationTitle("Избранные")
            .onAppear {
                viewModel.loadData()
            }
        }
    }
}
