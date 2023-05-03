//
//  TitleAndImageView.swift
//  NewsApp_SwiftUI
//
//  Created by Kristi on 03.05.2023.
//

import SwiftUI

struct TitleAndImageView: View {
    
    @State var title: String
    @State var urlImage: String
    
    var body: some View {
        Group {
            if let imageUrl = URL(string: urlImage) {
                GeometryReader { geometry in
                    AsyncImage(url: imageUrl) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .clipped()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height)
                }
                .frame(height: 150)
            }
        }
        .padding(.bottom, 10)
        
        Text(title)
            .padding(20)
            .font(.system(size: 22))
    }
}
