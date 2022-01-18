//
//  DrawingManager.swift
//  jogo
//
//  Created by Muhammad Nauman on 17/06/2021.
//

/*
 RecyclerView  -> UICollectionView
 Adapter       -> UICollectionViewDataSource
 ViewHolder    -> UICollectionViewCell
 LayoutManager -> UICollectionViewLayout

 */

import Foundation

class DrawingManager {
  
  private static var shared: DrawingManager?
  var textY: CGFloat = 8
  
  public static func get() -> DrawingManager {
    if DrawingManager.shared == nil {
      DrawingManager.shared = DrawingManager()
    }
    return DrawingManager.shared!
  }
  
  public static func remove() {
    if DrawingManager.shared != nil {
      DrawingManager.shared = nil
    }
  }
  
  private init() {}
  
  func drawPointWithLabel(view: UIView, point: CGPoint, radius: CGFloat, label: String, color: UIColor) {
    drawPoint(view: view, point: point, with: radius)
    drawText(view: view, origin: point, label: label, color: color)
  }
  
  func drawLineOnY(view: UIView, y: Double, color: UIColor, width: CGFloat = 2) {
    drawLine(view: view, point1: CGPoint(x: 0, y: y), point2: CGPoint(x: 1, y: y), color: color, width: width)
  }
  
  func drawLineOnX(view: UIView, x: Double, color: UIColor, width: CGFloat = 2) {
    drawLine(view: view, point1: CGPoint(x: x, y: 0), point2: CGPoint(x: x, y: 1), color: color, width: width)
  }
  
  public func drawHollowRect(view: UIView, rect: CGRect, color: UIColor = .yellow, borderWidth: CGFloat = 1.0) {
    // This thing shoulde be in draw(_: rect) function for it to be the ideal case scenario for drawing rects.
      let layer = CAShapeLayer()

      let drawableRect: CGRect = CGRect(x: rect.minX * view.frame.width,
                                        y: rect.minY * view.frame.height,
                                        width: rect.width * view.frame.width,
                                        height: rect.height * view.frame.height)
      let bpath: UIBezierPath = UIBezierPath(rect: drawableRect)
      layer.path = bpath.cgPath
      layer.strokeColor = color.cgColor
      layer.lineWidth = borderWidth
      layer.fillColor = UIColor.clear.cgColor
      view.layer.addSublayer(layer)
  }
  
  public func drawFilledRect(view: UIView, rect: CGRect, color: CGColor) {
    let layer = CAShapeLayer()

    let drawableRect: CGRect = CGRect(x: rect.minX * view.frame.width,
                                      y: rect.minY * view.frame.height,
                                      width: rect.width * view.frame.width,
                                      height: rect.height * view.frame.height)
    let bpath: UIBezierPath = UIBezierPath(rect: drawableRect)
    layer.path = bpath.cgPath
    layer.strokeColor = color
    layer.fillColor = color
    view.layer.addSublayer(layer)
  }
  
  func drawLine(view: UIView, point1: CGPoint, point2: CGPoint, color: UIColor, width: CGFloat = 2) {
    let path = UIBezierPath()
    path.move(to: CGPoint(x: point1.x * view.frame.width, y: point1.y * view.frame.height))
    path.addLine(to: CGPoint(x: point2.x * view.frame.width, y: point2.y * view.frame.height))

    let shapeLayer = CAShapeLayer()
    shapeLayer.path = path.cgPath
    shapeLayer.strokeColor = color.cgColor
    shapeLayer.lineWidth = width
    view.layer.addSublayer(shapeLayer)
  }
  
  func drawPoint(view: UIView, point: CGPoint, with radius : CGFloat, color: UIColor = .red) {
    let xCoord = point.x * view.frame.width
    let yCoord = point.y * view.frame.height
    let dotPath = UIBezierPath(ovalIn: CGRect(x: xCoord, y: yCoord, width: radius, height: radius))
    let layer = CAShapeLayer()
    layer.path = dotPath.cgPath
    layer.strokeColor = color.cgColor
    layer.fillColor = color.cgColor
    view.layer.addSublayer(layer)
  }
  
  func drawCircle(view: UIView,
                  center: CGPoint,
                  with radius: CGFloat,
                  lineWidth: CGFloat = 5.0,
                  color: UIColor = .red,
                  hollow: Bool = false) {
    let rad = radius * (view.frame.width + view.frame.height) / 2
    let xCoord = (center.x * view.frame.width) - rad
    let yCoord = (center.y * view.frame.height) - rad
    let dotPath = UIBezierPath(ovalIn: CGRect(x: xCoord, y: yCoord, width: rad * 2.0, height: rad * 2.0))
    let layer = CAShapeLayer()
    layer.path = dotPath.cgPath
    layer.lineWidth = lineWidth
    layer.strokeColor = color.cgColor
    if !hollow {
      layer.fillColor = color.cgColor
    } else {
      layer.fillColor = UIColor.clear.cgColor
    }
    view.layer.addSublayer(layer)
  }
  
  func drawText(view: UIView,
                origin: CGPoint?,
                label: String,
                color: UIColor = .yellow,
                fontSize: CGFloat = 12,
                backColor: UIColor = .clear,
                fontName: String? = nil) {

    let textLayer = CATextLayer()
    let stringSize = label.size(OfFont: UIFont(name: (textLayer.font as! UIFont).fontName, size: fontSize)!)
    textLayer.string = label
    if let name = fontName {
      textLayer.font = UIFont(name: name, size: fontSize)
    }
    textLayer.fontSize = fontSize
    textLayer.alignmentMode = .center
    textLayer.foregroundColor = color.cgColor
    textLayer.backgroundColor = backColor.cgColor
    if let point = origin {
      let size = CGSize(width: stringSize.width + 0.05 * stringSize.width,
                        height: stringSize.height + 0.05 * stringSize.height)
      textLayer.frame = CGRect(origin: CGPoint(x: point.x * view.frame.width,
                                               y: point.y * view.frame.height),
                               size: size)
    } else {
      textLayer.frame = CGRect(origin: CGPoint(x: 8, y: textY), size: stringSize)
      self.textY += stringSize.height + 8
    }
    view.layer.addSublayer(textLayer)
  }
  
  func insertLabel(view: UIView, label: UILabel) {
    view.addSubview(label)
  }
  
  func drawArc(view: UIView,
               center: CGPoint,
               radius: CGFloat,
               sweepAngle: CGFloat,
               color: UIColor = ThemeManager.shared.theme.primaryColor,
               width: Int = 5,
               clockwise: Bool = false) {
      let xCoord = center.x * view.frame.width
      let yCoord = center.y * view.frame.height
      let phaseAngle = -CGFloat.pi / 2.0
      let angleInRadians = (sweepAngle * (CGFloat.pi / 180.0)) + phaseAngle
      let arcPath = UIBezierPath(arcCenter: CGPoint(x: xCoord, y: yCoord),
                                 radius: radius,
                                 startAngle: 0 + phaseAngle,
                                 endAngle: angleInRadians,
                                 clockwise: clockwise)
      let layer = CAShapeLayer()
      layer.path = arcPath.cgPath
      layer.strokeColor = color.cgColor
      layer.fillColor = UIColor.clear.cgColor
      layer.lineWidth = 5
      view.layer.addSublayer(layer)
    }
  
  func drawImage(view: UIView, image: UIImage?, x: CGFloat, y: CGFloat, rad: CGFloat) {
    let imageLayer = CALayer()
    imageLayer.contents = image?.cgImage
    imageLayer.frame = CGRect(x: x - rad,
                              y: y - rad,
                              width: rad * 2,
                              height: rad * 2)
    view.layer.addSublayer(imageLayer)
  }
  
  func getValueInRealDP(value: CGFloat, dimensionSize: CGFloat) -> CGFloat {
    if value <= 1 {
      return value * dimensionSize
    }
    return value
  }
}
