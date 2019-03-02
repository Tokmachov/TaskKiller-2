
import Foundation

typealias SwitchedOnAdditionalTimesReadable = SwitchedOnWorkTimesReadable & SwitchedOnBreakTimesReadable

protocol SwitchedOnWorkTimesReadable {
    var workTimesWithIds: [Id : AdditionalTimeValue] { get }
}

protocol SwitchedOnBreakTimesReadable {
    var breakTimesWithIds: [Id : AdditionalTimeValue] { get }
}

