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
			switch video.source {
			case .local:
				guard let idx = localVideos.firstIndex(of: video) else { return }
				localVideos[idx].duration = CMTimeGetSeconds(duration)
			case .remote:
				guard let idx = remoteVideos.firstIndex(of: video) else { return }
				remoteVideos[idx].duration = CMTimeGetSeconds(duration)
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
			switch video.source {
			case .local:
				guard let idx = localVideos.firstIndex(of: video) else { return }
				localVideos[idx].thumbnail = data
			case .remote:
				guard let idx = remoteVideos.firstIndex(of: video) else { return }
				remoteVideos[idx].thumbnail = data
			}
		} catch {
			print("Failed to generate thumbnail for video: \(video.title), error: \(error)")
		}
	}
}
