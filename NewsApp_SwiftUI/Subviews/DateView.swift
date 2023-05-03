//
//  DateView.swift
//  NewsApp_SwiftUI
//
//  Created by Kristi on 03.05.2023.
//

import SwiftUI

struct DateView: View {
    
    @State var date: String
    
    var body: some View {
        Text(formatterData(date))
            .padding(.leading, 20)
    }

    func formatterData(_ date: String?) -> String {
        guard let date = date else { return "" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        guard let formattedDate = dateFormatter.date(from: date) else { return "" }
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: formattedDate)
    }
}
