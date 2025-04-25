//
//  TransactionsListView.swift
//  PersonalFinanceTracker
//
//  Created by Bruno Marques on 30/03/25.
//

import SwiftUI
import CoreData

public enum TransactionType: String, CaseIterable {
    case expense = "Gastos"
    case income = "Entradas"
}

struct TransactionsListView: View {
    let context = CoreDataStack.shared.persistentContainer.viewContext
    
    @State var showTransactionForm: Bool = false
    @State var transactions: [FinancialTransaction] = []
    @State var selectedTransactionType: TransactionType = .expense
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            transactionTypePicker
            transactionList
        }
        .sheet(isPresented: $showTransactionForm, content: {
            TransactionFormView(transactionType: selectedTransactionType) { self.transactions.append($0) }
        })
        .onAppear {
            fetchTransactions()
        }
        .onChange(of: selectedTransactionType) {
            self.fetchTransactions()
        }
    }
    
    // MARK: - Transaction type picker
    var transactionTypePicker: some View {
        Picker("Tipo de transação", selection: $selectedTransactionType) {
            ForEach(TransactionType.allCases, id: \.self) { item in
                Text(item.rawValue)
            }
        }
        .pickerStyle(.segmented)
        .padding()
    }
    
    // MARK: - Transaction list
    var transactionList: some View {
        List {
            ForEach(transactions, id: \.id) { transaction in
                transactionCell(transaction)
            }
            .onDelete(perform: { indexSet in
                self.onDeleteTransaction(index: indexSet)
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
    
    // MARK: - Transaction cell
    func transactionCell(_ transaction: FinancialTransaction) -> some View {
        VStack(spacing: 4) {
            HStack {
                Text(transaction.title ?? "")
                    .font(.title3)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(transaction.transactionType ?? "")
            }
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
}

extension TransactionsListView {
    // MARK: - Fetch transactions
    private func fetchTransactions() {
        let request = NSFetchRequest<FinancialTransaction>(entityName: "FinancialTransaction")
        do {
            let response = try CoreDataStack.shared.persistentContainer.viewContext.fetch(request)
            transactions = response.filter({ $0.transactionType == selectedTransactionType.rawValue})
        } catch {
            print("Fetch contracts error: \(error.localizedDescription)")
        }
    }
    
    // MARK: - On delete transaction
    private func onDeleteTransaction(index: IndexSet) {
        guard let index = index.first else { return }
        context.delete(transactions[index])
        CoreDataStack.shared.save()
        self.fetchTransactions()
    }
}

#Preview {
    TransactionsListView()
}
