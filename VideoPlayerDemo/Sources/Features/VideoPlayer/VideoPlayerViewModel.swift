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

	private let video: Video
	private(set) lazy var player: AVPlayer = {
		guard let url = video.source.url else { return AVPlayer() }
		return AVPlayer(url: url)
	}()
	private var timeObserver: Any?
	private var pipController: PIPController?

	init(video: Video) {
		self.video = video

		addPeriodicTimeObserver()
		setupAudioSession()
	}

	isolated deinit {
		stopMedia()
		removePeriodicTimeObserver()
	}
}

// MARK: - Media Controll utils
extension VideoPlayerViewModel {
	func stopMedia() {
		player.pause()
		stopAudioSession()
	}

	func startMedia() {
		player.play()
		startAudioSession()
	}

	func togglePlaying() {
		if isPlaying { stopMedia() } else { startMedia() }
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

// MARK: - Audio Session utils
extension VideoPlayerViewModel {
	func setupAudioSession() {
		do {
			try AVAudioSession.sharedInstance().setCategory(.playback)
		} catch let error {
			print("Audio session couldn't be configured.", error)
		}
	}

	func startAudioSession() {
		do {
			try AVAudioSession.sharedInstance().setActive(true)
		} catch let error {
			print("Audio session couldn't be activated.", error)
		}
	}

	func stopAudioSession() {
		do {
			try AVAudioSession.sharedInstance().setActive(false)
		} catch let error {
			print("Audio session couldn't be deactivated.", error)
		}
	}
}
