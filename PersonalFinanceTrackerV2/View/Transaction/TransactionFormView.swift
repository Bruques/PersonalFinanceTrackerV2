//
//  TransactionFormView.swift
//  PersonalFinanceTracker
//
//  Created by Bruno Marques on 12/04/25.
//

import SwiftUI
import CoreData

struct TransactionFormView: View {
    @Environment(\.dismiss) var dismiss
    @FocusState private var isFocused: Bool
    @State var ammount: Double = 0.0
    @State var date: Date = Date()
    @State var title: String = ""
    @State var categories: [Category] = []
    @State var selectedCategory: Category?
    
    let completion: (FinancialTransaction) -> Void
    
    var body: some View {
        NavigationStack {
            Form {
                MoneyTextField(value: $ammount)
                    .focused($isFocused)
                    .onAppear {
                        isFocused = true
                    }
                Picker("Categorias", selection: $selectedCategory) {
                    ForEach(categories, id: \.id) { category in
                        Text(category.title ?? "Sem título")
                            .tag(Optional(category)) // I need use this because selectec category is optional
                    }
                }
                DatePicker("Data da despesa", selection: $date, displayedComponents: .date)
                TextField("Descrição", text: $title)
            }
            .scrollDismissesKeyboard(.interactively)
            .navigationTitle("Nova despesa")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    backButton
                }
                ToolbarItem(placement: .topBarTrailing) {
                    saveButton
                }
            }
        }
        .onAppear {
            fetchCategories()
        }
    }
    
    var backButton: some View {
            Button(action: {
                dismiss()
            }, label: {
                Text("Voltar")
            })
        }
        
        var saveButton: some View {
            Button(action: {
                saveTransaction()
            }, label: {
                Text("Salvar")
                    .font(.headline)
            })
            .disabled(!isSaveButtonEnabled())
        }
}

extension TransactionFormView {
    private func isSaveButtonEnabled() -> Bool {
        return ammount != 0.0 && !title.isEmpty
    }
    
    private func fetchCategories() {
        let request = NSFetchRequest<Category>(entityName: "Category")
        do {
            let response = try CoreDataStack.shared.persistentContainer.viewContext.fetch(request)
            categories = response
            selectedCategory = response.first
        } catch {
            print("Fetch contracts error: \(error.localizedDescription)")
        }
    }
    
    private func saveTransaction() {
        let transaction = FinancialTransaction(context: CoreDataStack.shared.persistentContainer.viewContext)
        transaction.amount = ammount
        transaction.date = date
        transaction.title = title
        transaction.category = selectedCategory
        CoreDataStack.shared.save()
        completion(transaction)
        dismiss()
    }
}

#Preview {
    TransactionFormView() { _ in }
}




// TODO: - Colocar isso em um Design System
// TODO: - On the Future, allow this TF to use different currencies
struct MoneyTextField: View {
    @Binding var value: Double
    @State private var internalText: String = ""
    
    private let formatter: NumberFormatter = {
        let f = NumberFormatter()
        f.locale = Locale(identifier: "pt_BR")
        f.numberStyle = .currency
        f.maximumFractionDigits = 2
        f.minimumFractionDigits = 2
        f.currencySymbol = "R$ "
        return f
    }()
    
    var body: some View {
        TextField("R$ 0,00", text: $internalText)
            .keyboardType(.numberPad)
            .onChange(of: internalText) { newValue in
                let digits = newValue.filter { $0.isNumber }
                let double = (Double(digits) ?? 0) / 100
                value = double
                internalText = formatter.string(from: NSNumber(value: double)) ?? ""
            }
            .onAppear {
                internalText = formatter.string(from: NSNumber(value: value)) ?? ""
            }
    }
}
