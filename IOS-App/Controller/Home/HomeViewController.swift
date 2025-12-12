//
//  ViewController.swift
//  Home-Test
//
//  Created by SDC-USER on 25/11/25.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var HomeViewController: UICollectionView!
    
    var brainBoosters: [BrainBoostersCardModel] = [
        BrainBoostersCardModel(gameName: "Crossword", gameImage: "Group 353"),
        BrainBoostersCardModel(gameName: "Sudoku", gameImage: "Group 354"),
        BrainBoostersCardModel(gameName: "Match the Pairs", gameImage: "Group 355")
    ]
    
    var completedTask: [RoutineCardModel] = [
        RoutineCardModel(title: "Brush teeth", subtitle: "", timeText: "7:45 AM"),
        RoutineCardModel(title: "Have Breakfast", subtitle: "", timeText: "8:00 AM")
    ]
    var pendingTask: [RoutineCardModel] = [
        RoutineCardModel(title: "Take meds", subtitle: "Vitamin B12 - 1 capsule", timeText: "8:45 AM")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        registerCell()
        HomeViewController.dataSource = self
        HomeViewController.delegate = self
        
        let layout = generateLayout()
        HomeViewController.setCollectionViewLayout(layout, animated: true)
    }
    
    func generateLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout(sectionProvider: {section, env in
            
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(40))
            let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: "header", alignment: .top)
            
            if section == 0 {
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(220))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                group.interItemSpacing = .fixed(10)
                
                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 10
                section.contentInsets = NSDirectionalEdgeInsets(top: -15, leading: 20, bottom: 20, trailing: 20)

                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(70))
                let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: "header", alignment: .top)
                section.boundarySupplementaryItems = [headerItem]
                return section
            }
            else if section == 1 {
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.9))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(120))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                group.interItemSpacing = .fixed(10)
                
                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 10
                section.contentInsets = NSDirectionalEdgeInsets(top: -25, leading: 20, bottom: -10, trailing: 20)
//                section.boundarySupplementaryItems = [headerItem]
                return section
            }
            
            else if section == 2 {
                // allow the cell to size itself based on its content
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)   // use a reasonable positive estimate
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)

                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(270)
                )
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
//                group.interItemSpacing = .fixed(10)

                let section = NSCollectionLayoutSection(group: group)
//                section.interGroupSpacing = 10
                section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 20, bottom: 20, trailing: 20)
                section.boundarySupplementaryItems = [headerItem]
                return section
            }

            
            else {
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.6), heightDimension: .fractionalHeight(0.35))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                group.interItemSpacing = .fixed(10)
                
                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 23
                section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 23, bottom: 12, trailing: 20)
                
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))
                let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: "header", alignment: .top)
                
                section.orthogonalScrollingBehavior = .groupPaging
                section.boundarySupplementaryItems = [headerItem]
                return section
            }
        }
        )
        return layout
    }

    
    func registerCell() {
        HomeViewController.register(UINib(nibName: "MemoryRecapCardCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "memoryRecapCardCollectionViewCell")
        
        HomeViewController.register(UINib(nibName: "MemoryLaneCardCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "memoryLaneCardCollectionViewCell")
        
        HomeViewController.register(UINib(nibName: "HeaderView", bundle: nil), forSupplementaryViewOfKind: "header", withReuseIdentifier: "header_cell")
        
        HomeViewController.register(UINib(nibName: "BrainBoostersCardCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "brainBoostersCardCollectionViewCell")
        
        HomeViewController.register(UINib(nibName: "RoutineCardCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "routineCardCollectionViewCell")
    }


}

extension HomeViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        else if section == 1 {
            return 1
        }
        else if section == 2{
            return 1
        }
        else {
            return brainBoosters.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "memoryLaneCardCollectionViewCell", for: indexPath) as! MemoryLaneCardCollectionViewCell
//            let memoryLane = memoryLane[indexPath.row]
            cell.configureMemoryLaneCell()
            return cell
        }
        else if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "memoryRecapCardCollectionViewCell", for: indexPath) as! MemoryRecapCardCollectionViewCell
            cell.configureMemoryRecapCardCell()
            return cell
        }
        
        else if indexPath.section == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "routineCardCollectionViewCell", for: indexPath) as! RoutineCardCollectionViewCell
            cell.configureRoutineCell(completed: completedTask, pending: pendingTask)
            return cell
        }
        
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "brainBoostersCardCollectionViewCell", for: indexPath) as! BrainBoostersCardCollectionViewCell
            let brainBoosters = brainBoosters[indexPath.row]
            cell.configureBrainBoostersCell(brainBooster: brainBoosters)
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        // Create the header view
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: "header", withReuseIdentifier: "header_cell", for: indexPath) as! HeaderView
//        headerView.backgroundColor = .blue
        if indexPath.section == 0 {
            headerView.configureHeaderCell(text: "Memories")
        }
        else if indexPath.section == 1 {
            headerView.configureHeaderCell(text: "Memory Recap")
        }
        
        else if indexPath.section == 2 {
            headerView.configureHeaderCell(text: "My Routine")
        }
        else {
            headerView.configureHeaderCell(text: "Brain Boosters")
        }
        return headerView
    }
    
}

extension HomeViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            performSegue(withIdentifier: "showMemoryRecap", sender: nil)
            return
        }
        
        if indexPath.section == 3 {
            guard indexPath.item >= 0, indexPath.item < brainBoosters.count else { return }

            let model = brainBoosters[indexPath.item]
            let name = model.gameName.lowercased()

            if name.contains("sudoku") {
                performSegue(withIdentifier: "showSudokuInstructions", sender: model)
                return
            }

            if name.contains("match the pairs") || name.contains("match") {
                performSegue(withIdentifier: "showMatchThePairsInstructions", sender: model)
                return
            }

            if name.contains("crossword") {
                performSegue(withIdentifier: "showCrosswordInstructions", sender: model)
                return
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Brain boosters segues (unchanged)
        if let model = sender as? BrainBoostersCardModel {
            if segue.identifier == "showSudokuInstructions",
               let _ = segue.destination as? MatchThePairsInstructionsViewController {

                print("prepare for Sudoku, model:", model.gameName)
            }
            else if segue.identifier == "showMatchThePairsInstructions",
                let _ = segue.destination as? MatchThePairsInstructionsViewController {

                print("prepare for Match the Pairs, model:", model.gameName)
            }
            else if segue.identifier == "showCrosswordInstructions",
                let _ = segue.destination as? MatchThePairsInstructionsViewController {

                print("prepare for Crossword, model:", model.gameName)
            }
            return
        }

        // Memory Recap segue
        if segue.identifier == "showMemoryRecap" {
            // Example destination handling: adjust to your real VC class
            if let recapVC = segue.destination as? BaseViewController {
                // pass data if needed:
                // recapVC.someProperty = ...
                print("Preparing Memory Recap (direct)")
            } else if let nav = segue.destination as? UINavigationController,
                      let recapVC = nav.topViewController as? BaseViewController {
                // If you embed recap in a nav controller in storyboard
                // recapVC.someProperty = ...
                print("Preparing Memory Recap (in nav)")
            } else {
                // If you're using a storyboard reference, the destination may be a different type.
                print("prepare: showMemoryRecap destination is \(type(of: segue.destination))")
            }
        }
    }
}
