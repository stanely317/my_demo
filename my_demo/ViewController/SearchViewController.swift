//
//  SearchViewController.swift
//  my_demo
//
//  Created by Class on 2022/4/6.
//

import UIKit

class SearchViewController: UIViewController ,UISearchBarDelegate {

    @IBOutlet weak var SearchBar: UISearchBar!
    @IBOutlet weak var myCollectionView: UICollectionView!
    @IBOutlet weak var myCollectionViewFlowLayout: UICollectionViewFlowLayout!
    
    var obj: results?
    var fulllist: [StoreItem] = []
    var selectedlist: [StoreItem] = []
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        configureCellSize(collectionViewWidth: UIScreen.main.bounds.width)
        let nib = UINib(nibName: "myCollectionViewCell", bundle: nil)
        self.myCollectionView.register(nib, forCellWithReuseIdentifier: "myCollectionViewCell")
//        self.SearchBar.delegate = self 要記得拉或寫code
        obj = jsonfiledecode()
        fulllist = obj!.lightyear_list
        selectedlist = fulllist
        // 尚未進行搜尋，當進入搜尋介面時，先預設載入完整list內容，後續再依搜尋結果更新
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchText.isEmpty {
            selectedlist = fulllist
        } else {
            selectedlist = obj!.lightyear_list.filter({
                stream_list in stream_list.nickname!.contains(searchText) ||
                stream_list.tags!.contains(searchText) ||
                stream_list.stream_title!.contains(searchText)
            })

        }
        myCollectionView.reloadData()
    }

    // 點擊鍵盤上的Search按鈕時將鍵盤隱藏
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func configureCellSize(collectionViewWidth: CGFloat ){
        
        let itemnumber = 2
        let layout = myCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.estimatedItemSize = .zero
        layout?.minimumInteritemSpacing = 2
        let width = (collectionViewWidth / CGFloat(itemnumber)) - layout!.minimumLineSpacing
        layout?.itemSize = CGSize(width: width, height: width)
    }
    
    // func 跳轉至聊天室
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        /* identifier必須設定與Indentity inspector的Storyboard ID相同 */
        if let ChatroomVC = self.storyboard?.instantiateViewController(withIdentifier: "ChatroomVC") as? ChatroomViewController {
            ChatroomVC.modalPresentationStyle = .fullScreen
                present(ChatroomVC, animated: true, completion: nil)
        }
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (selectedlist.count)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCollectionViewCell", for: indexPath) as! myCollectionViewCell

        // Configure the cell
        let task = URLSession.shared.dataTask(with: selectedlist[indexPath.row].head_photo!) { (data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse,(200...201).contains(httpResponse.statusCode) else {
                DispatchQueue.main.async {
                    cell.LiveImageView.image = UIImage(named: "paopao.png")
                }
                return
                // 跳出 guard else
            }
            if let data = data{
                DispatchQueue.main.async {
                    cell.LiveImageView.image = UIImage(data: data)
                }
            }
        }
        task.resume()
        // 開始執行task
        cell.nickname.text = selectedlist[indexPath.row].nickname!
        cell.online_num.text = String( selectedlist[indexPath.row].online_num!)

    return cell
    }

}

