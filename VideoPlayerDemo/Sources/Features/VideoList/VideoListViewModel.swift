//
//  VideoListViewModel.swift
//  VideoPlayerDemo
//
//  Created by 송영훈 on 11/3/25.
//

import AVFoundation
import Combine
import SwiftUI

@MainActor
final class VideoListViewModel: ObservableObject {
	@Published var localVideos: [Video] = []
	@Published var remoteVideos: [Video] = []
	@Published var hlsInputText: String = ""

	init(videos: [Video]) {
		videos.forEach {
			if case .local = $0.source {
				localVideos.append($0)
			} else {
				remoteVideos.append($0)
			}
		}
	}

	/// 영상의 길이
	func loadDuration(for video: Video) async {
		guard let url = video.source.url else { return }
		let asset = AVURLAsset(url: url)
		do {
			let duration = try await asset.load(.duration)
			if let videoIdx = localVideos.firstIndex(of: video) {
				localVideos[videoIdx].duration = CMTimeGetSeconds(duration)
			} else if let videoIdx = remoteVideos.firstIndex(of: video) {
				remoteVideos[videoIdx].duration = CMTimeGetSeconds(duration)
			}
		} catch let error {
			print("Failed to load duration for video: \(video.title), error: \(error)")
		}
	}

	/// 영상의 가장 앞부분을 썸네일로 사용
	func loadThumbnail(for video: Video) async {
		guard let url = video.source.url else { return }
		let asset = AVURLAsset(url: url)
		let imageGenerator = AVAssetImageGenerator(asset: asset)
		imageGenerator.appliesPreferredTrackTransform = true

		do {
			let cgImage = try await imageGenerator.image(at: .zero).image
			let data = UIImage(cgImage: cgImage).pngData()
			if let videoIdx = localVideos.firstIndex(of: video) {
				localVideos[videoIdx].thumbnail = data
			} else if let videoIdx = remoteVideos.firstIndex(of: video) {
				remoteVideos[videoIdx].thumbnail = data
			}
		} catch {
			print("Failed to generate thumbnail for video: \(video.title), error: \(error)")
		}
	}

	func playHLSVideo() {}
}
