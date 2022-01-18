//
//  AVCaptureDevice.swift
//  jogo
//
//  Created by arham on 15/09/2021.
//

import Foundation
import AVFoundation

// MARK: AVCapture Extension

extension AVCaptureDevice {
    func set(frameRate: Double) {
    guard let range = activeFormat.videoSupportedFrameRateRanges.first,
        range.minFrameRate...range.maxFrameRate ~= frameRate
        else {
            print("Requested FPS is not supported by the device's activeFormat !")
            return
    }

    do { try lockForConfiguration()
        activeVideoMinFrameDuration = CMTimeMake(value: 1, timescale: Int32(frameRate))
        activeVideoMaxFrameDuration = CMTimeMake(value: 1, timescale: Int32(frameRate))
        unlockForConfiguration()
    } catch {
      Logger.shared.logError(logType: .WARN, error: error, extraMsg: "LockForConfiguration failed with error")
    }
  }
}
