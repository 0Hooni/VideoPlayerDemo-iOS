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
	@State private var showControls: Bool = true
	@State private var controlsTimer: Timer?

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
			.ignoresSafeArea()
			.onTapGesture {
				toggleControlsVisibility()
			}

			// Control buttons overlay
			if showControls {
				Color.black.opacity(0.3)
					.ignoresSafeArea()
					.onTapGesture {
						toggleControlsVisibility()
					}

				controlButtonsView
				playbackTimeView
			}

		}
		.ignoresSafeArea(.all)
		.toolbar(showControls ? .visible : .hidden)
		.toolbar {
			toolbarItems
		}
		.onAppear {
			resetControlsTimer()
		}
		.onDisappear {
			controlsTimer?.invalidate()
		}
	}

	@ToolbarContentBuilder
	var toolbarItems: some ToolbarContent {
		ToolbarItem(placement: .topBarTrailing) {
			Button(action: pipButtonTapped) {
				Image(systemName: "pip")
			}
		}
	}

	var controlButtonsView: some View {
		HStack(alignment: .center, spacing: 20) {
			MediaControlButton(systemName: "backward.fill") {
				viewModel.seekBackward()
				resetControlsTimer()
			}
			.frame(width: 60, height: 60)
			MediaControlButton(
				systemName: viewModel.isPlaying ? 
				"pause.fill" : "play.fill"
			) {
				viewModel.togglePlaying()
				resetControlsTimer()
			}
			.frame(width: 72, height: 72)
			MediaControlButton(systemName: "forward.fill") {
				viewModel.seekForward()
				resetControlsTimer()
			}
			.frame(width: 60, height: 60)
		}
	}

	var playbackTimeView: some View {
		VStack(spacing: 12) {
			Spacer()

			PlayTimeText(
				currentTime: $viewModel.currentTime,
				duration: $viewModel.duration
			)
			SeekBar(
				currentTime: $viewModel.currentTime,
				duration: $viewModel.duration,
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
			showControls.toggle()
		}

		if showControls {
			resetControlsTimer()
		} else {
			controlsTimer?.invalidate()
		}
	}

	func resetControlsTimer() {
		controlsTimer?.invalidate()

		controlsTimer = Timer.scheduledTimer(
			withTimeInterval: 5.0,
			repeats: false
		) { _ in
			Task { @MainActor in
				withAnimation(.easeInOut(duration: 0.3)) {
					showControls = false
				}
			}
		}
	}

	func pipButtonTapped() {
		
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
