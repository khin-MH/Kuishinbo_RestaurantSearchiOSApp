//
//  CustomAnnotationView.swift
//  KUISHINBO
//
//  Created by KHIN MYOHTUN on 2025/02/02.
//

import SwiftUI

struct CustomAnnotationView: View {
    let shop: Shop

    var body: some View {
        VStack {
            // Display shop photo
            AsyncImage(url: URL(string: shop.photo?.mobile?.l ?? "")) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.orange, lineWidth: 2))
                    .shadow(radius: 5)
            } placeholder: {
                Circle()
                    .fill(Color.gray)
                    .frame(width: 50, height: 50)
                    .overlay(Text("No Image").font(.caption).foregroundColor(.white))
            }

        }
    }
}
