//
//  AddCategorySheet.swift
//  PersonalFinanceTracker
//
//  Created by Bruno Marques on 11/04/25.
//

import SwiftUI

struct CategoriesFormView: View {
    @Binding var isPresented: Bool
    @State private var categoryName: String = ""
    @FocusState private var isFocused: Bool
    private let context = CoreDataStack.shared.persistentContainer.viewContext
    
    public let completion: (Category) -> Void
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Nome da categoria", text: $categoryName)
                        .focused($isFocused)
                        .onAppear {
                            isFocused = true
                        }
                }
            }
            .navigationTitle("Nova Categoria")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancelar") {
                    isPresented = false
                },
                trailing: Button("Salvar") {
                    saveCategory()
                }
                .disabled(categoryName.isEmpty)
            )
        }
        .presentationDetents([.height(150)])
    }
}

extension CategoriesFormView {
    private func saveCategory() {
        let category = Category(context: context)
        category.title = categoryName
        CoreDataStack.shared.save()
        completion(category)
        isPresented = false
    }
}

#Preview {
    CategoriesFormView(isPresented: .constant(true), completion: { _ in })
}
