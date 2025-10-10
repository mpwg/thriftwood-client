//
//  MovieHistoryRow.swift
//  Thriftwood
//
//  Thriftwood - Frontend for Media Management
//  Copyright (C) 2025 Matthias Wallner Géhri
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <https://www.gnu.org/licenses/>.
//
//
//  ExpandedHistoryEntryView.swift
//  PrototypeGUI
//
//  Created by Matthias Wallner-Géhri on 08.10.25.
//

import SwiftUI

struct ExpandedHistoryEntryView: View {
    let entry: HistoryEntry
    let onCollapse: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(entry.title)
                .font(.headline)
                .foregroundColor(.primary)

            HStack(spacing: 8) {
                ForEach(entry.badges, id: \.self) { b in
                    Text(b)
                        .font(.caption)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 10)
                        .background(b == "Grabbed" ? Color.orange : Color.primary.opacity(0.12))
                        .foregroundColor(b == "Grabbed" ? .white : .primary)
                        .clipShape(Capsule())
                }
            }

            VStack(alignment: .leading, spacing: 8) {
                ForEach(entry.details, id: \.0) { pair in
                    HStack(alignment: .top) {
                        Text(pair.0)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .frame(width: 120, alignment: .leading)
                        Text(pair.1)
                            .font(.subheadline)
                            .foregroundColor(.primary)
                        Spacer()
                    }
                }
            }
        }
        .padding(16)
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.platformSecondaryGroupedBackground))
        .onTapGesture(perform: onCollapse)
    }
}

private struct CollapsedHistoryEntryView: View {
    let entry: HistoryEntry
    let onExpand: () -> Void

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(alignment: .leading, spacing: 6) {
                Text(entry.title)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                    .lineLimit(2)
                Text(entry.subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            if let status = entry.statusText, let color = entry.statusColor {
                Text(status)
                    .font(.subheadline)
                    .foregroundColor(color)
            }
        }
        .padding(12)
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.platformSecondaryGroupedBackground))
        .onTapGesture(perform: onExpand)
    }
}

    /// A single history row that can expand/collapse itself.
struct MovieHistoryRow: View {
    let entry: HistoryEntry
    let initiallyExpanded: Bool

    @State private var isExpanded: Bool = false

    init(entry: HistoryEntry, initiallyExpanded: Bool = false) {
        self.entry = entry
        self.initiallyExpanded = initiallyExpanded
        _isExpanded = State(initialValue: initiallyExpanded)
    }

    var body: some View {
        Group {
            if isExpanded {
                ExpandedHistoryEntryView(entry: entry) {
                    withAnimation { isExpanded = false }
                }
            } else {
                CollapsedHistoryEntryView(entry: entry) {
                    withAnimation { isExpanded = true }
                }
            }
        }
    }
}
