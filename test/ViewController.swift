//
//  ViewController.swift
//  test
//
//  Created by Gag Mkrtchyan on 08.01.22.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    let imgArray = ["img_1", "img_2"]
    
    let x = 200
    var timer = Timer()
    var isSelectedPageControl = false
    var allIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        pageControl.currentPage = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer.invalidate()
    }
    
    func scrollToNextCell(){
        
        let cellSize = CGSize(width: self.view.frame.width, height: self.view.frame.width)
        let contentOffset = collectionView.contentOffset
        
        collectionView.scrollRectToVisible(CGRect(x: contentOffset.x + cellSize.width, y: contentOffset.y, width: cellSize.width, height: cellSize.height), animated: true);
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { timer in
            self.scrollToNextCell()
        }
    }
    
    @IBAction func pageControllerAction(_ sender: UIPageControl) {
        timer.invalidate()
        isSelectedPageControl = true
        if sender.currentPage == 0 {
            allIndex -= 1
        } else {
            allIndex += 1
        }
        self.collectionView.scrollToItem(at: IndexPath(row: allIndex, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    @IBAction func action(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController_2") as! ViewController_2
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension ViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return imgArray.count * x
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        
        let itemToShow = imgArray[indexPath.row % imgArray.count]
        cell.imageView.image = UIImage(named: itemToShow)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        allIndex = indexPath.row
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if indexPath.row % 2 == 1 {
            pageControl.currentPage = 0
        } else {
            pageControl.currentPage = 1
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        startTimer()
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        
        if allIndex % 2 == 0 {
            pageControl.currentPage = 0
        } else {
            pageControl.currentPage = 1
        }

        if isSelectedPageControl {
            startTimer()
            isSelectedPageControl = false
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        timer.invalidate()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 150)
    }
}
