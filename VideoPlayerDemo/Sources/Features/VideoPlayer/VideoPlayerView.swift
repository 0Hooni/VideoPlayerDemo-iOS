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
		_viewModel = StateObject(
			wrappedValue: VideoPlayerViewModel(video: video)
		)
	}

	var body: some View {
		ZStack(alignment: .center) {
			// Video player layer
			VideoPlayerLayerView(player: viewModel.player) { playerLayer in
				viewModel.setupPIPController(layer: playerLayer)
			}

			if viewModel.showControls && viewModel.playerStatus == .readyToPlay {
				Color.black.opacity(0.3)
					.onTapGesture {
						toggleControlsVisibility()
					}

				controlButtonsView
				playbackTimeView
			}
		}
		.ignoresSafeArea(.all)
		.toolbar(
			viewModel.showControls && viewModel.playerStatus
			== .readyToPlay ? .visible : .hidden
		)
		.toolbar {
			toolbarItems
		}
		.onTapGesture {
			withAnimation {
				viewModel.toggleControlVisibility()
			}
		}
		.onAppear {
			viewModel.resetTimer()
		}
		.onDisappear {
			viewModel.invalidateTimer()
		}
	}

	@ToolbarContentBuilder
	var toolbarItems: some ToolbarContent {
		ToolbarItem(placement: .topBarTrailing) {
			Button(action: pipButtonTapped) {
				Image(systemName: viewModel.isPipActive ? "pip.exit" : "pip.enter")
			}
			.disabled(!viewModel.isPipPossible)
		}
	}

	var controlButtonsView: some View {
		HStack(alignment: .center, spacing: 20) {
			MediaControlButton(systemName: "backward.fill") {
				viewModel.seekBackward()
				viewModel.resetTimer()
			}
			.frame(width: 60, height: 60)
			MediaControlButton(
				systemName: viewModel.isPlaying ? 
				"pause.fill" : "play.fill"
			) {
				viewModel.togglePlaying()
				viewModel.resetTimer()
			}
			.frame(width: 72, height: 72)
			MediaControlButton(systemName: "forward.fill") {
				viewModel.seekForward()
				viewModel.resetTimer()
			}
			.frame(width: 60, height: 60)
		}
	}

	var playbackTimeView: some View {
		VStack(spacing: 12) {
			Spacer()

			PlayTimeText(
				currentTime: $viewModel.currentTime,
				duration: Binding($viewModel.video.duration) ?? .constant(0.0)
			)
			SeekBar(
				currentTime: $viewModel.currentTime,
				duration: Binding($viewModel.video.duration) ?? .constant(0.0),
				bufferedTime: $viewModel.bufferedTime
			)
			.padding(.bottom, UIDevice.current.orientation.isLandscape ? 12 : 40)
			.padding(.horizontal, 28)
		}
	}
}

extension VideoPlayerView {
	func toggleControlsVisibility() {
		withAnimation(.easeInOut(duration: 0.3)) {
			viewModel.toggleControlVisibility()
		}

		if viewModel.showControls {
			viewModel.resetTimer()
		} else {
			withAnimation(.easeInOut(duration: 0.3)) {
				viewModel.invalidateTimer()
			}
		}
	}

	func pipButtonTapped() {
		viewModel.togglePIP()
	}
}

#Preview {
	NavigationStack {
		VideoPlayerView(
			video: Video(
				title: "HLS 영상",
				source: .remote(url: URL(string: "https://demo.unified-streaming.com/k8s/features/stable/video/tears-of-steel/tears-of-steel.ism/.m3u8")!)
			)
		)
	}
}
