//
//  VideoPlayerView.swift
//  VideoPlayerDemo
//
//  Created by 송영훈 on 11/2/25.
//

import SwiftUI
import AVKit

struct VideoPlayerView: View {

	@StateObject private var viewModel: VideoPlayerViewModel

	init(video: Video) {
		_viewModel = StateObject(wrappedValue: VideoPlayerViewModel(video: video))
	}

	var body: some View {
		ZStack(alignment: .center) {
			VideoPlayerLayerView(player: viewModel.player)
				.ignoresSafeArea()
		}
	}
}

#Preview {
    VideoPlayerView(
		video: Video(
			title: "Dog 15s",
			source: .local(fileName: "dog 15s", ext: "mp4")
		)
	)
}
