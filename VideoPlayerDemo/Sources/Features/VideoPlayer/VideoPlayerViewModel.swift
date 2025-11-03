//
//  VideoPlayerViewModel.swift
//  VideoPlayerDemo
//
//  Created by 송영훈 on 11/2/25.
//

import AVFoundation
import Combine

class VideoPlayerViewModel: ObservableObject {

	@Published var isPlaying: Bool = false
	@Published var duration: TimeInterval = 0.0
	@Published var currentTime: TimeInterval = 0.0
	let player: AVPlayer
	var timeObserver: Any?

	init(video: Video) {
		guard let url = video.source.url else {
			self.player = AVPlayer()
			return
		}
		self.player = AVPlayer(url: url)

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
		let interval = CMTime(value: 1, timescale: 2)
		timeObserver = player.addPeriodicTimeObserver(
			forInterval: interval,
			queue: .main
		) { [weak self] time in
			guard let self else { return }

			Task { @MainActor in
				currentTime = time.seconds
				duration = player.currentItem?.duration.seconds ?? 0.0
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
