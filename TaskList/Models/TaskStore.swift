
import Combine
import Foundation

class TaskStore: ObservableObject {
  let tasksJSONURL = URL(fileURLWithPath: "PrioritizedTasks",
                         relativeTo: FileManager.documentsDirectoryURL).appendingPathExtension("json")
  let tasksPListURL = URL(fileURLWithPath: "PrioritizedTasks",
                          relativeTo: FileManager.documentsDirectoryURL).appendingPathExtension("plist")
  
  @Published var prioritizedTasks: [PrioritizedTasks] = [
    PrioritizedTasks(priority: .high, tasks: []),
    PrioritizedTasks(priority: .medium, tasks: []),
    PrioritizedTasks(priority: .low, tasks: []),
    PrioritizedTasks(priority: .no, tasks: [])
    ] {
    didSet {
//      saveJSONPrioritizedTasks()
      savePListPrioritizedTasks()
    }
  }
  
  init() {
//    loadJSONPrioritizedTasks()
    loadPListPrioritizedTasks()
  }
  
  func getIndex(for priority: Task.Priority) -> Int {
    prioritizedTasks.firstIndex { $0.priority == priority }!
  }
  
  private func loadJSONPrioritizedTasks() {
    guard FileManager.default.fileExists(atPath: tasksJSONURL.path) else {
      return
    }
    
    let decoder = JSONDecoder()
    
    do {
      let tasksData = try Data(contentsOf: tasksJSONURL)
      prioritizedTasks = try decoder.decode([PrioritizedTasks].self, from: tasksData)
    } catch let error {
      print(error)
    }
  }
  
  private func saveJSONPrioritizedTasks() {
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted

    do {
      let tasksData = try encoder.encode(prioritizedTasks)
      
      try tasksData.write(to: tasksJSONURL, options: .atomicWrite)
    } catch let error {
      print(error)
    }
  }
  
  private func loadPListPrioritizedTasks() {
    guard FileManager.default.fileExists(atPath: tasksPListURL.path) else {
      return
    }
    
    let decoder = PropertyListDecoder()
    
    do {
      let tasksData = try Data(contentsOf: tasksPListURL)
      prioritizedTasks = try decoder.decode([PrioritizedTasks].self, from: tasksData)
    } catch let error {
      print(error)
    }
  }
  
  private func savePListPrioritizedTasks() {
    let encoder = PropertyListEncoder()
    encoder.outputFormat = .xml
    
    do {
      let tasksData = try encoder.encode(prioritizedTasks)
      
      try tasksData.write(to: tasksPListURL, options: .atomicWrite)
    } catch let error {
      print(error)
    }
  }
  
}

private extension TaskStore.PrioritizedTasks {
  init(priority: Task.Priority, names: [String]) {
    self.init(
      priority: priority,
      tasks: names.map { Task(name: $0) }
    )
  }
}
