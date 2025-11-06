//
//  VideoRow.swift
//  VideoPlayerDemo
//
//  Created by 송영훈 on 11/3/25.
//

import SwiftUI

struct VideoRow: View {
	@Binding var video: Video

	var body: some View {
		HStack(spacing: 12) {
			thumbnailView
				.frame(width: 64, height: 64)
				.background(Color.gray.opacity(0.3))
				.cornerRadius(12)

			VStack(alignment: .leading, spacing: 8) {
				Text(video.title)
					.font(.title3)
					.lineLimit(1)
					.truncationMode(.tail)

				if let duration = video.duration {
					Text(duration.toKRStyleString())
						.font(.default)
						.foregroundColor(.secondary)
				} else {
					Text("로딩 중...")
						.font(.default)
						.foregroundColor(.secondary)
				}
			}

			Spacer()
		}
		.padding(.vertical, 4)
	}

	@ViewBuilder
	private var thumbnailView: some View {
		if let thumbnailData = video.thumbnail,
		   let uiImage = UIImage(data: thumbnailData) {
			Image(uiImage: uiImage)
				.resizable()
				.aspectRatio(contentMode: .fill)
				.frame(width: 80, height: 80)
				.clipped()
		} else {	// Placeholder
			ZStack {
				Color.gray.opacity(0.3)
				Image(systemName: "video.fill")
					.font(.title)
					.foregroundColor(.gray)
			}
		}
	}
}
