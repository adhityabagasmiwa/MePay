//
//  ScannerQRViewController.swift
//  Metrodata
//
//  Created by Adhitya Bagas on 11/10/23.
//

import UIKit
import AVFoundation

class ScannerQRViewController: UIViewController {

    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var cameraBorder: UIImageView!
    
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var capturePhotoOutput: AVCapturePhotoOutput?
    
    weak var presenter: ScannerQRViewToPresenterProtocol?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupCamera()
        
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        captureSession?.stopRunning()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        captureSession?.stopRunning()
    }
    
    @IBAction func onPressBackButton(_ sender: Any) {
        navigatePop()
    }
}

extension ScannerQRViewController {
    
    private func setupCamera() {
        
        if let videoDevice = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .back).devices.first {
            do {
                let videoInput = try AVCaptureDeviceInput(device: videoDevice)
                
                captureSession = AVCaptureSession()
                captureSession?.addInput(videoInput)
                capturePhotoOutput = AVCapturePhotoOutput()
                
                capturePhotoOutput?.maxPhotoQualityPrioritization = .quality
                capturePhotoOutput?.isHighResolutionCaptureEnabled = true
                captureSession?.addOutput(capturePhotoOutput!)
                
                let captureMetadataOutput = AVCaptureMetadataOutput()
                captureSession?.addOutput(captureMetadataOutput)
                
                captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr,AVMetadataObject.ObjectType.face]
                
                videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
                videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
                videoPreviewLayer?.frame = view.layer.bounds
                cameraView.layer.addSublayer(videoPreviewLayer!)
                
                DispatchQueue.global(qos: .background).async {
                    self.captureSession?.startRunning()
                }
            } catch {
                
            }
        }
    }
    
    private func navigateToTransactionPayment(_ data: Transaction) {
        let argument = TransactionDetailArgument(isFromHistoryTransaction: false, data: data)
        let vc = TransactionDetailRouter.createModule(argument: argument)
        navigatePushToPage(vc)
    }
}

extension ScannerQRViewController : AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count == 0 {
            showAlertDialog(title: "Error", message: "QR cannot be detected, please try again!")
            
            return
        }
        
        if let metadataObj = metadataObjects.first as? AVMetadataMachineReadableCodeObject {
            if let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj) {
                cameraBorder.frame = barCodeObject.bounds
                
                if metadataObj.type == .qr {
                    if let result = metadataObj.stringValue {
                        if result.contains("BNI") {
                            let parts = result.split(separator: ".")
                            if parts.count == 4 {
                                let sourceBank = String(parts[0])
                                let id = String(parts[1]).replacingOccurrences(of: "ID", with: "")
                                let merchantName = String(parts[2])
                                let amount = String(parts[3])
                                
                                let transactionQRData = TransactionQR(id: id.toInt(), sourceBank: sourceBank, merchantName: merchantName, amount: amount.toInt())
                                let data = Transaction(
                                    transactionId: transactionQRData.id,
                                    merchantName: transactionQRData.merchantName,
                                    bankName: transactionQRData.sourceBank,
                                    nominal: transactionQRData.amount,
                                    createdAt: Date(),
                                    uid: FirebaseAuthService.shared.getUserId()
                                )
                                navigateToTransactionPayment(data)
                            }
                        }
                    }
                }
            }
        }
    }
}

extension ScannerQRViewController: ScannerQRPresenterToViewProtocol {
    
}
