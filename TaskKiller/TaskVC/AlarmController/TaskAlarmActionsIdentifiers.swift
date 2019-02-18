protocol Category {
    var id: String { get }
}

struct TaskTimeOutActionsIDs {
    let openApp = "OpenApp"
    let needBreak = "needBreak"
    let needMoreTime = "needMoreTime"
    let taskIsFinished = "taskIsFinished"
}

struct BreakTimeOutActionsIDs {
    let getBackToTask = "getBackToTask"
    let needBreak = "needBreak"
    let openApp = "OpenApp"
    let taskIsFinished = "taskIsFinished"
    
}

struct CategoriesInfo {
    static let taskTimeOut  = TaskTimeIsUpCategory()
    static let breakTimeOut = BreakTimeIsUpCategory()
}

struct TaskTimeIsUpCategory: Category {
    var id: String = "TaskTimeOutCategory"
    var actionIDs = TaskTimeOutActionsIDs()
}

struct BreakTimeIsUpCategory: Category {
    var id: String = "BreakIsOverCategory"
    var actionIDs = BreakTimeOutActionsIDs()
}

