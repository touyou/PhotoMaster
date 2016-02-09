//
//  ViewController.swift
//  PhotoMaster
//
//  Created by 藤井陽介 on 2016/02/02.
//  Copyright © 2016年 touyou. All rights reserved.
//

import UIKit
import Social

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var photoImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    // ユーザーの選択に応じた画像選択画面を表示
    func precentPickerController(sourceType: UIImagePickerControllerSourceType) {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = self
        self.presentViewController(picker, animated: true, completion: nil)
    }
    
    // おそらくギャラリーから選択の時に使われている
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        self.dismissViewControllerAnimated(true, completion: nil)
        photoImageView.image = image
    }
    
    // アラートでどこから画像を取得するか
    @IBAction func selectButtonTapped(sender: UIButton) {
        let alertController = UIAlertController(title: "画像の取得先を選択", message: nil, preferredStyle: .ActionSheet)
        let firstAction = UIAlertAction(title: "カメラ", style: .Default) {
            action in
            self.precentPickerController(.Camera)
        }
        let secondAction = UIAlertAction(title: "アルバム", style: .Default) {
            action in
            self.precentPickerController(.PhotoLibrary)
        }
        let cancelAction = UIAlertAction(title: "キャンセル", style: .Cancel, handler: nil)
        
        alertController.addAction(firstAction)
        alertController.addAction(secondAction)
        alertController.addAction(cancelAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    // 文字列の合成
    func drawText(image: UIImage) -> UIImage {
        let text = "Life is Tech!\nXmasCamp2015💖"
        UIGraphicsBeginImageContext(image.size)
        image.drawInRect(CGRectMake(0, 0, image.size.width, image.size.height))
        let textRect = CGRectMake(5, 5, image.size.width - 5, image.size.height - 5)
        let textFontAttributes = [
            NSFontAttributeName: UIFont.boldSystemFontOfSize(120),
            NSForegroundColorAttributeName: UIColor.redColor(),
            NSParagraphStyleAttributeName: NSMutableParagraphStyle.defaultParagraphStyle()
        ]
        text.drawInRect(textRect, withAttributes: textFontAttributes)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    // 画像の合成、素材画像がないため実行不可
    func drawMaskImage(image: UIImage) -> UIImage {
        UIGraphicsBeginImageContext(image.size)
        image.drawInRect(CGRectMake(0, 0, image.size.width, image.size.height))
        let maskImage = UIImage(named: "santa")
        let offset: CGFloat = 50.0
        let maskRect = CGRectMake(
            image.size.width - maskImage!.size.width - offset,
            image.size.height - maskImage!.size.height - offset,
            maskImage!.size.width,
            maskImage!.size.height
        )
        maskImage!.drawInRect(maskRect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    // 単純なアラートをつくる関数
    func simpleAlert(titleString: String) {
        let alertController = UIAlertController(title: titleString, message: nil, preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    // なにを合成するか、サンタマークはないのでかわりにシンプルアラートを出しておく
    @IBAction func processButtonTapped(sender: UIButton) {
        guard let selectedPhoto = photoImageView.image else {
            simpleAlert("画像がありません")
            return
        }
        let alertController = UIAlertController(title: "合成するパーツを選択", message: nil, preferredStyle: .ActionSheet)
        let firstAction = UIAlertAction(title: "テキスト", style: .Default) {
            action in
            self.photoImageView.image = self.drawText(selectedPhoto)
        }
        let secondAction = UIAlertAction(title: "サンタマーク", style: .Default) {
            action in
            // self.photoImageView.image = self.drawMaskImage(selectedPhoto)
            self.simpleAlert("ごめん、素材ない")
        }
        let cancelAction = UIAlertAction(title: "キャンセル", style: .Cancel, handler: nil)
        alertController.addAction(firstAction)
        alertController.addAction(secondAction)
        alertController.addAction(cancelAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    // SNSに投稿する時のフォーマット
    func postToSNS(serviceType: String) {
        let myComposeView = SLComposeViewController(forServiceType: serviceType)
        myComposeView.setInitialText("PhotoMasterからの投稿✨")
        myComposeView.addImage(photoImageView.image)
        self.presentViewController(myComposeView, animated: true, completion: nil)
    }
    
    // どのSNSに投稿するか
    @IBAction func uploadButtonTapped(sender: UIButton) {
        guard let selectedPhoto = photoImageView.image else {
            simpleAlert("画像がありません")
            return
        }
        let alertController = UIAlertController(title: "アップロード先を選択  ", message: nil, preferredStyle: .ActionSheet)
        let firstAction = UIAlertAction(title: "Facebookに投稿", style: .Default) {
            action in
            self.postToSNS(SLServiceTypeFacebook)
        }
        let secondAction = UIAlertAction(title: "Twitterに投稿", style: .Default) {
            action in
            self.postToSNS(SLServiceTypeTwitter)
        }
        let thirdAction = UIAlertAction(title: "カメラロールに保存", style: .Default) {
            action in
            UIImageWriteToSavedPhotosAlbum(selectedPhoto, self, nil, nil)
        }
        let cancelAction = UIAlertAction(title: "キャンセル", style: .Cancel, handler: nil)
        alertController.addAction(firstAction)
        alertController.addAction(secondAction)
        alertController.addAction(thirdAction)
        alertController.addAction(cancelAction)
        presentViewController(alertController, animated: true, completion: nil)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

