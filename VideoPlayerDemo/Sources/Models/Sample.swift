//
//  TestData.swift
//  VideoPlayerDemo
//
//  Created by 송영훈 on 11/16/25.
//

struct Sample {
	let videos: [Video] = [
		Video(title: "귀여운 강아지", source: .local(fileName: "dog 15s", ext: "mp4")),
		Video(title: "밥 먹는 강이지", source: .local(fileName: "dog 60s", ext: "mp4")),
		Video(
			title: "Blender Foundation Presents",
			source: .remote(urlString: "https://demo.unified-streaming.com/k8s/features/stable/video/tears-of-steel/tears-of-steel.ism/.m3u8")
		),
		Video(
			title: "Big Buck BUNNY",
			source: .remote(urlString: "https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8")
		)
	]

	var localVideos: [Video] {
		return videos.filter { $0.source.type == .local }
	}

	var remoteVideos: [Video] {
		return videos.filter { $0.source.type == .remote }
	}
}
