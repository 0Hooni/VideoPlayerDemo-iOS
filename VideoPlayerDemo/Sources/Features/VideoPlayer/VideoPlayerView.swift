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
			VideoPlayerLayerView(player: viewModel.player)
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
				seekBarView
			}

		}
		.ignoresSafeArea(.all)
		.onAppear {
			resetControlsTimer()
		}
		.onDisappear {
			controlsTimer?.invalidate()
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

	var seekBarView: some View {
		VStack {
			Spacer()
			
			SeekBar(
				currentTime: $viewModel.currentTime,
				duration: $viewModel.duration
			)
			.padding(.bottom, 16)
		}
		.ignoresSafeArea(.all)
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
			withAnimation(.easeInOut(duration: 0.3)) {
				showControls = false
			}
		}
	}
}

#Preview {
    VideoPlayerView(
		video: Video(
			title: "Dog 15s",
			source: .local(fileName: "dog 60s", ext: "mp4")
		)
	)
}
