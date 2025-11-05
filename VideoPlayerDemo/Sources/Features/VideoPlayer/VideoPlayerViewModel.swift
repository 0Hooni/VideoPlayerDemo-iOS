//
//  VideoPlayerViewModel.swift
//  VideoPlayerDemo
//
//  Created by 송영훈 on 11/2/25.
//

import AVFoundation
import AVKit
import Combine

class VideoPlayerViewModel: ObservableObject {

	@Published var isPlaying: Bool = false
	@Published var duration: TimeInterval = 0.0
	@Published var currentTime: TimeInterval = 0.0
	@Published var bufferedTime: TimeInterval = 0.0

	@Published var isPipActive: Bool = false
	@Published var isPipPossible: Bool = false

	let player: AVPlayer
	var timeObserver: Any?
	var pipController: PIPController?

	init(video: Video) {
		if let url = video.source.url {
			self.player = AVPlayer(url: url)
		} else { self.player = AVPlayer() }

		addPeriodicTimeObserver()
	}

	func togglePlaying() {
		if isPlaying {
			player.pause()
		} else {
			player.play()
		}
		isPlaying.toggle()
	}

	func seekBackward() {
		guard let currentTime = player.currentItem?.currentTime() else { return }
		let newTime = CMTimeSubtract(currentTime, CMTime(seconds: 10, preferredTimescale: 1))
		player.seek(to: newTime)
	}

	func seekForward() {
		guard let currentTime = player.currentItem?.currentTime() else { return }
		let newTime = CMTimeAdd(currentTime, CMTime(seconds: 10, preferredTimescale: 1))
		player.seek(to: newTime)
	}

	func addPeriodicTimeObserver() {
		if let timeObserver { player.removeTimeObserver(timeObserver) }

		let interval = CMTime(value: 1, timescale: 2)
		timeObserver = player.addPeriodicTimeObserver(
			forInterval: interval,
			queue: .main
		) { [weak self] time in
			guard let self else { return }

			Task { @MainActor in
				guard let currentItem = player.currentItem else { return }

				currentTime = time.seconds
				duration = currentItem.duration.seconds
				bufferedTime = currentItem.loadedTimeRanges
					.map { $0.timeRangeValue }
					.map { CMTimeGetSeconds($0.start) + CMTimeGetSeconds($0.duration) }
					.max() ?? 0.0
			}
		}
	}

	func removePeriodicTimeObserver() {
		guard let timeObserver else { return }
		player.removeTimeObserver(timeObserver)
		self.timeObserver = nil
	}

	isolated deinit {
		player.pause()
		removePeriodicTimeObserver()
	}
}

// MARK: - Picture in Picture utils
extension VideoPlayerViewModel {
	func setupPIPController(layer: AVPlayerLayer) {
		pipController = PIPController(with: layer)
		pipController?.onStateChange = { [weak self] in self?.isPipActive = $0 }
		pipController?.onPossibilityChange = { [weak self] in self?.isPipPossible = $0 }
	}

	func togglePIP() {
		pipController?.togglePIP()
	}
}
