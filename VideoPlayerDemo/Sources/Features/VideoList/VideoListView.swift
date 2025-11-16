//
//  VideoListView.swift
//  VideoPlayerDemo
//
//  Created by 송영훈 on 11/2/25.
//

import SwiftUI

struct VideoListView: View {

	@StateObject private var viewModel: VideoListViewModel

	init() {
		_viewModel = StateObject(
			wrappedValue: VideoListViewModel(videos: Sample().videos)
		)
	}

	var body: some View {
		NavigationStack {
			HLSInputTextField()

			List {
				videoSection(title: "Local", videos: $viewModel.localVideos)

				videoSection(title: "HLS", videos: $viewModel.remoteVideos)
			}
			.navigationDestination(for: Video.self) { video in
				VideoPlayerView(video: video)
			}
			.listStyle(.grouped)
			.navigationTitle("비디오 목록")
			.navigationBarTitleDisplayMode(.inline)
		}
	}

	@ViewBuilder
	private func videoSection(title: String, videos: Binding<[Video]>) -> some View {
		Section(title) {
			ForEach(videos) { video in
				NavigationLink(value: video.wrappedValue) {
					VideoRow(video: video)
						.task {
							if video.wrappedValue.thumbnail == nil {
								await viewModel.loadThumbnail(for: video.wrappedValue)
							}
							if video.wrappedValue.duration == nil {
								await viewModel.loadDuration(for: video.wrappedValue)
							}
						}
				}
			}
		}
	}
}

#Preview {
	VideoListView()
}
