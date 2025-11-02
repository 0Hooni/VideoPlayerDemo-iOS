//
//  VideoPlayerViewModel.swift
//  VideoPlayerDemo
//
//  Created by 송영훈 on 11/2/25.
//

import AVFoundation
import Combine

class VideoPlayerViewModel: ObservableObject {

	let player: AVPlayer

	init(video: Video) {
		guard let url = video.source.url else {
			self.player = AVPlayer()
			return
		}
		self.player = AVPlayer(url: url)
	}
}
