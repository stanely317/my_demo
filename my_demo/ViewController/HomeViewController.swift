//
//  HomeViewController.swift
//  my_demo
//
//  Created by Class on 2022/4/6.
//
import UIKit
import Firebase

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {


    @IBOutlet weak var myCollectionView: UICollectionView!
    @IBOutlet weak var myCollectionViewFlowLayout: UICollectionViewFlowLayout!
    var obj: results?
    var fullScreenSize :CGSize!
    
    func configureCellSize(collectionViewWidth: CGFloat) {
            
            let layout = myCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
            layout?.estimatedItemSize = .zero
            layout?.minimumInteritemSpacing = 2
            let width = (collectionViewWidth / 2) - layout!.minimumLineSpacing
            layout?.itemSize = CGSize(width: width, height: width)
                    
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        configureCellSize(collectionViewWidth: UIScreen.main.bounds.width)
        fullScreenSize = UIScreen.main.bounds.size
        let nib = UINib(nibName: "myCollectionViewCell", bundle: nil)
        self.myCollectionView.register(nib, forCellWithReuseIdentifier: "myCollectionViewCell")
        
        obj = jsonfiledecode()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        /* identifier必須設定與Indentity inspector的Storyboard ID相同 */
        if let ChatroomVC = self.storyboard?.instantiateViewController(withIdentifier: "ChatroomVC") as? ChatroomViewController {
            ChatroomVC.modalPresentationStyle = .fullScreen
                present(ChatroomVC, animated: true, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        var reusableView = UICollectionReusableView()
        // 取得元件屬於header/footer，就依照當初storyboard設定的ID來取得對應物件
        if kind == UICollectionView.elementKindSectionHeader {
            reusableView =
                collectionView.dequeueReusableSupplementaryView(
                    ofKind: UICollectionView.elementKindSectionHeader,
                    withReuseIdentifier: "mycellheader", for: indexPath)
        }
        return reusableView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        print("set header size!!!")
        var size = CGSize(width: 0, height: 0)
        if Auth.auth().currentUser != nil{
            size.height = 40
            size.width = UIScreen.main.bounds.width
            print("size of header=",size)
        }else{
            print("size of header=",size)
        }
        return size
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (obj?.stream_list.count)!
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCollectionViewCell", for: indexPath) as! myCollectionViewCell
        
        let task = URLSession.shared.dataTask(with: obj!.stream_list[indexPath.row].head_photo!) { (data, response, error) in
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
        
        cell.nickname.text = obj!.stream_list[indexPath.row].nickname!
        cell.online_num.text = String(obj!.stream_list[indexPath.row].online_num!)
        if obj!.stream_list[indexPath.row].tags != nil {
            cell.tag1.text = "#" + obj!.stream_list[indexPath.row].tags!
        }
        cell.StreamTitle.text = obj?.stream_list[indexPath.row].stream_title
    
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.myCollectionView.reloadData()
    }

}
