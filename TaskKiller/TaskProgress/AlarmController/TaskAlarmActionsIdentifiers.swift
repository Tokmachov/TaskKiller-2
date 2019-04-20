protocol Category {
    var id: String { get }
}

struct TaskTimeOutActionsIDs {
    let openApp = "OpenApp"
    let addBreak = "needBreak"
    let addWorkTime = "needMoreTime"
    let taskIsFinished = "taskIsFinished"
    let setWorkTimes = "setWorkTimes"
}

struct BreakTimeOutActionsIDs {
    let getBackToTask = "getBackToTask"
    let needBreak = "needBreak"
    let openApp = "OpenApp"
    let taskIsFinished = "taskIsFinished"
    let setBreakTimes = "setBreakTimes"
}

struct CategoriesInfo {
    static let taskTimeOutCategory  = TaskTimeIsUpCategory()
    static let breakTimeOutCategory = BreakTimeIsUpCategory()
}

struct TaskTimeIsUpCategory: Category {
    var id: String = "TaskTimeOutCategory"
    var actionIDs = TaskTimeOutActionsIDs()
}

struct BreakTimeIsUpCategory: Category {
    var id: String = "BreakIsOverCategory"
    var actionIDs = BreakTimeOutActionsIDs()
}

