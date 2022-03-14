/**
 
 */



import UIKit
import AVKit
import AVFoundation
import MobileCoreServices
import UniformTypeIdentifiers


class ViewController: UIViewController , UIImagePickerControllerDelegate,
                      UINavigationControllerDelegate
{
    
    @objc var avPlayerViewController: AVPlayerViewController!
    @objc var image: UIImage?
    @objc var movieURL: URL?
    @objc var lastChosenMediaType: String?
    

    
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var takePictureButton: UIButton!
    
    
    
    @IBAction func shootPictureOrVideo(_ sender: UIButton)
    {
        pickMediaFromSource(.camera)
    }
    
    @IBAction func selectExistingPictureOrVideo(_ sender: UIButton)
    {
        pickMediaFromSource(.photoLibrary)
//        self.present(self.imagePicker, animated: true,  completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Start:~~~~");
        if (!UIImagePickerController.isSourceTypeAvailable(.camera))
        {
            takePictureButton.isHidden = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        updateDisplay()
    }
    
    @objc func updateDisplay()
    {
        print("display:~~~~");
        
        if let mediaType = lastChosenMediaType {
            
            
//            UTType.image
            print("type:\(mediaType)");
            if mediaType == "public.image" {
                imageView.image = image!
                imageView.isHidden = false
                if avPlayerViewController != nil {
                    avPlayerViewController!.view.isHidden = true
                }
            } else if mediaType == "public.movie" {
                if avPlayerViewController == nil {
                    avPlayerViewController = AVPlayerViewController()
                    let avPlayerView = avPlayerViewController!.view
                    avPlayerView?.frame = imageView.frame
                    avPlayerView?.clipsToBounds = true
                    view.addSubview(avPlayerView!)
                    setAVPlayerViewLayoutConstraints()
                }

                if let url = movieURL {
                    imageView.isHidden = true
                    avPlayerViewController.player = AVPlayer(url: url)
                    avPlayerViewController!.view.isHidden = false
                    avPlayerViewController!.player!.play()
                }
            }
        }
    }
    
    @objc func setAVPlayerViewLayoutConstraints()
    {
        let avPlayerView = avPlayerViewController!.view
        avPlayerView?.translatesAutoresizingMaskIntoConstraints = false
        let views = ["avPlayerView": avPlayerView!,
                        "takePictureButton": takePictureButton!]
        view.addConstraints(NSLayoutConstraint.constraints(
                        withVisualFormat: "H:|[avPlayerView]|", options: .alignAllLeft,
                        metrics:nil, views:views))
        view.addConstraints(NSLayoutConstraint.constraints(
                        withVisualFormat: "V:|[avPlayerView]-0-[takePictureButton]",
                        options: .alignAllLeft, metrics:nil, views:views))
    }
    
    @objc func pickMediaFromSource(_ sourceType:UIImagePickerController.SourceType)
    {
        let mediaTypes =
              UIImagePickerController.availableMediaTypes(for: sourceType)!
        
        print("pickMediaFromSource:mediaTypes = \(mediaTypes)");
        
        
        
        
        if UIImagePickerController.isSourceTypeAvailable(sourceType)
                    && mediaTypes.count > 0 {
            let picker = UIImagePickerController()
            picker.mediaTypes = mediaTypes
            picker.delegate = self
            picker.allowsEditing = true
            picker.sourceType = sourceType
            present(picker, animated: true, completion: nil)
        } else {
            let alertController = UIAlertController(title:"Error accessing media",
                            message: "Unsupported media source.",
                                                    preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "OK",
                                         style: UIAlertAction.Style.cancel, handler: nil)
                            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        
        lastChosenMediaType = info[UIImagePickerController.InfoKey.mediaType] as? String
        

        print("ipController:lastChosenMediaType = \(lastChosenMediaType)");
        
        if let mediaType = lastChosenMediaType {
            print("ipController:mediaType = \(mediaType)");
            print("UTType: \(UTType.image)")

            if mediaType == (kUTTypeImage as NSString) as String {
            
                self.imageView.image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
            
            
            } else if mediaType == (kUTTypeMovie as NSString) as String {
                movieURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL
            }
        }


        self.dismiss(animated: true, completion: nil)

    }
    

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        picker.dismiss(animated: true, completion:nil)
    }
    
    


}

