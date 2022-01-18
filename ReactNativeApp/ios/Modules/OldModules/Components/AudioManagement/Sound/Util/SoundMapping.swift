//
//  SoundMapping.swift
//  jogo
//
//  Created by arham on 21/09/2021.
//

import Foundation




public class SoundMapping {
  
  struct SoundDef {
    var filename: String
    var ext: String
  }
  
  enum Score {
    case Beep
    case Beep_Two
    case Count
    case Counting
    case Count_Down
    
    var Asset: SoundDef {
      switch self {
      case .Beep:
        return SoundDef(filename: "score_beep", ext: "wav")
      case .Beep_Two:
        return SoundDef(filename: "jogo_beep_two", ext: "wav")
      case .Count:
        return SoundDef(filename: "score_count", ext: "wav")
      case .Counting:
        return SoundDef(filename: "jogo_counting", ext: "mp3")
      case .Count_Down:
        return SoundDef(filename: "count_down_jogo", ext: "wav")
      }
    }
  }
  
  enum Error {
    case Error
    case ConeError
    
    var Asset: SoundDef {
      switch self {
      case .Error:
        return SoundDef(filename: "jogo_error", ext: "mp3")
      case .ConeError:
        return SoundDef(filename: "jogo_cone_error", ext: "mp3")
      }
    }
  }
  
  enum Misc {
    case After
    case Notif
    case GET_IN_POSITION
    
    var Asset: SoundDef {
      switch self {
      case .After:
        return SoundDef(filename: "jogo_aftel", ext: "mp3")
      case .Notif:
        return SoundDef(filename: "jogo_notification", ext: "mp3")
      case .GET_IN_POSITION:
        return SoundDef(filename: "get_in_position", ext: "mp3")
      }
    }
  }
  
}
