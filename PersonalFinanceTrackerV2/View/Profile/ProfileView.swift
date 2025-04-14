//
//  ProfileView.swift
//  PersonalFinanceTracker
//
//  Created by Bruno Marques on 30/03/25.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        VStack {
            Image(systemName: "person.circle.fill")
                .font(.largeTitle)
            Text("Profile view")
                .font(.title)
        }
    }
}

#Preview {
    ProfileView()
}
