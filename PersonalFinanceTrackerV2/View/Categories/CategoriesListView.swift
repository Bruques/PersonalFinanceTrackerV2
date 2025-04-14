//
//  CategoriesView.swift
//  PersonalFinanceTracker
//
//  Created by Bruno Marques on 11/04/25.
//

import SwiftUI
import CoreData

struct CategoriesListView: View {
    @State private var showingAddSheet = false
    @State private var categories: [Category] = []
    let context = CoreDataStack.shared.persistentContainer.viewContext
    
    var body: some View {
        ZStack {
            VStack {
                Text("Categorias")
                    .font(.title)
                    .padding()
                List {
                    ForEach(categories, id: \.id) { category in
                        Text(category.title ?? "")
                    }
                    .onDelete(perform: { indexSet in
                        guard let index = indexSet.first else { return }
                        context.delete(categories[index])
                        CoreDataStack.shared.save()
                        fetchCategories()
                    })
                }
                .refreshable {
                    fetchCategories()
                }
            }
            // TODO: - Colocar isso em um design system
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        showingAddSheet = true
                    }) {
                        Image(systemName: "plus")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(width: 56, height: 56)
                            .background(Color.blue)
                            .clipShape(Circle())
                            .shadow(radius: 4)
                    }
                    .padding()
                }
            }
        }
        .onAppear {
            fetchCategories()
        }
        .sheet(isPresented: $showingAddSheet) {
            CategoriesFormView(isPresented: $showingAddSheet) { category in
                self.categories.append(category)
            }
        }
    }
}

extension CategoriesListView {
    private func fetchCategories() {
        let request = NSFetchRequest<Category>(entityName: "Category")
        do {
            let response = try CoreDataStack.shared.persistentContainer.viewContext.fetch(request)
            categories = response
        } catch {
            print("Fetch contracts error: \(error.localizedDescription)")
        }
    }
}

#Preview {
    CategoriesListView()
}
