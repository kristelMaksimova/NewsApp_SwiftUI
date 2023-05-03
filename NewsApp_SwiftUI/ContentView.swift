//
//  ContentView.swift
//  NewsApp_SwiftUI
//
//  Created by Kristi on 03.05.2023.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        TabView {
            
            NewsView()
                .tabItem {
                    Label("News", systemImage: "house")
                }
            FavoritesNewsView()
                .tabItem {
                    Label("Favorites", systemImage: "heart")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
