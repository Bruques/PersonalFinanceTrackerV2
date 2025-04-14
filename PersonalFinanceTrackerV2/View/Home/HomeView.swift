//
//  HomeView.swift
//  PersonalFinanceTracker
//
//  Created by Bruno Marques on 30/03/25.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack {
            Image(systemName: "house.fill")
                .font(.largeTitle)
            Text("Dashboard View")
                .font(.title)
        }
    }
}

#Preview {
    HomeView()
}
