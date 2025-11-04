//
//  VideoListView.swift
//  VideoPlayerDemo
//
//  Created by 송영훈 on 11/2/25.
//

import SwiftUI

struct VideoListView: View {

	@StateObject private var viewModel: VideoListViewModel

	init() {
		var videos: [Video] = [
			Video(title: "귀여운 강아지", source: .local(fileName: "dog 15s", ext: "mp4")),
			Video(title: "밥 먹는 강이지", source: .local(fileName: "dog 60s", ext: "mp4")),
		]

		if let heavyHlsUrl = URL(string: "https://demo.unified-streaming.com/k8s/features/stable/video/tears-of-steel/tears-of-steel.ism/.m3u8"),
			 let lightHlsUrl = URL(string: "https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8") {
			videos.append(Video(title: "Blender Foundation Presents", source: .remote(url: heavyHlsUrl)))
			videos.append(Video(title: "Big Buck BUNNY", source: .remote(url: lightHlsUrl)))
		}

		_viewModel = StateObject(wrappedValue: VideoListViewModel(videos: videos))
	}

	var body: some View {
		NavigationStack {
			hlsInputSection

			List {
				if !viewModel.localVideos.isEmpty {
					Section("로컬 영상") {
						ForEach(viewModel.localVideos) { video in
							NavigationLink(value: video) {
								VideoRow(video: video, viewModel: viewModel)
							}
						}
					}
				}

				if !viewModel.remoteVideos.isEmpty {
					Section("HLS 영상") {
						ForEach(viewModel.remoteVideos) { video in
							NavigationLink(value: video) {
								VideoRow(video: video, viewModel: viewModel)
							}
						}
					}
				}
			}
			.navigationDestination(for: Video.self) { video in
				VideoPlayerView(video: video)
			}
			.listStyle(.grouped)
			.navigationTitle("비디오 목록")
			.navigationBarTitleDisplayMode(.inline)
		}
	}

	private var hlsInputSection: some View {
		HStack(spacing: 12) {
			TextField("HLS 링크 입력...", text: $viewModel.hlsInputText)
				.textFieldStyle(.roundedBorder)
				.autocapitalization(.none)
				.autocorrectionDisabled()

			Button(action: {
				viewModel.playHLSVideo()
			}) {
				Image(systemName: "play.circle.fill")
					.font(.title2)
			}
			.disabled(viewModel.hlsInputText.isEmpty)
		}
		.padding(.vertical, 8)
		.padding(.horizontal, 20)
	}
}

#Preview {
	VideoListView()
}
