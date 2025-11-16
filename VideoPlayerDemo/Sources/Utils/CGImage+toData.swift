//
//  CGImage+toData.swift
//  VideoPlayerDemo
//
//  Created by 송영훈 on 11/17/25.
//

import SwiftUI

extension CGImage {
	func toData() -> Data? {
		return UIImage(cgImage: self).pngData()
	}
}
