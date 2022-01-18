//
//  VideoReader.swift
//  Football433
//
//  Created by Muhammad Nauman on 27/12/2021.
//

import Foundation
import AVFoundation

class VideoReader {
  
  var videoUrl: URL?
  var videoReader: AVAssetReader?
  var videoOutput: AVAssetReaderTrackOutput?
  var timer: Timer?
  var frameSecond: Double?
  // Delegate
  weak var delegate: VideoCaptureDelegate?
  var queue = DispatchQueue(label: "video-output")
  
  init(videoPath: String) {
    if let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
      self.videoUrl = url.appendingPathComponent(videoPath)
      let asset = AVAsset(url: self.videoUrl!)
      let track = asset.tracks(withMediaType: .video)[0]
      let videoReaderSettings : [String : Int] = [kCVPixelBufferPixelFormatTypeKey as String : Int(kCVPixelFormatType_32BGRA)]

      let output = AVAssetReaderTrackOutput(track: track, outputSettings: videoReaderSettings) // nil gets original sample data without overhead for decompression
      guard let reader = try? AVAssetReader(asset: asset) else {return}
      self.videoReader = reader
      self.videoOutput = output
      output.alwaysCopiesSampleData = false // possibly prevents unnecessary copying?
      reader.add(output)
      frameSecond = 1/Double(track.nominalFrameRate)
      ObjectDetectionState.screenSize = track.naturalSize
      self.videoReader!.startReading()
    }
  }
  
  func setUpPreviewView(view: UIView, cameraPosition: AVCaptureDevice.Position) {
    let avPlayer = AVPlayer(url: self.videoUrl!)
    let previewLayer = AVPlayerLayer(player: avPlayer)
    previewLayer.frame = view.bounds
    previewLayer.videoGravity = .resizeAspectFill
    view.backgroundColor = .black
    view.layer.insertSublayer(previewLayer, at: 0)
    previewLayer.player?.play()
  }
  
  @discardableResult
  func startReadingFrames() -> Bool {
    guard self.videoReader != nil, let frameTime = self.frameSecond else {
      return false
    }
    timer = Timer.scheduledTimer(timeInterval: frameTime, target: self, selector: #selector(timerTick), userInfo: nil, repeats: true)
    return true
  }
  
  @objc private func timerTick() {
    self.queue.async { [weak self] in
      if self?.videoReader!.status == .reading {
        if let sampleBuffer = self?.videoOutput?.copyNextSampleBuffer() {
          if let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer){
//            let ciimage = CIImage(cvPixelBuffer: imageBuffer)
//            let image = UIImage(ciImage: ciimage, scale: 1.0, orientation: .up)
            self?.delegate?.didReceiveFrame(frame: sampleBuffer, orientation: .up)
          }
        } else {
          self?.timer?.invalidate()
          self?.timer = nil
        }
      }
    }
  }
  
}
