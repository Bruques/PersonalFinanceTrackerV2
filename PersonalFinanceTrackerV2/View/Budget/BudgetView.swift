//
//  BudgetView.swift
//  PersonalFinanceTracker
//
//  Created by Bruno Marques on 30/03/25.
//

import SwiftUI

struct BudgetView: View {
    var body: some View {
        VStack {
            Image(systemName: "chart.pie.fill")
                .font(.largeTitle)
            Text("Budget view")
                .font(.title)
        }

    }
}

#Preview {
    BudgetView()
}
