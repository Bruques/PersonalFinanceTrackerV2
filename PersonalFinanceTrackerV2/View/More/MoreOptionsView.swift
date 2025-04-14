//
//  MoreOptionsView.swift
//  PersonalFinanceTracker
//
//  Created by Bruno Marques on 08/04/25.
//

import SwiftUI

struct MoreOptionsView: View {
    @State private var showCategories = false
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    categoriesButton
                }
            }
            .frame(maxWidth: .infinity,
                   maxHeight: .infinity)
        }
    }
    
    var categoriesButton: some View {
        NavigationLink(destination: CategoriesListView()) {
            HStack {
                Image(systemName: "pencil.and.ellipsis.rectangle")
                Text("Categorias")
            }
        }
    }
}

#Preview {
    MoreOptionsView()
}
