//
//  ChatroomViewController.swift
//  my_demo
//
//  Created by Class on 2022/4/14.
//

import UIKit
import AVFoundation
import Foundation
import Firebase

class ChatroomViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var ChatInputTF: UITextField!
    @IBOutlet weak var ChatroomTableView: UITableView!
    @IBOutlet weak var LeaveChatButton: UIButton!
    @IBOutlet weak var ButtomConstraint: NSLayoutConstraint!
    
    var videoplayer: AVPlayer?
    var videoPlayerLayer: AVPlayerLayer?
    var webSocketTask: URLSessionWebSocketTask?
    var chatpackage = [packages]()
    var username:String = ""
    let fullScreenSize = UIScreen.main.bounds.size
    
    override func viewDidLoad() {
        
        self.ChatroomTableView.transform = CGAffineTransform(rotationAngle: .pi)
        self.connect()
        setupalert()
        let nib = UINib(nibName: "ChatTableViewCell", bundle: nil)
        self.ChatroomTableView.register(nib, forCellReuseIdentifier: "ChatTableViewCell")
        
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupVideo()
        videoplayer?.play()
    }
    
    func setupVideo() {
        let bundlePath = Bundle.main.path(forResource: "hime3", ofType: "mp4")
        guard bundlePath != nil else {
            return
        }
        let url = URL(fileURLWithPath: bundlePath!)
        
        // Create the video player
        let item = AVPlayerItem(url: url)
        videoplayer = AVPlayer(playerItem: item)
        videoPlayerLayer = AVPlayerLayer(player: videoplayer!)
        // Adjust the size and frame
        videoPlayerLayer?.frame = CGRect(x: -self.view.frame.size.width*1.5, y: 0, width: self.view.frame.size.width*4, height: self.view.frame.size.height)
        view.layer.insertSublayer(videoPlayerLayer!, at: 0)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatpackage.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatTableViewCell", for: indexPath) as! ChatTableViewCell
        cell.contentView.transform = CGAffineTransform(rotationAngle: .pi)
        let index = chatpackage.count - 1 - indexPath.row
        let word = Utilities.Senderrole(input: chatpackage[index])
        cell.ChatContentLabel.text = word
        
        return cell
    }
    
    @IBAction func SendMessageButton(_ sender: Any) {
        let tmpmsg = ChatInputTF.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let msg = "{ \"action\": \"N\", \"content\": \"\(tmpmsg!)\" }"
        self.send(message: msg)
        ChatInputTF.text = ""
    }

    
    @IBAction func DidEndOnExit(_ sender: Any) {}
    /* ?????????????????????return???????????????????????? */
    
    @IBAction func TouchDownBackGround(_ sender: Any) {
        ChatInputTF.resignFirstResponder()
    }
    @IBAction func ClickLeaveButton(_ sender: Any) {
        self.disconnect()
    }
    
/*---------------------??????websocket---------------------*/
    func connect() {
        if Auth.auth().currentUser != nil {
            username = "Stanley"
        }else{
            let name = "??????"
            username = name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        }
        guard let url = URL(string: "wss://client-dev.lottcube.asia/ws/chat/chat:app_test?nickname=\(username)") else {
            print("Error: can not create URL")
            return
        }
        let request = URLRequest(url: url)
        webSocketTask = URLSession.shared.webSocketTask(with: request)
        receive()
        webSocketTask?.resume()
    }

    private func receive() {
        webSocketTask?.receive { result in
            switch result {
            case .success(let message):
                switch message {
                case .string(let text):
                    self.dealwithpackage(file: text)
                    print("Received string: \(text)")
                case .data(let data):
                    print("Received data: \(data)")
                @unknown default:
                    fatalError()
                }

            case .failure(let error):
                print("Error in receiving message: \(error)")
            }

            self.receive()
            // call back (recursive)
        }
    }
    // ??????
    func dealwithpackage (file: String) {
        let data = Data(file.utf8)
        do {
            let result = try JSONDecoder().decode(packages.self, from: data)
//            print("result =",result)
            DispatchQueue.main.async {
                self.ChatroomTableView.reloadData()
            }
            chatpackage.append(result)
        } catch {
            print("Decode package Error!")
        }
}

    func send(message: String) {
        let message = URLSessionWebSocketTask.Message.string(message)
        webSocketTask?.send(message) { error in
            if let error = error {
                print(error)
            }
        }
    }

    // ????????????
    func disconnect() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
    }
    
}




//???????????????????????????URLSessionWebSocketDelegate???
extension ChatroomViewController: URLSessionWebSocketDelegate {
    
    func setupalert() {
        
        LeaveChatButton.addTarget(nil, action: #selector(ChatroomViewController.leavingalert), for: .touchUpInside)
    }
    
    @objc func leavingalert() {
        // ?????????????????????
        let alertController = UIAlertController(title: "", message: "????????????????????????", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "?????????", style: .destructive){_
            in self.dismiss(animated: true)
        }
        alertController.addAction(okAction)
        let cancelAction = UIAlertAction(title: "?????????", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        // ???????????????
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    public func urlSession(_ session: URLSession,
                           webSocketTask: URLSessionWebSocketTask,
                           didOpenWithProtocol protocol: String?) {
        print("URLSessionWebSocketTask is connected")
    }

    public func urlSession(_ session: URLSession,
                           webSocketTask: URLSessionWebSocketTask,
                           didCloseWith closeCode: URLSessionWebSocketTask.CloseCode,
                           reason: Data?) {
        let reasonString: String
        if let reason = reason, let string = String(data: reason, encoding: .utf8) {
            reasonString = string
        } else {
            reasonString = ""
        }
        print("URLSessionWebSocketTask is closed: code=\(closeCode), reason=\(reasonString)")
    }
}


extension ChatroomViewController {
    func addKeyboardObserver() {
        //??????selector?????????????????????????????????????????????????????????????????????NSNotification??????????????????????????????????????????#selector(keyboardWillShow)????????????
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        // ???????????????????????????view?????????????????????????????????view???1/3??????
        // notification.userInfo is dictionary type
        // keyboardframe ??????????????????
        // cgRectValue ???
        // view : ?????????????????????view
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRect = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRect.height
            if ButtomConstraint.constant < keyboardHeight - 34 {
                print("????????????\(ButtomConstraint.constant)")
                ButtomConstraint.constant += keyboardHeight - 34
                print("????????????\(ButtomConstraint.constant)")
            }
            
        } else {
            ButtomConstraint.constant = 302
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        // ???view????????????
        ButtomConstraint.constant = 0
    }
    
    // ????????????????????????????????????????????????
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}
