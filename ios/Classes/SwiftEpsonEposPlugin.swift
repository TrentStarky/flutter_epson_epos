import Flutter
import UIKit


// struct EpsonEposPrinterInfo: Codable {
//     var ipAddress: String?
//     var bdAddress: String?
//     var macAddress: String?
//     var model: String?
//     var type: String?
//     var printType: String?
//     var target: String?
//
//     init(ipAddress: String? = nil, bdAddress: String? = nil, macAddress: String? = nil, model: String? = nil, type: String? = nil, printType: String? = nil, target: String? = nil) {
//         self.ipAddress = ipAddress
//         self.bdAddress = bdAddress
//         self.macAddress = macAddress
//         self.model = model
//         self.type = type
//         self.printType = printType
//         self.target = target
//     }
// }
//
// struct EpsonEposPrinterResult: Codable {
//     var type: String?
//     var success: Bool?
//     var message: String?
//     var content: Array<EpsonEposPrinterInfo>?
//
//     init(type: String? = nil, success: Bool? = nil, message: String? = nil, content: Array<EpsonEposPrinterInfo>? = nil) {
//         self.type = type
//         self.success = success
//         self.message = message
//         self.content = content
//     }
// }


public class SwiftEpsonEposPlugin: NSObject, FlutterPlugin/*, Epos2DiscoveryDelegate*/ {
//     public func onDiscovery(_ deviceInfo: Epos2DeviceInfo!) {
//         if (deviceInfo?.deviceName != nil && deviceInfo?.deviceName != "") {
//             var printer = EpsonEposPrinterInfo.init(ipAddress: deviceInfo.ipAddress,  bdAddress: deviceInfo.bdAddress , macAddress: deviceInfo.macAddress,  model: deviceInfo.deviceName , type: String(deviceInfo.deviceType), printType: String(deviceInfo.deviceType)  , target: deviceInfo.target)
//             var printerIndex = printers.firstIndex(where: {$0.ipAddress == deviceInfo.ipAddress}) ?? -1
//             if (printerIndex > -1) {
//                 printers[printerIndex] = printer
//             } else {
//                 printers.append(printer)
//             }
//         }
//     }
//

//    private var printers: Array<EpsonEposPrinterInfo> = []

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "epson_epos", binaryMessenger: registrar.messenger())
        let instance = SwiftEpsonEposPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {}

//     public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
//         switch call.method {
//         case "onDiscovery":
//             onDiscovery(call, result)
//         case "onPrint":
//             onPrint(call, result)
//         case "onGetPrinterInfo":
//             onGetPrinterInfo(call, result)
//         case "isPrinterConnected":
//             isPrinterConnected(call, result)
//         case "getPrinterString":
//             getPrinterString(call, result)
//         case "setPrinterString":
//             setPrinterString(call, result)
//         default:
//             result(FlutterMethodNotImplemented)
//         }
//         //        result("iOS " + UIDevice.current.systemVersion)
//     }
//
//     private func onDiscovery(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
//         if let args = call.arguments as? Dictionary<String, Any> {
//             if let printType = args["type"] as? String {
//                 switch printType {
//                 case "TCP":
//                     onDiscoveryTCP(call, result)
//                 case "BT":
//                     onDiscoveryBT(call, result)
//                 case "USB":
//                     onDiscoveryUSB(call, result)
//                 default:
//                     result(FlutterMethodNotImplemented)
//                 }
//             }
//         }
//     }
//
//     private func onPrint(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
//
//     }
//
//     private func onGetPrinterInfo(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
//
//     }
//
//     private func isPrinterConnected(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
//
//     }
//
//     private func getPrinterString(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
//
//     }
//
//     private func setPrinterString(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
//
//     }
//
//
//     private func onDiscoveryTCP(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {}
//
//     private func onDiscoveryBT(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
//         printers.removeAll()
//         let filter = Epos2FilterOption()
//         filter.deviceType = EPOS2_TYPE_PRINTER.rawValue
//         var resp = EpsonEposPrinterResult.init(type: "onDiscoveryBT", success: false)
//         Epos2Discovery.start(filter, delegate: self)
//         DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
//             resp.success = true
//             resp.message = "Successfully!"
//             resp.content = self.printers
//             do {
//                 try result(JSONEncoder().encode(resp))
//             }
//             catch {
//
//             }
//         }
//     }
//
//     private func onDiscoveryUSB(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {}
}
