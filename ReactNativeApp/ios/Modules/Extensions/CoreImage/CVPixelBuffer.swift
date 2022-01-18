//
//  CVPixelBuffer.swift
//  jogo
//
//  Created by arham on 23/04/2021.
//

import Accelerate
import Foundation

// Used for the TFLiteDetector class.
// https://nshipster.com/image-resizing/
extension CVPixelBuffer {
  /// Returns thumbnail by cropping pixel buffer to biggest square and scaling the cropped image
  /// to model dimensions.
  func resized(to size: CGSize ) -> CVPixelBuffer? {

    let imageWidth = CVPixelBufferGetWidth(self)
    let imageHeight = CVPixelBufferGetHeight(self)

    let pixelBufferType = CVPixelBufferGetPixelFormatType(self)

    assert(pixelBufferType == kCVPixelFormatType_32BGRA ||
           pixelBufferType == kCVPixelFormatType_32ARGB)

    let inputImageRowBytes = CVPixelBufferGetBytesPerRow(self)
    let imageChannels = 4

    CVPixelBufferLockBaseAddress(self, CVPixelBufferLockFlags(rawValue: 0))

    // Finds the biggest square in the pixel buffer and advances rows based on it.
    guard let inputBaseAddress = CVPixelBufferGetBaseAddress(self) else {
      return nil
    }

    // Gets vImage Buffer from input image
    var inputVImageBuffer = vImage_Buffer(data: inputBaseAddress, height: UInt(imageHeight), width: UInt(imageWidth), rowBytes: inputImageRowBytes)

    let scaledImageRowBytes = Int(size.width) * imageChannels
    guard  let scaledImageBytes = malloc(Int(size.height) * scaledImageRowBytes) else {
      return nil
    }

    // Allocates a vImage buffer for scaled image.
    var scaledVImageBuffer = vImage_Buffer(data: scaledImageBytes, height: UInt(size.height), width: UInt(size.width), rowBytes: scaledImageRowBytes)

    // Performs the scale operation on input image buffer and stores it in scaled image buffer.
    let scaleError = vImageScale_ARGB8888(&inputVImageBuffer, &scaledVImageBuffer, nil, vImage_Flags(0))

    CVPixelBufferUnlockBaseAddress(self, CVPixelBufferLockFlags(rawValue: 0))

    guard scaleError == kvImageNoError else {
      return nil
    }

    let releaseCallBack: CVPixelBufferReleaseBytesCallback = {mutablePointer, pointer in

      if let pointer = pointer {
        free(UnsafeMutableRawPointer(mutating: pointer))
      }
    }

    var scaledPixelBuffer: CVPixelBuffer?

    // Converts the scaled vImage buffer to CVPixelBuffer
    let conversionStatus = CVPixelBufferCreateWithBytes(nil, Int(size.width), Int(size.height), pixelBufferType, scaledImageBytes, scaledImageRowBytes, releaseCallBack, nil, nil, &scaledPixelBuffer)

    guard conversionStatus == kCVReturnSuccess else {

      free(scaledImageBytes)
      return nil
    }

    return scaledPixelBuffer
  }
  
  
  func resizeImage(to size: CGSize) -> CVPixelBuffer? {
      let sDate = Date()
      let imageWidth = CVPixelBufferGetWidth(self)
      let imageHeight = CVPixelBufferGetHeight(self)

      let pixelBufferType = CVPixelBufferGetPixelFormatType(self)

      assert(pixelBufferType == kCVPixelFormatType_32BGRA ||
             pixelBufferType == kCVPixelFormatType_32ARGB)

      let inputImageRowBytes = CVPixelBufferGetBytesPerRow(self)
      let imageChannels = 4
      let colorSpace = CGColorSpaceCreateDeviceRGB()


      CVPixelBufferLockBaseAddress(self, CVPixelBufferLockFlags(rawValue: 0))

      // Finds the biggest square in the pixel buffer and advances rows based on it.
      guard let inputBaseAddress = CVPixelBufferGetBaseAddress(self) else {
        return nil
      }
      
      let bitmap = CGBitmapInfo(rawValue: CGBitmapInfo.byteOrder32Little.rawValue|CGImageAlphaInfo.premultipliedFirst.rawValue)
      let contextBM = CGContext(data: inputBaseAddress, width: imageWidth, height: imageHeight, bitsPerComponent: 8,
                                        bytesPerRow: inputImageRowBytes, space: colorSpace, bitmapInfo: bitmap.rawValue)
      // Create a Quartz image from the pixel data in the bitmap graphics context
      let quartzImage = contextBM!.makeImage()

      //Unlock the pixel buffer
      CVPixelBufferUnlockBaseAddress(self, CVPixelBufferLockFlags(rawValue: CVOptionFlags(0)))
      
      if quartzImage == nil {
           return nil
      }
      let image: CGImage  = quartzImage!

      let context = CGContext(data: nil,
                              width: Int(size.width),
                              height: Int(size.height),
                              bitsPerComponent: image.bitsPerComponent,
                              bytesPerRow: 0,
                              space: image.colorSpace ?? CGColorSpace(name: CGColorSpace.sRGB)!,
                              bitmapInfo: image.bitmapInfo.rawValue)
      context?.interpolationQuality = .low
      context?.draw(image, in: CGRect(origin: .zero, size: size))
      guard let scaledImage = context?.makeImage() else { return nil }
      let pxbfr = scaledImage.pixelBuffer(pixelFormat: pixelBufferType)
      return pxbfr
  }
  
  func copy() -> CVPixelBuffer {
          precondition(CFGetTypeID(self) == CVPixelBufferGetTypeID(), "copy() cannot be called on a non-CVPixelBuffer")

          var _copy : CVPixelBuffer?
          CVPixelBufferCreate(
              kCFAllocatorDefault,
              CVPixelBufferGetWidth(self),
              CVPixelBufferGetHeight(self),
              CVPixelBufferGetPixelFormatType(self),
              nil,
              &_copy)

          guard let copy = _copy else { fatalError("Could not copy the buffer memory location!!!") }

          CVPixelBufferLockBaseAddress(self, CVPixelBufferLockFlags.readOnly)
          CVPixelBufferLockBaseAddress(copy, CVPixelBufferLockFlags(rawValue: 0))


          let copyBaseAddress = CVPixelBufferGetBaseAddress(copy)
          let currBaseAddress = CVPixelBufferGetBaseAddress(self)

          memcpy(copyBaseAddress, currBaseAddress, CVPixelBufferGetDataSize(copy))

          CVPixelBufferUnlockBaseAddress(copy, CVPixelBufferLockFlags(rawValue: 0))
          CVPixelBufferUnlockBaseAddress(self, CVPixelBufferLockFlags.readOnly)


          return copy
      }
}
