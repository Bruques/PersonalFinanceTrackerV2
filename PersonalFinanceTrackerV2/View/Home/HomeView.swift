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
            // TODO: - Change in the future currency format
            Text("Gastos: \(getTransactionsAmmount().formatted(.currency(code: "BRL"))))")
            Image(systemName: "house.fill")
                .font(.largeTitle)
            Text("Dashboard View")
                .font(.title)
        }
        .onAppear {
            fetchTransactions()
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
    
    private func getTransactionsAmmount() -> Double {
        let ammount = transactions
            .map({$0.amount})
            .reduce(0, +)
        return ammount
    }
}

#Preview {
    HomeView()
}
