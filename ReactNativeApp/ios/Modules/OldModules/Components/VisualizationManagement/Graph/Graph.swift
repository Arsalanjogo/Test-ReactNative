//
//  Graph.swift
//  jogo
//
//  Created by Mohsin on 03/09/2021.
//

import Foundation
import Charts
import RxRelay
import RxSwift

class Graph {
  
  public enum GraphType {
    case line
    
  func initView() -> ChartViewBase {
        switch self {
            case .line:
                return LineChartView()
        }
    }
  }
  
  public var view: ChartViewBase
  public var point = BehaviorRelay<Double>(value: 0)
  
  // Setup
  private var graphType: GraphType
  private var lastX: Double = 0
  private let bag = DisposeBag()
  
  
  // Constants
  private let MAX_POINTS_VISIBLE: Double = 6
  
  // Data
  private let lineData = LineChartData()
  
  init(type: GraphType) {
    graphType = type
    view = graphType.initView()
    setupGraph()
    subscribeToChanges()
  }
  
  private func setupGraph() {
    switch graphType {
    case .line:
      view = setupLineChart(view: view)
    }
  }
  
  private func subscribeToChanges() {
    point
      .asObservable()
      .skip(1) //Skip initial emission
      .buffer(timeSpan: .milliseconds(100), count: 5, scheduler: MainScheduler.instance)
      .subscribe(onNext: { [weak self] value in
        guard let strongSelf = self else { return }
        switch strongSelf.graphType {
          case .line:
            strongSelf.addLineData(point: value.last ?? 0.00)
        }
    })
    .disposed(by: bag)
  }
  
}

//====================
// LineChart
//====================

extension Graph {
  fileprivate func setupLineChart(view: ChartViewBase) -> LineChartView {
    let chart = view as! LineChartView
    chart.frame = CGRect(x: 0, y: 0, width: 200, height: 170)
    chart.pinchZoomEnabled = false
    chart.doubleTapToZoomEnabled = false
    chart.highlightPerDragEnabled = false
    chart.backgroundColor = .black.withAlphaComponent(0.3)
    chart.isUserInteractionEnabled = false
    
    chart.xAxis.drawAxisLineEnabled = false
    chart.xAxis.avoidFirstLastClippingEnabled = true
    
    chart.xAxis.drawLabelsEnabled = false
    chart.leftAxis.drawLabelsEnabled = false
    chart.leftAxis.drawAxisLineEnabled = false
    chart.rightAxis.drawLabelsEnabled = false
    chart.rightAxis.enabled = false
    chart.chartDescription?.enabled = false
    
    chart.xAxis.drawGridLinesEnabled = false
    chart.leftAxis.drawGridLinesEnabled = false
    chart.leftAxis.drawZeroLineEnabled = false
    chart.legend.enabled = false

    let set = LineChartDataSet()

    set.lineWidth = 2
    set.drawCirclesEnabled = false
    set.drawCircleHoleEnabled = false
    set.drawValuesEnabled = false
    set.axisDependency = .left
    set.mode = .cubicBezier
    set.cubicIntensity = 0.2
    set.setColor(ThemeManager.shared.theme.primaryColor)
    
    lineData.addDataSet(set)
    chart.data = lineData
    
    return chart
  }
  
  
  fileprivate func addLineData(point: Double) {

    let chart = view as! LineChartView
    
    lineData.addEntry( ChartDataEntry(x: lastX, y: point), dataSetIndex: 0)
    
    chart.notifyDataSetChanged()
    chart.setVisibleXRangeMaximum(MAX_POINTS_VISIBLE)
    chart.moveViewToX(Double(lineData.entryCount) - MAX_POINTS_VISIBLE)
    
    lastX += 1
  }
}
