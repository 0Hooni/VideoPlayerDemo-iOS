//
//  VideoPlayerViewModel.swift
//  VideoPlayerDemo
//
//  Created by 송영훈 on 11/2/25.
//

import AVFoundation
import AVKit
import Combine
import MediaPlayer

class VideoPlayerViewModel: ObservableObject {

	@Published var video: Video
	@Published var playerStatus: AVPlayer.Status = .unknown
	@Published var isPlaying: Bool = false
	@Published var isDurationLoading: Bool = true
	@Published var showControls: Bool = true
	@Published var controlsTimer: Timer?

	@Published var currentTime: TimeInterval = 0.0
	@Published var bufferedTime: TimeInterval = 0.0

	@Published var isPipActive: Bool = false
	@Published var isPipPossible: Bool = false

	private(set) lazy var player: AVPlayer = {
		guard let url = video.source.url else { return AVPlayer() }
		return AVPlayer(url: url)
	}()
	private var timeObserver: Any?
	private var pipController: PIPController?

	init(video: Video) {
		self.video = video

		setupPlayer()
		addPeriodicTimeObserver()
		setupAudioSession()
		setupRemoteCommands()
	}

	isolated deinit {
		stopMedia()
		removePeriodicTimeObserver()
	}
}

// MARK: - Media Controll utils
extension VideoPlayerViewModel {
	func setupPlayer() {
		player.publisher(for: \.status)
			.receive(on: DispatchQueue.main)
			.print("player.status")
			.assign(to: &$playerStatus)

		player.publisher(for: \.timeControlStatus)
			.receive(on: DispatchQueue.main)
			.map { $0 == .playing }
			.print("isPlaying")
			.assign(to: &$isPlaying)
	}

	func loadDuration() async {
		if video.duration != nil {
			self.isDurationLoading = false
			return
		}

		guard let url = video.source.url else { return }
		let asset = AVURLAsset(url: url)
		do {
			let duration = try await asset.load(.duration)
			video.duration = CMTimeGetSeconds(duration)
		} catch let error {
			print("Failed to load duration for video: \(video.title), error: \(error)")
		}

		isDurationLoading = false
	}

	func toggleControlVisibility() {
		showControls.toggle()
	}

	func offControlVisibility() {
		showControls = false
	}

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

// MARK: - Timer
extension VideoPlayerViewModel {
	func invalidateTimer() {
		controlsTimer?.invalidate()
	}

	func resetTimer() {
		controlsTimer?.invalidate()

		controlsTimer = Timer.scheduledTimer(
			withTimeInterval: 5.0,
			repeats: false
		) { [weak self] timer in
			Task { @MainActor in self?.offControlVisibility() }
		}
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

// MARK: - Now Playing utils
extension VideoPlayerViewModel {
	func setupNowPlaying() {
		var nowPlayingInfo = [String: Any]()

		// 비디오 제목 설정
		nowPlayingInfo[MPMediaItemPropertyTitle] = video.title

		// 썸네일 설정
		if let thumbnailData = video.thumbnail,
		   let thumbnailImage = UIImage(data: thumbnailData) {
			let artwork = MPMediaItemArtwork(boundsSize: thumbnailImage.size) { _ in
				return thumbnailImage
			}
			nowPlayingInfo[MPMediaItemPropertyArtwork] = artwork
		}

		// 재생 시간 정보 설정
		nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = video.duration
		nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = currentTime
		nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = isPlaying ? 1.0 : 0.0

		MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
	}

	func updateNowPlayingInfo() {
		guard var nowPlayingInfo = MPNowPlayingInfoCenter.default().nowPlayingInfo else {
			setupNowPlaying()
			return
		}

		// 동적 정보 업데이트
		nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = video.duration
		nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = currentTime
		nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = isPlaying ? 1.0 : 0.0

		MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
	}

	func setupRemoteCommands() {
		let commandCenter = MPRemoteCommandCenter.shared()

		// Play 커맨드
		commandCenter.playCommand.isEnabled = true
		commandCenter.playCommand.addTarget { [weak self] _ in
			self?.startMedia()
			self?.isPlaying = true
			self?.updateNowPlayingInfo()
			return .success
		}

		// Pause 커맨드
		commandCenter.pauseCommand.isEnabled = true
		commandCenter.pauseCommand.addTarget { [weak self] _ in
			self?.stopMedia()
			self?.isPlaying = false
			self?.updateNowPlayingInfo()
			return .success
		}

		// Toggle Play/Pause 커맨드
		commandCenter.togglePlayPauseCommand.isEnabled = true
		commandCenter.togglePlayPauseCommand.addTarget { [weak self] _ in
			self?.togglePlaying()
			self?.updateNowPlayingInfo()
			return .success
		}

		// Skip Forward 커맨드 (10초)
		commandCenter.skipForwardCommand.isEnabled = true
		commandCenter.skipForwardCommand.preferredIntervals = [10]
		commandCenter.skipForwardCommand.addTarget { [weak self] _ in
			self?.seekForward()
			self?.updateNowPlayingInfo()
			return .success
		}

		// Skip Backward 커맨드 (10초)
		commandCenter.skipBackwardCommand.isEnabled = true
		commandCenter.skipBackwardCommand.preferredIntervals = [10]
		commandCenter.skipBackwardCommand.addTarget { [weak self] _ in
			self?.seekBackward()
			self?.updateNowPlayingInfo()
			return .success
		}

		// Change Playback Position 커맨드
		commandCenter.changePlaybackPositionCommand.isEnabled = true
		commandCenter.changePlaybackPositionCommand.addTarget { [weak self] event in
			guard let self,
				  let event = event as? MPChangePlaybackPositionCommandEvent else {
				return .commandFailed
			}

			let newTime = CMTime(seconds: event.positionTime, preferredTimescale: 1)
			self.player.seek(to: newTime) { completed in
				if completed {
					Task { @MainActor in
						self.updateNowPlayingInfo()
					}
				}
			}
			return .success
		}
	}
}
