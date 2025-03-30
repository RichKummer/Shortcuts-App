//
//  ContentView.swift
//  Shortcuts-App
//
//  Created by RichK on 12/4/20.
//

import SwiftUI

extension Binding {
    func onChange(_ handler: @escaping () -> Void) -> Binding<Value> {
            Binding(
                get: { self.wrappedValue },
                set: { newValue in
                    self.wrappedValue = newValue
                    handler()
            }
        )
    }
}

struct FilteringList<T: Identifiable, Content: View>: View {
    @State private var filteredItems = [T]()
    @State private var filterString = ""
    
    let listItems: [T]
    let filterKeyPaths: [KeyPath<T, String>]
    let content: (T) -> Content
    
    var body: some View {
        VStack {
            TextField("Search shortcuts", text: $filterString.onChange(applyFilter))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .padding(.bottom, 12)
            
            List(filteredItems, rowContent: content)
                .onAppear(perform: applyFilter)
                .listStyle(InsetGroupedListStyle())
        }
    }
    
    init(_ data: [T], filterKeys: KeyPath<T, String>..., @ViewBuilder rowContent: @escaping (T) -> Content) {
        listItems = data
        filterKeyPaths = filterKeys
        content = rowContent
    }
    
    
    func applyFilter() {
        let cleanedFilter = filterString.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if cleanedFilter.isEmpty {
            filteredItems = listItems
        } else {
            filteredItems = listItems.filter { element in
                filterKeyPaths.contains {
                    element[keyPath: $0]
                        .localizedCaseInsensitiveContains(cleanedFilter)
                }
            }
        }
    }
}

struct ContentView: View {
    let users = Bundle.main.decode([Shortcut].self, from: "shortcuts.json")
    
    var body: some View {
        NavigationView {
            FilteringList(users, filterKeys: \.title, \.key1) { shortcuts in
                HStack {
                    Text(shortcuts.title)
                        .font(.headline)
                    Spacer()
                    Text(shortcuts.key1)
                        .foregroundColor(.secondary)
                        .padding(.trailing, 4)
                    Text(shortcuts.key2)
                        .foregroundColor(.secondary)
                        .padding(.trailing, 0)
                }
            }
            .navigationBarTitle("Figma Shortcuts").padding(.trailing, 8)
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
