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
	let player: AVPlayer

	init(video: Video) {
		guard let url = video.source.url else {
			self.player = AVPlayer()
			return
		}
		self.player = AVPlayer(url: url)
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

	deinit {
		player.pause()
	}
}
