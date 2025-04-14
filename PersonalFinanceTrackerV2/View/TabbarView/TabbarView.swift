//
//  TabbarView.swift
//  PersonalFinanceTracker
//
//  Created by Bruno Marques on 30/03/25.
//

import SwiftUI

struct TabbarView: View {
    var body: some View {
        TabView {
            homeView
            transactionsListView
            budgetView
            moreOptionsView
        }
    }
    
    var homeView: some View {
        HomeView()
            .tabItem {
                Label(
                    title: { Text("Home") },
                    icon: { Image(systemName: "house.fill") }
                )
            }
    }
    
    var transactionsListView: some View {
        TransactionsListView()
            .tabItem {
                Label(
                    title: { Text("Transaction") },
                    icon: { Image(systemName: "arrow.right.arrow.left.circle.fill") }
                )
            }
    }
    
    var budgetView: some View {
        BudgetView()
            .tabItem {
                Label(
                    title: { Text("Budged") },
                    icon: { Image(systemName: "chart.pie.fill") }
                )
            }
    }
    
    var moreOptionsView: some View {
        MoreOptionsView()
            .tabItem {
                Label(
                    title: { Text("More") },
                    icon: { Image(systemName: "ellipsis.circle") }
                )
            }
    }
}

#Preview {
    TabbarView()
}
