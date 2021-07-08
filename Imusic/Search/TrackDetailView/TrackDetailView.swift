//
//  TrackDetailView.swift
//  Imusic
//
//  Created by Роман Елфимов on 07.07.2021.
//

import UIKit
import SDWebImage
import AVKit

class TrackDetailView: UIView {
    
    // MARK: - Outlets
    
    @IBOutlet weak var trackImageView: UIImageView!
    @IBOutlet weak var currentTimeSlider: UISlider!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    @IBOutlet weak var trackTitleLabel: UILabel!
    @IBOutlet weak var authorTitleLabel: UILabel!
    
    @IBOutlet weak var playPauseButton: UIButton!
    
    @IBOutlet weak var volumeSlider: UISlider!
    
    let player: AVPlayer = {
        let avPlayer = AVPlayer()
        avPlayer.automaticallyWaitsToMinimizeStalling = false
        return avPlayer
    }()
    
    
    // MARK: - awakeFromNib
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Вначале картинка отображается не на полный экран
        let scale: CGFloat = 0.8
        trackImageView.transform = CGAffineTransform(scaleX: scale, y: scale)
        trackImageView.layer.cornerRadius = 5
        
        trackImageView.backgroundColor = .red
    }
    
    
    // MARK: - Methods
    
    func set(viewModel: SearchViewModel.Cell) {
        trackTitleLabel.text = viewModel.trackName
        authorTitleLabel.text = viewModel.artistName
        
        playTrack(previewUrl: viewModel.previewUrl)
        monitorStartTime()
        observePlayerCurrentTime()
        
        let string600 = viewModel.iconUrlString?.replacingOccurrences(of: "100x100", with: "600x600")
       
        guard let url = URL(string: string600 ?? "") else { return }
        trackImageView.sd_setImage(with: url, completed: nil)
    }
    
    
    private func playTrack(previewUrl: String?) {
        print("Пытаюсь включить трек по ссылке \(previewUrl ?? "Отсутствует")")
        
        guard let url = URL(string: previewUrl ?? "") else { return }
        let playerItem = AVPlayerItem(url: url)
        
        player.replaceCurrentItem(with: playerItem)
        player.play()
    }
    
    
    // MARK: - Animations
    // Картинка увеличивается/уменьшается
    private func enlargeTrackImageView() {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            
            self.trackImageView.transform = .identity
            
        }, completion: nil)
    }
    
    private func reduceTrackImageView() {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            
            let scale: CGFloat = 0.8
            self.trackImageView.transform = CGAffineTransform(scaleX: scale, y: scale)
            
        }, completion: nil)
    }
    
    
    // MARK: - Time Setup
    private func monitorStartTime() {
        
        let time = CMTimeMake(value: 1, timescale: 3)
        let times = [NSValue(time: time)]
        player.addBoundaryTimeObserver(forTimes: times, queue: .main) { [weak self] in
            self?.enlargeTrackImageView()
        }
    }
    
    
    // Текущее время трека
    private func observePlayerCurrentTime() {
        // Срабатывает каждую секунду
        let interval = CMTimeMake(value: 1, timescale: 2)
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            self?.currentTimeLabel.text = time.toDisplayString()
            
            // Сколько всего идет трек
            let durationTime = self?.player.currentItem?.duration
            // Сколько секунд осталось
            let currentDurationText = ((durationTime ?? CMTimeMake(value: 1, timescale: 1)) - time).toDisplayString()
            self?.durationLabel.text = "-\(currentDurationText)"
            self?.updateCurrentTimeSlider()
        }
    }
    
    
    
    private func updateCurrentTimeSlider() {
        // В каком месте сейчас находимся
        let currentTimeSeconds = CMTimeGetSeconds(player.currentTime())
        // Продолжительность всего трека
        let durationSeconds = CMTimeGetSeconds(player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))
        // Соотношение в процентах
        let percentage = currentTimeSeconds / durationSeconds
        self.currentTimeSlider.value = Float(percentage)
    }
    
    
    
    // MARK: - Actions
    
    @IBAction func dragDownButtonTapped(_ sender: Any) {
        
        self.removeFromSuperview()
    }
    
    @IBAction func handleCurrentTimeSlider(_ sender: Any) {
    }
    
    @IBAction func handleVolumeSlider(_ sender: Any) {
    }
    
    
    
    @IBAction func previousTrack(_ sender: Any) {
    }
    
    @IBAction func nextTrack(_ sender: Any) {
    }
    
    @IBAction func playPauseAction(_ sender: Any) {
        if player.timeControlStatus == .paused {
            player.play()
            playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            enlargeTrackImageView()
        } else {
            player.pause()
            playPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            reduceTrackImageView()
        }
    }
    
    
    
}
