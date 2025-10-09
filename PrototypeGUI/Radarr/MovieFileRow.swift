import SwiftUI

struct MovieFileRow: View {
    let file: MovieFile
    var body: some View {
        VStack(spacing: 12) {
            // card-like appearance
            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 6) {
                        HStack(alignment: .top) {
                            Text("RELATIVE PATH")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .frame(minWidth: 96, alignment: .leading)
                            Text(file.relativePath)
                                .font(.subheadline)
                                .foregroundColor(.primary)
                                .multilineTextAlignment(.leading)
                        }

                        if let video = file.video {
                            HStack {
                                Text("VIDEO")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .frame(minWidth: 96, alignment: .leading)
                                Text(video)
                                    .font(.subheadline)
                                    .foregroundColor(.primary)
                            }
                        }

                        if let audio = file.audio {
                            HStack {
                                Text("AUDIO")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .frame(minWidth: 96, alignment: .leading)
                                Text(audio)
                                    .font(.subheadline)
                                    .foregroundColor(.primary)
                            }
                        }

                        if let size = file.size {
                            HStack {
                                Text("SIZE")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .frame(minWidth: 96, alignment: .leading)
                                Text(size)
                                    .font(.subheadline)
                                    .foregroundColor(.primary)
                            }
                        }

                        if let languages = file.languages, !languages.isEmpty {
                            HStack(alignment: .top) {
                                Text("LANGUAGES")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .frame(minWidth: 96, alignment: .leading)
                                VStack(alignment: .leading) {
                                    ForEach(languages, id: \.self) { lang in
                                        Text(lang)
                                            .font(.subheadline)
                                    }
                                }
                                .foregroundColor(.primary)
                            }
                        }

                        if let quality = file.quality {
                            HStack {
                                Text("QUALITY")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .frame(minWidth: 96, alignment: .leading)
                                Text(quality)
                                    .font(.subheadline)
                                    .foregroundColor(.primary)
                            }
                        }

                        if let formats = file.formats, !formats.isEmpty {
                            HStack(alignment: .top) {
                                Text("FORMATS")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .frame(minWidth: 96, alignment: .leading)
                                VStack(alignment: .leading) {
                                    ForEach(formats, id: \.self) { f in
                                        Text(f)
                                            .font(.subheadline)
                                    }
                                }
                                .foregroundColor(.primary)
                            }
                        }

                        if let added = file.addedOn {
                            HStack(alignment: .top) {
                                Text("ADDED ON")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .frame(minWidth: 96, alignment: .leading)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(added, style: .date)
                                        .font(.subheadline)
                                    Text(added, style: .time)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                .foregroundColor(.primary)
                            }
                        }
                    }

                    Spacer()
                }
            }
            .padding(16)
            .background(RoundedRectangle(cornerRadius: 12).fill(Color.platformSecondaryGroupedBackground))
        }
        .padding(.horizontal)
    }
}

struct MovieFileRow_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 12) {
            MovieFileRow(file: .sample1)
            MovieFileRow(file: .sample2)
            MovieFileRow(file: .sample3)
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
