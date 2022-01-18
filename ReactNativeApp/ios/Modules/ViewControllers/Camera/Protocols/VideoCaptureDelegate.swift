//
//  VideoCaptureDelegate.swift
//  jogo
//
//  Created by Muhammad Nauman on 29/11/2020.
//

import Foundation
import AVFoundation

// The delegate used to send the frame from the Camera frame delegate in the VideoCapture to the CVC and
// ahead in the frame processing pipeline.
protocol VideoCaptureDelegate: AnyObject {
  func didReceiveFrame(frame: CMSampleBuffer, orientation: UIImage.Orientation)
}
