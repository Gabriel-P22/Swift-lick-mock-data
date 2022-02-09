import SwiftUI

struct ContentView: View {
  @ObservedObject var taskStore: TaskStore
  @State var modalIsPresented = false
  
  var body: some View {
    NavigationView {
      List {
        ForEach(taskStore.prioritizedTasks) { index in
          SectionView(prioritizedTasks: self.$taskStore.prioritizedTasks[index])
        }
      }
      .listStyle( GroupedListStyle() )
      .navigationBarTitle("Tasks")
      .navigationBarItems(
        leading: EditButton(),
        trailing:
          Button(
            action: { self.modalIsPresented = true }
          ) {
            Image(systemName: "plus")
          }
      )
    }
    .sheet(isPresented: $modalIsPresented) {
      NewTaskView(taskStore: self.taskStore)
    }
    .onAppear {
      self.loadJSON()
    }
  }
    
  // MARK: - Private Methods
  private func loadJSON() {
    guard let taskJSONURL = Bundle.main.url(forResource: "Task", withExtension: "json"),
      let prioritizedTaskJSONURL = Bundle.main.url(forResource: "PrioritizedTask", withExtension: "json") else {
        
      return
    }
    
    let decoder = JSONDecoder()
    
    do {
      let taskData = try Data(contentsOf: taskJSONURL)
      let task = try decoder.decode(Task.self, from: taskData)
      print(task)
      
      let prioritizedTaskData = try Data(contentsOf: prioritizedTaskJSONURL)
      let prioritizedTask = try decoder.decode(TaskStore.PrioritizedTasks.self, from: prioritizedTaskData)
      print(prioritizedTask)
    } catch let error {
      print(error)
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView( taskStore: TaskStore() )
  }
}
