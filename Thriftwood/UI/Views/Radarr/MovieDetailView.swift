//
//  MovieDetailView.swift
//  PrototypeGUI
//
//  Created by Matthias Wallner-Géhri on 07.10.25.
//


import SwiftUI

struct MovieDetailView: View {
    let movie: Movie

    private enum Tab: String {
        case overview
        case files
        case history
        case people
    }

    @State private var selectedTab: Tab = .overview

    var body: some View {
        VStack {
            //                VStack(spacing: 16) {


            // Content area changes with selected tab
            Group {
                switch selectedTab {
                case .overview:
                    MovieOverviewView(movie: movie)

                case .files:
                    MovieFilesView(movie: movie)

                case .history:
                    MovieHistoryView(movie: movie)

                case .people:
                    MovieCastCrewView(movie: movie)
                }
            }
            .padding()
            .background(Color.platformSecondaryGroupedBackground)

            // The toolbar was moved to the view's toolbar as a bottom bar
        }
        .toolbar {
            ToolbarItemGroup(placement: .platformBottom) {
                Button(action: { selectedTab = .overview }) { Label("Overview", systemImage: "list.bullet") }

                Spacer()

                Button(action: { selectedTab = .files }) { Label("Files", systemImage: "doc.on.doc") }

                Button(action: { selectedTab = .history }) { Label("History", systemImage: "clock.arrow.circlepath") }

                Button(action: { selectedTab = .people }) { Label("People", systemImage: "person.crop.circle") }
            }
        }
        .navigationTitle(movie.title)
    }
}

#Preview("Movie Detail") {
    NavigationStack {
        MovieDetailView(movie: Movie.sample[0])
    }
}
