import SwiftUI

struct MovieFileDetail: View {
    let file: MovieFile

    var body: some View {
        VStack(spacing: 12) {
            VStack(alignment: .center, spacing: 12) {
                // center-aligned details like the screenshot
                VStack(alignment: .center, spacing: 6) {
                    HStack(alignment: .top) {
                        Text("RELATIVE PATH")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .frame(width: 96, alignment: .leading)

                        Text(file.relativePath)
                            .font(.subheadline)
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.leading)
                    }

                    if let video = file.video {
                        labeledRow(title: "VIDEO", value: video)
                    }
                    if let audio = file.audio {
                        labeledRow(title: "AUDIO", value: audio)
                    }
                    if let size = file.size {
                        labeledRow(title: "SIZE", value: size)
                    }
                    if let languages = file.languages {
                        labeledColumn(title: "LANGUAGES", values: languages)
                    }
                    if let quality = file.quality {
                        labeledRow(title: "QUALITY", value: quality)
                    }
                    if let formats = file.formats {
                        labeledColumn(title: "FORMATS", values: formats)
                    }
                    if let added = file.addedOn {
                        VStack(spacing: 2) {
                            Text("ADDED ON")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(added, style: .date)
                                .font(.subheadline)
                            Text(added, style: .time)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }

                HStack(spacing: 12) {
                    Button(action: {}) {
                        HStack {
                            Image(systemName: "info.circle")
                            Text("Media Info")
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.mint)

                    Button(role: .destructive, action: {}) {
                        HStack {
                            Image(systemName: "trash")
                            Text("Delete")
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                }
            }
            .padding(16)
            .background(RoundedRectangle(cornerRadius: 12).fill(Color.platformSecondaryGroupedBackground))
        }
        .padding(.horizontal)
    }

    @ViewBuilder
    private func labeledRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
                .frame(width: 96, alignment: .leading)
            Text(value)
                .font(.subheadline)
                .foregroundColor(.primary)
            Spacer()
        }
    }

    @ViewBuilder
    private func labeledColumn(title: String, values: [String]) -> some View {
        HStack(alignment: .top) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
                .frame(width: 96, alignment: .leading)

            VStack(alignment: .leading, spacing: 2) {
                ForEach(values, id: \.self) { v in
                    Text(v)
                        .font(.subheadline)
                        .foregroundColor(.primary)
                }
            }

            Spacer()
        }
    }
}

struct MovieFileDetail_Previews: PreviewProvider {
    static var previews: some View {
        MovieFileDetail(file: .sample1)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
