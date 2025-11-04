//
//  PIPController.swift
//  VideoPlayerDemo
//
//  Created by 송영훈 on 11/4/25.
//

import AVKit

class PIPController: NSObject {
	let pipController: AVPictureInPictureController!

	init(with playerLayer: AVPlayerLayer) {
		self.pipController = AVPictureInPictureController(playerLayer: playerLayer)
	}
}

extension PIPController: AVPictureInPictureControllerDelegate {

}
