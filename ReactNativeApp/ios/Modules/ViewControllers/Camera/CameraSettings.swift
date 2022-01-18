//
//  CameraSettings.swift
//  jogo
//
//  Created by arham on 01/03/2021.
//

import Foundation
import AVFoundation

// Don't use low, medium and high variants here as they can switch resolutions.
public let cameraResolutions: [String: AVCaptureSession.Preset] = [
//  "low": .low,
//  "medium": .medium,
//  "high": .high,
//  "4k": .hd4K3840x2160,
//  "1920": .hd1920x1080,
//  "1280": .hd1280x720,
//  "vga": .vga640x480,
//  "cif": .cif352x288,
    "default": .photo,
  ]

public let cameraImageSize: [String: [String: CGFloat]] = [
//  "low": ["width": 358.0, "height": 288.0],
//  "medium": ["width": 640.0, "height": 480.0],
//  "high": ["width": 1280.0, "height": 720.0],
  "4k": ["width": 3840.0, "height": 2160.0],
  "1920": ["width": 1920.0, "height": 1080.0],
  "1280": ["width": 1280.0, "height": 720.0],
  "vga": ["width": 640.0, "height": 480.0],
  "cif": ["width": 352.0, "height": 288.0],
]


public let usableResolutions: [String] = ["default"]
