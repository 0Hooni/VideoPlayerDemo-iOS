//
//  Video.swift
//  VideoPlayerDemo
//
//  Created by 송영훈 on 11/2/25.
//

import Foundation

struct Video: Identifiable {
	let id: UUID
	let title: String
	let source: VideoSource

	init(id: UUID = UUID(), title: String, source: VideoSource) {
		self.id = id
		self.title = title
		self.source = source
	}
}

enum VideoSource {
	case local(fileName: String, ext: String = "mp4")
	case remote(url: URL)

	var url: URL? {
		switch self {
		case .local(let fileName, let ext):
			return Bundle.main.url(forResource: fileName, withExtension: ext)
		case .remote(let url):
			return url
		}
	}
}
