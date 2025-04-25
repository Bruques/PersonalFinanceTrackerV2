//
//  HomeView.swift
//  PersonalFinanceTracker
//
//  Created by Bruno Marques on 30/03/25.
//

import SwiftUI
import CoreData

struct HomeView: View {
    @State private var transactions: [FinancialTransaction] = []
    
    var body: some View {
        VStack {
            HStack {
                incomeContainer
                Spacer()
                    .frame(width: 24)
                expensesContainer
            }
        }
        .onAppear {
            fetchTransactions()
        }
    }
    
    var expensesContainer: some View {
        VStack {
            Text("Gastos")
                .font(.title)
            // TODO: - Change in the future currency format
            Text(getTransactionsAmmount(type: .expense).formatted(.currency(code: "BRL")))
                .font(.title2)
                .padding(12)
                .overlay {
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(.red, lineWidth: 1)
                }
        }
    }
    
    var incomeContainer: some View {
        VStack {
            Text("Entradas")
                .font(.title)
            // TODO: - Change in the future currency format
            Text(getTransactionsAmmount(type: .income).formatted(.currency(code: "BRL")))
                .font(.title2)
                .padding(12)
                .overlay {
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(.green, lineWidth: 1)
                }
        }
    }
}

extension HomeView {
    private func fetchTransactions() {
        let request = NSFetchRequest<FinancialTransaction>(entityName: "FinancialTransaction")
        do {
            let response = try CoreDataStack.shared.persistentContainer.viewContext.fetch(request)
            transactions = response
        } catch {
            print("Fetch contracts error: \(error.localizedDescription)")
        }
    }
    
    private func getTransactionsAmmount(type: TransactionType) -> Double {
        
        let ammount = transactions
            .filter({$0.transactionType == type.rawValue})
            .map({$0.amount})
            .reduce(0, +)
        return ammount
    }
}

#Preview {
    HomeView()
}
