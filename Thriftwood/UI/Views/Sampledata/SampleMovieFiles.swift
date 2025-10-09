//
//  SampleMovieFiles.swift
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
import Foundation
import SwiftUI

// Sample MovieFile entries used by previews and fallback views
extension MovieFile {
    static let sample1 = MovieFile(
        relativePath: "Aurora Ridge (2018) {sample-0001} [Bluray-1080p][AC3 5.1][EN+DE][8bit][x264].mkv",
        type: "Video",
        extension: ".mkv",
        size: "4.4 GB",
        video: "x264",
        audio: "AC3 • 5.1",
        languages: ["English", "German"],
        quality: "Bluray-1080p",
        formats: ["1080p", "5.1 Surround", "DD", "No-RlsGroup", "x264"],
        addedOn: Date()
    )

    static let sample2 = MovieFile(
        relativePath: "fanart.jpg",
        type: "Metadata",
        extension: ".jpg",
        size: nil,
        video: nil,
        audio: nil,
        languages: nil,
        quality: nil,
        formats: nil,
        addedOn: nil
    )

    static let sample3 = MovieFile(
        relativePath: "movie.nfo",
        type: "Metadata",
        extension: ".nfo",
        size: nil,
        video: nil,
        audio: nil,
        languages: nil,
        quality: nil,
        formats: nil,
        addedOn: nil
    )

    static let sample4_4k = MovieFile(
        relativePath: "Aurora Ridge (2018) {imdb-tt0000001} [Remux-2160p][HDR10+][DTS-HD MA 7.1].mkv",
        type: "Video",
        extension: ".mkv",
        size: "78.3 GB",
        video: "HEVC (x265) 2160p HDR10+",
        audio: "DTS-HD MA • 7.1",
        languages: ["English"],
        quality: "Remux-2160p",
        formats: ["2160p", "HDR10+", "7.1 Surround", "DTS-HD MA"],
        addedOn: Date()
    )

    static let sample5_trailer = MovieFile(
        relativePath: "trailers/Aurora Ridge - Trailer (1080p).mp4",
        type: "Video",
        extension: ".mp4",
        size: "56.0 MB",
        video: "H.264 1080p",
        audio: "AAC • Stereo",
        languages: ["English"],
        quality: "Trailer-1080p",
        formats: ["1080p", "Stereo"],
        addedOn: Date()
    )

    static let sample6_poster = MovieFile(
        relativePath: "poster.jpg",
        type: "Metadata",
        extension: ".jpg",
        size: "1.2 MB",
        video: nil,
        audio: nil,
        languages: nil,
        quality: nil,
        formats: ["poster"],
        addedOn: Date()
    )

    static let sample7_subs_en = MovieFile(
        relativePath: "subtitles/Aurora Ridge.en.srt",
        type: "Subtitle",
        extension: ".srt",
        size: "24 KB",
        video: nil,
        audio: nil,
        languages: ["English"],
        quality: nil,
        formats: ["srt"],
        addedOn: Date()
    )

    static let sample8_subs_de = MovieFile(
        relativePath: "subtitles/Aurora Ridge.de.srt",
        type: "Subtitle",
        extension: ".srt",
        size: "28 KB",
        video: nil,
        audio: nil,
        languages: ["German"],
        quality: nil,
        formats: ["srt"],
        addedOn: Date()
    )

    static let sample9_audio_flac = MovieFile(
        relativePath: "audio/Aurora Ridge - Score (FLAC).flac",
        type: "Audio",
        extension: ".flac",
        size: "320 MB",
        video: nil,
        audio: "FLAC • Stereo",
        languages: nil,
        quality: nil,
        formats: ["flac"],
        addedOn: Date()
    )

    static let sample10_extra_doc = MovieFile(
        relativePath: "extras/behind_the_scenes.mp4",
        type: "Video",
        extension: ".mp4",
        size: "412 MB",
        video: "H.264 720p",
        audio: "AAC • Stereo",
        languages: ["English"],
        quality: "Extra-720p",
        formats: ["720p"],
        addedOn: Date()
    )

    static let sample11_4k_alt = MovieFile(
        relativePath: "Glass Harbor (2020) [WEBDL-2160p][x265][AAC].mkv",
        type: "Video",
        extension: ".mkv",
        size: "26.5 GB",
        video: "x265 2160p",
        audio: "AAC • 5.1",
        languages: ["English"],
        quality: "WEB-2160p",
        formats: ["2160p", "5.1 Surround", "x265"],
        addedOn: Date()
    )

    static let sample12_sample_clip = MovieFile(
        relativePath: "sample.mp4",
        type: "Video",
        extension: ".mp4",
        size: "2.3 MB",
        video: "H.264 480p",
        audio: "AAC • Stereo",
        languages: ["English"],
        quality: "Sample",
        formats: ["480p"],
        addedOn: nil
    )

    static let sample13_subs_multi = MovieFile(
        relativePath: "subtitles/Glass Harbor.multi.srt",
        type: "Subtitle",
        extension: ".srt",
        size: "64 KB",
        video: nil,
        audio: nil,
        languages: ["English","Spanish","German"],
        quality: nil,
        formats: ["srt"],
        addedOn: Date()
    )

    static let sample14_eng_audio = MovieFile(
        relativePath: "Glass Harbor.eng.ac3",
        type: "Audio",
        extension: ".ac3",
        size: "45 MB",
        video: nil,
        audio: "AC3 • 5.1",
        languages: ["English"],
        quality: nil,
        formats: ["5.1"],
        addedOn: Date()
    )

    static let sample15_metadata_xml = MovieFile(
        relativePath: "metadata/local-metadata.xml",
        type: "Metadata",
        extension: ".xml",
        size: "12 KB",
        video: nil,
        audio: nil,
        languages: nil,
        quality: nil,
        formats: ["xml"],
        addedOn: Date()
    )

}
