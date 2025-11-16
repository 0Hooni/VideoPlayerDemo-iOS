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
				VideoSection(title: "로컬 영상", videos: Sample().localVideos)
				VideoSection(title: "HLS 영상", videos: Sample().remoteVideos)
			}
			.navigationDestination(for: Video.self) { video in
				VideoPlayerView(video: video)
			}
			.listStyle(.grouped)
			.navigationTitle("비디오 목록")
			.navigationBarTitleDisplayMode(.inline)
		}
	}
}

#Preview {
	VideoListView()
}
