
import Foundation

typealias PossibleAdditionalTimesReadable = PossibleAdditionalWorkTimesReadable & PossibleBreakTimesReadable

protocol PossibleAdditionalWorkTimesReadable {
    var possibleAdditionalWorkTimesForIds: [String : TimeInterval] { get }
}

protocol PossibleBreakTimesReadable {
    var possibleBreakTimesForIds: [String : TimeInterval] { get }
}

