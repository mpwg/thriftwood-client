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
