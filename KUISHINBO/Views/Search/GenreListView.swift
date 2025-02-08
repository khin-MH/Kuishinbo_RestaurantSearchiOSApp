//
//  GenreListView.swift
//  KUISHINBO
//
//
//  Created by KHIN MYOHTUN on 2025/02/02.
//
import SwiftUI

struct GenreListView: View {
    let genres: [String] = [
        "居酒屋", "和食", "洋食", "カフェ・スイーツ", "中華", "イタリアン・フレンチ",
        "焼肉・ホルモン", "ダイニングバー", "韓国料理", "ラーメン", "寿司", "タイ・ベトナム料理",
        "鍋料理", "インド料理", "アメリカ料理", "バー・カクテル", "お好み焼き・もんじゃ",
        "アジア・エスニック料理", "創作料理", "ビュッフェ", "ファミリーレストラン", "精進料理"
    ]
    @Binding var selectedGenre: String? // Track the selected genre
    @State private var navigateToDetail = false // For navigation
    @Environment(\.presentationMode) var presentationMode

    @StateObject private var searchGenreModel = SearchGenreModel() // Fetch genre restaurants

    var body: some View {
        NavigationView {
            VStack {
                // List of Genres
                List(genres, id: \.self) { genre in
                    HStack {
                        Text(genre)
                            .font(.body)
                        Spacer()
                        if selectedGenre == genre {
                            Image(systemName: "checkmark")
                                .foregroundColor(.orange)
                        }
                    }
                    .contentShape(Rectangle()) // Make the entire row tappable
                    .onTapGesture {
                        selectedGenre = genre // Set selected genre
                    }
                }
                .listStyle(PlainListStyle())

                // Confirm Button
                Button(action: {
                    if let selected = selectedGenre {
                        Task {
                            await searchGenreModel.fetchNearbyRestaurants(for: selected)
                            navigateToDetail = true
                        }
                    }
                }) {
                    Text("確定")
                        .font(.headline)
                        .frame(maxWidth: 100, minHeight: 50)
                        .background(selectedGenre == nil ? Color.gray : Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding()
                }
                .disabled(selectedGenre == nil) // Disable until a genre is selected
                .background(
                    NavigationLink(
                        destination: SearchDetailView(option: selectedGenre ?? "ジャンル", restaurants: searchGenreModel.genreShops),
                        isActive: $navigateToDetail,
                        label: { EmptyView() }
                    )
                )
            }
            .navigationTitle("ジャンルを選ぶ")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.backward")
                            .font(.headline)
                            .foregroundColor(.orange)
                    }
                }
            }
        }
        .onDisappear {
                    selectedGenre = nil // Reset genre when view is dismissed
                }
    }
}
