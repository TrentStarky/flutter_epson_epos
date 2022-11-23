import Flutter
import UIKit


struct EpsonEposPrinterInfo: Codable {
    var ipAddress: String?
    var bdAddress: String?
    var macAddress: String?
    var model: String?
    var type: String?
    var printType: String?
    var target: String?
    
    init(ipAddress: String? = nil, bdAddress: String? = nil, macAddress: String? = nil, model: String? = nil, type: String? = nil, printType: String? = nil, target: String? = nil) {
        self.ipAddress = ipAddress
        self.bdAddress = bdAddress
        self.macAddress = macAddress
        self.model = model
        self.type = type
        self.printType = printType
        self.target = target
    }
}

struct EpsonEposPrinterResult: Codable {
    var type: String?
    var success: Bool?
    var message: String?
    var content: Array<EpsonEposPrinterInfo>?
    
    init(type: String? = nil, success: Bool? = nil, message: String? = nil, content: Array<EpsonEposPrinterInfo>? = nil) {
        self.type = type
        self.success = success
        self.message = message
        self.content = content
    }
}


public class SwiftEpsonEposPlugin: NSObject, FlutterPlugin, Epos2DiscoveryDelegate {
    private var printers: Array<EpsonEposPrinterInfo> = []
    private var mPrinter: Epos2Printer? = nil
    private var mTarget: String? = nil
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "epson_epos", binaryMessenger: registrar.messenger())
        let instance = SwiftEpsonEposPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "onDiscovery":
            onDiscovery(call, result)
        case "onPrint":
            onPrint(call, result)
        case "onGetPrinterInfo":
            onGetPrinterInfo(call, result)
        case "isPrinterConnected":
            isPrinterConnected(call, result)
        case "getPrinterSetting":
            getPrinterSetting(call, result)
        case "setPrinterString":
            setPrinterString(call, result)
        default:
            result(FlutterMethodNotImplemented)
        }
        //        result("iOS " + UIDevice.current.systemVersion)
    }
    
    private func onDiscovery(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        if let args = call.arguments as? Dictionary<String, Any> {
            if let printType = args["type"] as? String {
                switch printType {
                case "TCP":
                    onDiscoveryTCP(call, result)
                case "BT":
                    onDiscoveryBT(call, result)
                case "USB":
                    onDiscoveryUSB(call, result)
                default:
                    result(FlutterMethodNotImplemented)
                }
            }
        }
    }
    
    private func onDiscoveryTCP(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        //DO NOTHING FOR NOW SINCE WE DONT USE THESE ONES
    }
    
    private func onDiscoveryBT(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        printers.removeAll()
        let filter = Epos2FilterOption()
        filter.deviceType = EPOS2_TYPE_PRINTER.rawValue
        var resp = EpsonEposPrinterResult.init(type: "onDiscoveryBT", success: false)
        Epos2Discovery.start(filter, delegate: self)
        DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
            resp.success = true
            resp.message = "Successfully!"
            resp.content = self.printers
            do {
                try result(JSONEncoder().encode(resp))
            }
            catch {
                //TODO: send failure message
            }
        }
    }
    
    private func onDiscoveryUSB(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        //DO NOTHING FOR NOW SINCE WE DONT USE THESE ONES
    }
    
    private func onGetPrinterInfo(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        // DO NOTHING
    }
    
    private func isPrinterConnected(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        // DO NOTHING
    }
    
    private func getPrinterSetting(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        if let args = call.arguments as? Dictionary<String, Any> {
            let type = args["type"] as! String
            let series = args["series"] as! String
            let target = args["target"] as! String
            
            var resp = EpsonEposPrinterResult()
            
            do {
                if (!connectPrinter(target, series)) {
                    resp.success = false
                    resp.message = "Cannot connect to the printer."
                    try result(JSONEncoder().encode(resp))
                    mPrinter!.clearCommandBuffer()
                } else {
                    if (mPrinter != nil) {
                        mPrinter!.clearCommandBuffer()
                    }
                }
            } catch {
                //TODO: send failure message
            }
        }
    }
    
    private func setPrinterString(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        if let args = call.arguments as? Dictionary<String, Any> {
            let type: String = args["type"] as! String
            let series: String = args["series"] as! String
            let target: String = args["target"] as! String
            
            let paperWidth: Int32? = args["paper_width"] as? Int32
            let printDensity: Int32? = args["print_density"] as? Int32
            let printSpeed: Int32? = args["print_speed"] as? Int32
            
            var resp = EpsonEposPrinterResult()
            
            do {
                if (!connectPrinter(target, series)) {
                    resp.success = false
                    resp.message = "Cannot conect to the printer."
                    try result(JSONEncoder().encode(resp))
                    mPrinter!.clearCommandBuffer()
                } else {
                    var settingList = Dictionary<Int32, Int32>()
                    settingList[EPOS2_PRINTER_SETTING_PRINTSPEED.rawValue] = printSpeed ?? EPOS2_PARAM_DEFAULT
                    settingList[EPOS2_PRINTER_SETTING_PRINTDENSITY.rawValue] = printDensity ?? EPOS2_PARAM_DEFAULT
                    
                    var pw: Int32 = 80
                    if (paperWidth != nil) {
                        if (paperWidth != 80 || paperWidth != 58 || paperWidth != 60) {
                            pw = 80
                        } else {
                            pw = paperWidth!
                        }
                    }
                    settingList[EPOS2_PRINTER_SETTING_PAPERWIDTH.rawValue] = pw
                    mPrinter!.setPrinterSetting(Int(EPOS2_PARAM_DEFAULT), setttingList: settingList, delegate: mPrinterSettingListener())
                }
            } catch {
                //TODO: send failure message
                disconnectPrinter()
            }
        }
    }
    
    private func onPrint(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        if let args = call.arguments as? Dictionary<String, Any> {
            let type: String = args["type"] as! String
            let series: String = args["series"] as! String
            let target: String = args["target"] as! String
            
            if let commands: Array<Dictionary<String, Any>> = (call.arguments as! Dictionary<String, Any>)["commands"] as?  Array<Dictionary<String, Any>> {
                var resp = EpsonEposPrinterResult()
                do {
                    if (!connectPrinter(target, series)) {
                        resp.success = false
                        resp.message = "Cannot conect to the printer."
                        try result(JSONEncoder().encode(resp))
                        mPrinter!.clearCommandBuffer()
                    } else {
                        commands.forEach { command in
                            onGenerateCommand(command)
                        }
                        do {
                            let statusInfo: Epos2PrinterStatusInfo? = mPrinter!.getStatus()
                            mPrinter!.sendData(Int(EPOS2_PARAM_DEFAULT))
                            
                            resp.success = true
                            resp.message = "Printed \(target) \(series)"
                            try result(JSONEncoder().encode(resp))
                        } catch {
                            disconnectPrinter()
                        }
                    }
                } catch {
                    //TODO: send failure message
                }
            }
        }
    }
    
    public func onDiscovery(_ deviceInfo: Epos2DeviceInfo!) {
        if (deviceInfo?.deviceName != nil && deviceInfo?.deviceName != "") {
            var printer = EpsonEposPrinterInfo.init(ipAddress: deviceInfo.ipAddress,  bdAddress: deviceInfo.bdAddress , macAddress: deviceInfo.macAddress,  model: deviceInfo.deviceName , type: String(deviceInfo.deviceType), printType: String(deviceInfo.deviceType)  , target: deviceInfo.target)
            var printerIndex = printers.firstIndex(where: {$0.ipAddress == deviceInfo.ipAddress}) ?? -1
            if (printerIndex > -1) {
                printers[printerIndex] = printer
            } else {
                printers.append(printer)
            }
        }
    }
    
    
    private class mPrinterSettingListener: NSObject, Epos2PrinterSettingDelegate {
        func onGetPrinterSetting(_ code: Int32, type: Int32, value: Int32) {
            //Do nothing
        }
        
        func onSetPrinterSetting(_ code: Int32) {
            //Do nothing
        }
    }
    
    private func connectPrinter(_ target: String, _ series: String) -> Bool {
        let printCons = getPrinterConstant(series)
        if (mPrinter == nil || mTarget != target) {
            mPrinter = Epos2Printer(printerSeries: printCons, lang: 0)
            mTarget = target
        }
        
        do {
            let status: Epos2PrinterStatusInfo? = mPrinter!.getStatus()
            if (status?.online != EPOS2_TRUE) {
                mPrinter!.connect(target, timeout: Int(EPOS2_PARAM_DEFAULT))
            }
            mPrinter!.clearCommandBuffer()
        } catch {
            disconnectPrinter()
            
            return false
        }
        return true
    }
    
    private func disconnectPrinter() {
        if (mPrinter == nil) {
            return
        }
        
        do {
            mPrinter!.disconnect()
            mPrinter = nil
            mTarget = nil
        } catch {
            mPrinter!.clearCommandBuffer()
        }
        mPrinter!.clearCommandBuffer()
    }
    
    private func onGenerateCommand(_ command: Dictionary<String, Any>) {
        if (mPrinter == nil) {
            return
        } else {
            if let commandId = command["id"] as? String {
                let commandValue = command["value"]
                
                switch (commandId) {
                case "appendText":
                    mPrinter!.addText(String(describing: commandValue))
                case "printRawData":
                    do {
                        mPrinter!.addCommand(commandValue as? Data)
                    } catch {
                        //Do nothing
                    }
                case "addImage":
                    do {
                        let width = command["width"] as! Int
                        let height = command["height"] as! Int
                        let posX = command["posX"] as! Int
                        let posY = command["posY"] as! Int
//                        let bitmap = convertBase64toBitmap(commandValue as! String)
                        
                        //TODO: add image command here!
                    } catch {
                        //Do nothing
                    }
                case "addFeedLine":
                    mPrinter!.addFeedLine(commandValue as! Int)
                case "addCut":
                    switch (String(describing: commandValue)) {
                    case "CUT_FEED":
                        mPrinter!.addCut(EPOS2_CUT_FEED.rawValue)
                    case "CUT_NO_FEED":
                        mPrinter!.addCut(EPOS2_CUT_NO_FEED.rawValue)
                    case "CUT_RESERVE":
                        mPrinter!.addCut(EPOS2_CUT_RESERVE.rawValue)
                    default:
                        mPrinter!.addCut(EPOS2_PARAM_DEFAULT)
                    }
                case "addLineSpace":
                    mPrinter!.addLineSpace(commandValue as! Int)
                case "addTextAlign":
                    switch (String(describing: commandValue)) {
                    case "LEFT":
                        mPrinter!.addTextAlign(EPOS2_ALIGN_LEFT.rawValue)
                    case "CENTER":
                        mPrinter!.addTextAlign(EPOS2_ALIGN_CENTER.rawValue)
                    case "RIGHT":
                        mPrinter!.addTextAlign(EPOS2_ALIGN_RIGHT.rawValue)
                    default:
                        mPrinter!.addTextAlign(EPOS2_PARAM_DEFAULT)
                    }
                case "addTextFont":
                    switch (String(describing: commandValue)) {
                    case "FONT_A":
                        mPrinter!.addTextFont(EPOS2_FONT_A.rawValue)
                    case "FONT_B":
                        mPrinter!.addTextFont(EPOS2_FONT_B.rawValue)
                    case "FONT_C":
                        mPrinter!.addTextFont(EPOS2_FONT_C.rawValue)
                    case "FONT_D":
                        mPrinter!.addTextFont(EPOS2_FONT_D.rawValue)
                    case "FONT_E":
                        mPrinter!.addTextFont(EPOS2_FONT_E.rawValue)
                    default:
                        mPrinter!.addTextFont(EPOS2_PARAM_DEFAULT)
                    }
                case "addTextSmooth":
                    if (commandValue as! Bool) {
                        mPrinter!.addTextSmooth(EPOS2_TRUE)
                    } else {
                        mPrinter!.addTextSmooth(EPOS2_FALSE)
                    }
                case "addTextSize":
                    let width = command["width"] as! Int
                    let height = command["height"] as! Int
                    mPrinter!.addTextSize(width, height: height)
                case "addTextStyle":
                    let reverse: Bool? = command["reverse"] as? Bool
                    let ul: Bool? = command["ul"] as? Bool
                    let em: Bool? = command["em"] as? Bool
                    let color: String? = command["color"] as? String
                    
                    var reverseValue: Int32
                    var ulValue: Int32
                    var emValue: Int32
                    var colorValue: Int32
                    
                    if (reverse != nil) {
                        if (reverse!) {
                            reverseValue = EPOS2_TRUE
                        } else {
                            reverseValue = EPOS2_FALSE
                        }
                    } else {
                        reverseValue = EPOS2_PARAM_DEFAULT
                    }
                    
                    if (ul != nil) {
                        if (ul!) {
                            ulValue = EPOS2_TRUE
                        } else {
                            ulValue = EPOS2_FALSE
                        }
                    } else {
                        ulValue = EPOS2_PARAM_DEFAULT
                    }
                    
                    if (em != nil) {
                        if (em!) {
                            emValue = EPOS2_TRUE
                        } else {
                            emValue = EPOS2_FALSE
                        }
                    } else {
                        emValue = EPOS2_PARAM_DEFAULT
                    }
                    
                    switch (color) {
                    case "COLOR_NONE":
                        colorValue = EPOS2_COLOR_NONE.rawValue
                    case "COLOR_1":
                        colorValue = EPOS2_COLOR_1.rawValue
                    case "COLOR_2":
                        colorValue = EPOS2_COLOR_2.rawValue
                    case "COLOR_3":
                        colorValue = EPOS2_COLOR_3.rawValue
                    case "COLOR_4":
                        colorValue = EPOS2_COLOR_4.rawValue
                    default:
                        colorValue = EPOS2_PARAM_DEFAULT
                    }
                    
                    mPrinter!.addTextStyle(reverseValue, ul: ulValue, em: emValue, color: colorValue)
                default:
                    print()
                    //Do nothing
                }
            }
            
        }
    }
    
    private func getPrinterConstant(_ series: String) -> Int32 {
        switch (series) {
        case "TM_M10":
            return EPOS2_TM_M10.rawValue
        case "TM_M30":
            return EPOS2_TM_M30.rawValue
        case "TM_M30II":
            return EPOS2_TM_M30II.rawValue
        case "TM_M50":
            return EPOS2_TM_M50.rawValue
        case "TM_P20":
            return EPOS2_TM_P20.rawValue
        case "TM_P60":
            return EPOS2_TM_P60.rawValue
        case "TM_P60II":
            return EPOS2_TM_P60II.rawValue
        case "TM_P80":
            return EPOS2_TM_P80.rawValue
        case "TM_T20":
            return EPOS2_TM_T20.rawValue
        case "TM_T60":
            return EPOS2_TM_T60.rawValue
        case "TM_T70":
            return EPOS2_TM_T70.rawValue
        case "TM_T81":
            return EPOS2_TM_T81.rawValue
        case "TM_T82":
            return EPOS2_TM_T82.rawValue
        case "TM_T83":
            return EPOS2_TM_T83.rawValue
        case "TM_T83III":
            return EPOS2_TM_T83III.rawValue
        case "TM_T88":
            return EPOS2_TM_T88.rawValue
        case "TM_T90":
            return EPOS2_TM_T90.rawValue
        case "TM_T100":
            return EPOS2_TM_T100.rawValue
        case "TM_U220":
            return EPOS2_TM_U220.rawValue
        case "TM_U330":
            return EPOS2_TM_U330.rawValue
        case "TM_L90":
            return EPOS2_TM_L90.rawValue
        case "TM_H6000":
            return EPOS2_TM_H6000.rawValue
        default:
            return 0
        }
    }
    
//    private func convertBase64toBitmap(_ base64Str: String) {
//        //TODO: converter
//    }
    
    
}
