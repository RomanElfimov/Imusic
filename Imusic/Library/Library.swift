//
//  Library.swift
//  Imusic
//
//  Created by Роман Елфимов on 11.07.2021.
//

import SwiftUI
import URLImage

struct Library: View {
    
    @State var tracks = UserDefaults.standard.savedTracks()
    @State private var showingAlert = false
    @State private var track: TrackViewModel.Cell!
    
    var tabBarDelegate: MainTabBarControllerDelegate?
    
    var body: some View {
        
        NavigationView {
            VStack {
                // GeometryReader - расположение кнопок друг относительно друга
                GeometryReader { geometry in
                    
                    // Кнопки в stackView
                    HStack(spacing: 20) {
                        Button {
                            
                            self.track = self.tracks[0]
                            self.tabBarDelegate?.maximizeTrackDetailController(viewModel: self.track)
                            
                        } label: {
                            Image(systemName: "play.fill")
                                .frame(width: abs(geometry.size.width / 2 - 10), height: 50)
                                .accentColor(Color.init(#colorLiteral(red: 0.9369474649, green: 0.3679848909, blue: 0.426604867, alpha: 1)))
                                .background(Color.init(#colorLiteral(red: 0.9242787957, green: 0.9187844396, blue: 0.9285023808, alpha: 1)))
                                .cornerRadius(10)
                        }
                        
                        Button {
                            
                            self.tracks = UserDefaults.standard.savedTracks()
                            
                        } label: {
                            Image(systemName: "arrow.2.circlepath")
                                .frame(width: abs(geometry.size.width / 2 - 10), height: 50)
                                .accentColor(Color.init(#colorLiteral(red: 0.9369474649, green: 0.3679848909, blue: 0.426604867, alpha: 1)))
                                .background(Color.init(#colorLiteral(red: 0.9242787957, green: 0.9187844396, blue: 0.9285023808, alpha: 1)))
                                .cornerRadius(10)
                        }
                    }
                }.padding().frame(height: 50)
                
                // Разделяющая полоска
                Divider().padding(.leading).padding(.trailing).padding(.top)
                
                // Двигаем объекты
                //                Spacer()
                
                // Список треков
                List {
                    ForEach(tracks) { track in
                        // Когда долго нажимаем на ячейку
                        LibraryCell(cell: track)
                            .onTapGesture {
                                // Нужен tabBarController
                                let keyWindow = UIApplication.shared.connectedScenes
                                    .filter {
                                        $0.activationState == .foregroundActive
                                    }
                                    .map({$0 as? UIWindowScene})
                                    .compactMap({$0})
                                    .first?.windows
                                    .filter({$0.isKeyWindow}).first
                                let tabBarVC = keyWindow?.rootViewController as? MainTabBarController
                                tabBarVC?.trackDetailView.delegate = self
                                
                                self.track = track
                                self.tabBarDelegate?.maximizeTrackDetailController(viewModel: self.track)
                            }
                        
                    }
                    .onDelete(perform: delete)
                }
                
            }.actionSheet(isPresented: $showingAlert, content: {
                ActionSheet(title: Text("Уверены что хотите удалить?"), buttons: [.destructive(Text("Удалить"), action: {
                    self.delete(track: track)
                }), .cancel()
                                                                                 ])
            })
            
            .navigationBarTitle("Медиатека")
        }
        
    }
    
    // For row swipe
    func delete(at offsets: IndexSet) {
        tracks.remove(atOffsets: offsets)
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: tracks, requiringSecureCoding: false) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: UserDefaults.favouriteTrackKey)
        }
    }
    
    // For long press gesture
    func delete(track: TrackViewModel.Cell) {
        let index = tracks.firstIndex(of: track)
        
        guard let myIndex = index else { return }
        tracks.remove(at: myIndex)
        
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: tracks, requiringSecureCoding: false) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: UserDefaults.favouriteTrackKey)
        }
    }
}

// Ячейка с одним треком
struct LibraryCell: View {
    
    var cell: TrackViewModel.Cell
    
    var body: some View {
        
        HStack {
            
            URLImage(URL(string: cell.iconUrlString ?? "")!) { image in
                image
                    .resizable()
                    .frame(width: 60, height: 60).cornerRadius(2)
            }
            
            VStack(alignment: .leading) {
                Text("\(cell.trackName)")
                Text("\(cell.artistName)")
            }
        }
        
    }
}

struct Library_Previews: PreviewProvider {
    static var previews: some View {
        Library()
    }
}

extension Library: TrackMovingDelegate {
    
    func moveBackForPreviousTrack() -> TrackViewModel.Cell? {
        let index = tracks.firstIndex(of: track)
        guard let myIndex = index else { return nil }
        var nextTrack: TrackViewModel.Cell
        
        if myIndex - 1 == -1 {
            nextTrack = tracks[tracks.count - 1]
        } else {
            nextTrack = tracks[myIndex - 1]
        }
        
        self.track = nextTrack
        return nextTrack
    }
    
    func moveForwardForNextTrack() -> TrackViewModel.Cell? {
        
        let index = tracks.firstIndex(of: track)
        guard let myIndex = index else { return nil }
        var nextTrack: TrackViewModel.Cell
        
        if myIndex + 1 == tracks.count {
            nextTrack = tracks[0]
        } else {
            nextTrack = tracks[myIndex + 1]
        }
        
        self.track = nextTrack
        return nextTrack
    }
    
}
