//
//  DailyNewsControllerExtension.swift
//  DailyNews
//

import UIKit

extension DailyNewsController: UICollectionViewDelegateFlowLayout {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        
        return self.newsItems.count
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath)
        self.performSegue(withIdentifier: "newsDetailSegue", sender: cell)
        
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let gridCell = collectionView.dequeueReusableCell(withReuseIdentifier: "DailyNewsItemCell",
                                                          for: indexPath) as? DailyNewsItemCell
        let listCell = collectionView.dequeueReusableCell(withReuseIdentifier: "DailyNewsItemListCell",
                                                          for: indexPath) as? DailyNewsItemListCell
        
        switch collectionView.collectionViewLayout {
            
        case is DailySourceItemListLayout:
            listCell?.newsArticleTitleLabel.text = newsItems[indexPath.row].title
            listCell?.newsArticleAuthorLabel.text = newsItems[indexPath.row].author
            listCell?.newsArticleTimeLabel.text = newsItems[indexPath.row].publishedAt.dateFromTimestamp?.relativelyFormattedShort
            listCell?.newsArticleImageView.downloadedFromLink(newsItems[indexPath.row].urlToImage)
            return listCell!
            
        default:
            gridCell?.newsItemTitleLabel.text = newsItems[indexPath.row].title
            gridCell?.newsItemSourceLabel.text = newsItems[indexPath.row].author
            gridCell?.newsItemImageView.downloadedFromLink(newsItems[indexPath.row].urlToImage)
            return gridCell!
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 viewForSupplementaryElementOfKind kind: String,
                                 at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
            
        case UICollectionView.elementKindSectionHeader:
            
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             withReuseIdentifier: "newsHeaderCell",
                                                                             for: indexPath) as? NewHeaderCollectionReusableView
            
            headerView?.newSourceImageView.downloadedFromLink(self.newsSourceUrlLogo!)
            headerView?.layer.masksToBounds = true
            return headerView!
            
        case UICollectionView.elementKindSectionFooter:
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             withReuseIdentifier: "newsFooterCell",
                                                                             for: indexPath)
            
            return footerView
            
        default:
            
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height / 8)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 10)
    }
}
