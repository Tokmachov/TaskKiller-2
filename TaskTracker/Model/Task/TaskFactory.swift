//
//  ITaskModelHandlingFactory.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 12.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import Foundation
import CoreData

protocol TaskFactory {
    func makeTask(taskStaticInfo: TaskStaticInfo) -> Task
    func makeTask(taskModel: TaskModel) -> Task
    init(tagFactory: TagFactory)
}

struct TaskFactoryImp: TaskFactory {
    private let tagFactory: TagFactory
    init(tagFactory: TagFactory) {
        self.tagFactory = tagFactory
    }
    func makeTask(taskStaticInfo: TaskStaticInfo) -> Task {
        let taskModel = createTaskModel(from: taskStaticInfo)
        let task = TaskImp(task: taskModel, tagFactory: tagFactory)
        task.addTags(taskStaticInfo.tagsStore)
        PersistanceService.saveContext()
        return task
    }
    func makeTask(taskModel: TaskModel) -> Task {
        return TaskImp(task: taskModel, tagFactory: tagFactory)
    }
}

extension TaskFactoryImp {
    private func createTaskModel(from taskStaticInfo: TaskStaticInfo) -> TaskModel {
        let id = UUID.init().uuidString
        let taskDescription = taskStaticInfo.taskDescription
        let initiaLdeadLine = Int16(taskStaticInfo.initialDeadLine)
        let postponableDeadline = Int16(taskStaticInfo.initialDeadLine)
        let currentDate = Date() as NSDate
        
        let taskModel = TaskModel(context: PersistanceService.context)
        
        taskModel.id = id
        taskModel.taskDescription = taskDescription
        taskModel.initialDeadLine = initiaLdeadLine
        taskModel.postponableDeadLine = postponableDeadline
        taskModel.dateCreated = currentDate

        return taskModel
    }
}

extension TaskFactoryImp {
    struct TaskImp: Task {
        
        private var taskModel: TaskModel
        private var tagFactory: TagFactory
        
        var id: String {
            guard taskModel.id != nil else { fatalError() }
            return taskModel.id!
        }
        var description: String {
            return self.taskModel.taskDescription!
        }
        var initialDeadline: TimeInterval {
            return TimeInterval(taskModel.initialDeadLine)
        }
        var timeSpentInProgress: TimeInterval {
            guard let periods = taskModel.periodsOfProcess?.allObjects as? [PeriodModel] else { return TimeInterval(0) }
            let timeSpentInProgress = getDurationOfPeriods(periods)
            return timeSpentInProgress
        }
        
        var currentDeadline: TimeInterval {
            return TimeInterval(taskModel.postponableDeadLine)
        }
        var tagsStore: ImmutableTagStore {
            guard let tagModels = (taskModel.tags)?.array as? [TagModel] else { return TagStoreImp(tags: [Tag]()) }
            let tagsStore = createTagsStore(tagsModels: tagModels)
            return tagsStore
        }
        
        init(task: TaskModel, tagFactory: TagFactory) {
            self.taskModel = task
            self.tagFactory = tagFactory
        }
        
        func addTags(_ tags: ImmutableTagStore) {
            let tagArray = tags.tags
            let tagModels = NSOrderedSet(array: tagArray.map { tag in
                let tagModel = fetchTagModel(withId: tag.id)
                return tagModel
            })
            taskModel.addToTags(tagModels)
            PersistanceService.saveContext()
        }
        func postponeDeadlineFor(_ timeInterval: TimeInterval) {
            let timeSpentInprogress = timeSpentInProgress
            let newDeadLine = timeInterval + timeSpentInprogress
            setPostponableDeadline(newDeadLine)
        }
        func saveProgressPeriod(_ period: ProgressPeriod) {
            let period = createPeriodModel(from: period)
            taskModel.addToPeriodsOfProcess(period)
            PersistanceService.saveContext()
        }
        private func createTagsStore(tagsModels: [TagModel]) -> TagsStore {
            var tags = [Tag]()
            for tagModel in tagsModels {
                let tag = tagFactory.makeTag(tagModel: tagModel)
                tags.append(tag)
            }
            return TagStoreImp(tags: tags)
        }
        private func createPeriodModel(from taskProgressPeriod: ProgressPeriod) -> PeriodModel {
            let period = PeriodModel(context: PersistanceService.context)
            let dateStarted = taskProgressPeriod.dateStarted as NSDate
            let dateFinished = taskProgressPeriod.dateEnded as NSDate
            period.dateStarted = dateStarted
            period.dateFinished = dateFinished
            return period
        }
        private func getDurationOfPeriods(_ periods: [PeriodModel]) -> TimeInterval {
            var durationOfPeriods: TimeInterval = 0
            for period in periods {
                let dateStarted = period.dateStarted! as Date
                let dateFinished = period.dateFinished! as Date
                let periodTime = dateFinished.timeIntervalSince(dateStarted)
                durationOfPeriods += periodTime
            }
            return durationOfPeriods
        }
        
        private func setPostponableDeadline(_ newDeadline: TimeInterval) {
            taskModel.postponableDeadLine = Int16(newDeadline)
            PersistanceService.saveContext()
        }
        private func fetchTagModel(withId id: String) -> TagModel {
            let fetchRequest: NSFetchRequest<TagModel> = TagModel.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id)
            let fetchedModels = try? PersistanceService.context.fetch(fetchRequest)
            guard let tagModel = fetchedModels?.first else { fatalError() }
            return tagModel
        }
    }
}
