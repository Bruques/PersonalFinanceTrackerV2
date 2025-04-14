//
//  TransactionsListView.swift
//  PersonalFinanceTracker
//
//  Created by Bruno Marques on 30/03/25.
//

import SwiftUI
import CoreData

struct TransactionsListView: View {
    @State var showTransactionForm: Bool = false
    @State var transactions: [FinancialTransaction] = []
    let context = CoreDataStack.shared.persistentContainer.viewContext
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(transactions, id: \.id) { transaction in
                    VStack(spacing: 4) {
                        Text(transaction.title ?? "")
                            .font(.title3)
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("\(transaction.date?.formatted(.dateTime.day().month().year()) ?? Date().formatted())")
                            .frame(maxWidth: .infinity, alignment: .leading)
                        HStack {
                            Text(transaction.category?.title ?? "")
                                .font(.title2)
                            Spacer()
                            Text("\(transaction.amount.formatted(.currency(code: "BRL")))")
                                .font(.title3)
                                .bold()
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .frame(maxWidth: .infinity)
                }
                .onDelete(perform: { indexSet in
                    guard let index = indexSet.first else { return }
                    context.delete(transactions[index])
                    CoreDataStack.shared.save()
                    self.fetchTransactions()
                })
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        showTransactionForm = true
                    }, label: {
                        Image(systemName: "plus")
                            .font(.title2)
                    })
                }
            }
            .refreshable {
                fetchTransactions()
            }
        }
        .sheet(isPresented: $showTransactionForm, content: {
            TransactionFormView() { self.transactions.append($0) }
        })
        .onAppear {
            fetchTransactions()
        }
    }
}

extension TransactionsListView {
    private func fetchTransactions() {
        let request = NSFetchRequest<FinancialTransaction>(entityName: "FinancialTransaction")
        do {
            let response = try CoreDataStack.shared.persistentContainer.viewContext.fetch(request)
            transactions = response
        } catch {
            print("Fetch contracts error: \(error.localizedDescription)")
        }
    }
}

#Preview {
    TransactionsListView()
}
