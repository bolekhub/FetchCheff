//
//  SectionHeaderView.swift
//  FetchChef
//
//  Created by Boris Chirino Fernández on 1/14/25.
//

import SwiftUI

struct SectionHeaderView: View {
    var title: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
            Spacer()
        }
        .padding()
        .background(Color.primary
            .colorInvert()
            .opacity(0.75))
    }
}
