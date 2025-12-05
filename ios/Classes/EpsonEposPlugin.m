#import "EpsonEposPlugin.h"

@implementation EpsonEposPlugin
NSMutableArray <EpsonEposPrinterInfo*> *printers;
Epos2Printer *mPrinter = NULL;
NSString *mTarget = NULL;

+ (void)registerWithRegistrar:(nonnull NSObject<FlutterPluginRegistrar> *)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
            methodChannelWithName:@"epson_epos"
                  binaryMessenger:[registrar messenger]];
    EpsonEposPlugin* instance = [[EpsonEposPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
}

+ (void)registerWithRegistar:(NSObject<FlutterPluginRegistrar> *)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
            methodChannelWithName:@"epson_epos"
                  binaryMessenger:[registrar messenger]];
    EpsonEposPlugin* instance = [[EpsonEposPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
}


- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {

    if ([call.method  isEqual: @"onDiscovery"]) {
        [self onDiscovery:call result:result];
    } else if ([call.method  isEqual: @"onPrint"]) {
        [self onPrint:call result:result];
    } else if ([call.method  isEqual: @"onGetPrinterInfo"]) {
        [self onGetPrinterInfo:call result:result];
    } else if ([call.method  isEqual: @"isPrinterConnected"]) {
        [self isPrinterConnected:call result:result];
    } else if ([call.method  isEqual: @"getPrinterSetting"]) {
        [self getPrinterSetting:call result:result];
    } else if ([call.method  isEqual: @"setPrinterString"]) {
        [self setPrinterString:call result:result];
    } else {
        result(FlutterMethodNotImplemented);
    }
}


- (void)onDiscovery:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSDictionary *args = call.arguments;
    NSString *printType = args[@"type"];

    if ([printType isEqual:@"TCP"]) {
        [self onDiscoveryTCP:call result:result];
    } else if ([printType isEqual:@"BT"]) {
        [self onDiscoveryBT:call result:result];
    } else if ([printType isEqual:@"USB"]) {
        [self onDiscoveryUSB:call result:result];
    } else {
        result(FlutterMethodNotImplemented);
    }
}

- (void)onDiscoveryTCP:(FlutterMethodCall*)call result:(FlutterResult)result {
    // DO NOTHING FOR NOW SINCE WE DONT USE THESE ONES
}

- (void)onDiscoveryBT:(FlutterMethodCall*)call result:(FlutterResult)result {
    printers.removeAllObjects;
    Epos2FilterOption *option = Epos2FilterOption.new;
    option.deviceType = EPOS2_TYPE_PRINTER;
    EpsonEposPrinterResult *resp;
    resp.type = @"onDiscoveryBT";
    resp.success = false;

    // stop running discovery first
    int runningResult = EPOS2_SUCCESS;

    while (YES) {
        runningResult = [Epos2Discovery stop];

        if (runningResult != EPOS2_ERR_PROCESSING) {
            break;
        }
    }

    NSLog(@"[epos2] startDiscover");

    runningResult = [Epos2Discovery start:option delegate:self];

    [NSThread sleepForTimeInterval:7.0f];

    if (runningResult != EPOS2_SUCCESS) {
        NSLog(@"[epos2] Error in startDiscover()");
    } else {
        resp.success = true;
        resp.message = @"Successfully!";
        resp.content = printers;
        @try {
            // TODO: send result back
        } @catch (NSException *exception) {
            // TODO: send failure message
        } @finally {
            // TODO: do something here
        }
    }
}

- (void)onDiscoveryUSB:(FlutterMethodCall*)call result:(FlutterResult)result {
    // DO NOTHING FOR NOW SINCE WE DONT USE THESE ONES
}

- (void)onGetPrinterInfo:(FlutterMethodCall *)call result:(__strong FlutterResult)result {
    // DO NOTHING
}

- (void)isPrinterConnected:(FlutterMethodCall *)call result:(__strong FlutterResult)result {
    // DO NOTHING
}

- (void)getPrinterSetting:(FlutterMethodCall *)call result:(__strong FlutterResult)result {
//    NSDictionary *args = call.arguments;
//    NSString *type = args[@"type"];
//    NSString *series = args[@"series"];
//    NSString *target = args[@"target"];
//
//    EpsonEposPrinterResult *resp;
//
//    @try {
//        if (![connectPrinter :target :series]) {
//            resp.success = false;
//            resp.message = @"Cannot connect to the printer.";
//            //TODO: return result
//            [mPrinter clearCommandBuffer];
//        } else {
//            if (mPrinter != NULL) {
//                [mPrinter clearCommandBuffer];
//            }
//        }
//    } @catch (NSException *exception) {
//        // TODO: send failure message
//    } @finally {
//        // TODO: do something here
//    }
}

- (void)setPrinterString:(FlutterMethodCall *)call result:(__strong FlutterResult)result {
//    NSDictionary *args = call.arguments;
//    NSString *type = args[@"type"];
//    NSString *series = args[@"series"];
//    NSString *target = args[@"target"];
//
//    NSInteger paperWidth = [args[@"paper_width"] integerValue];
//    NSInteger printDensity = [args[@"print_density"] integerValue];
//    NSInteger printSpeed = [args[@"print_speed"] integerValue];
//
//    EpsonEposPrinterResult *resp;
//
//    @try {
//        if (![connectPrinter :target :series]) {
//            resp.success = false;
//            resp.message = @"Cannot connect to the printer.";
//            //TODO: return result
//            [mPrinter clearCommandBuffer];
//        } else {
//            NSMutableDictionary *settingList;
//            [settingList setObject:printSpeed forKey:*EPOS2_PRINTER_SETTING_PRINTSPEED];
//            settingList[EPOS2_PRINTER_SETTING_PRINTDENSITY] = printDensity == nil ? printDensity : EPOS2_PARAM_DEFAULT;
//
//            NSInteger pw = 80;
//
//            if (paperWidth != NULL) {
//                if (paperWidth != 80 || paperWidth != 58 || paperWidth != 60) {
//                    pw = 80;
//                } else {
//                    pw = paperWidth;
//                }
//            }
//            settingList[EPOS2_PRINTER_SETTING_PAPERWIDTH] = pw;
//            [mPrinter setPrinterSetting:EPOS2_PARAM_DEFAULT setttingList:settingList delegate:mPrinterSettingListner];
//        }
//    } @catch (NSException *exception) {
//        [disconnectPrinter];
//        // TODO: send failure message
//    } @finally {
//        // TODO: do something here
//    }
}

- (void)onPrint:(FlutterMethodCall *)call result:(__strong FlutterResult)result {
    NSDictionary *args = call.arguments;
    NSString *type = args[@"type"];
    NSString *series = args[@"series"];
    NSString *target = args[@"target"];

    NSArray *commands = args[@"commands"];
    EpsonEposPrinterResult *resp;

    @try {
        if (![self connectPrinter :target :series]) {
            resp.success = false;
            resp.message = @"Cannot connect to the printer.";
            //TODO: return result
            [mPrinter clearCommandBuffer];
        } else {
            [commands enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [self onGenerateCommand: obj];
            }];

            @try {
                Epos2PrinterStatusInfo *statusInfo = [mPrinter getStatus];
                [mPrinter sendData:EPOS2_PARAM_DEFAULT];

                resp.success = true;
                resp.message = @"Printed \(target) \(series)";
                //TODO: return result
            } @catch (NSException *exception) {
                [self disconnectPrinter];
            } @finally {
                // TODO: do something here
            }
        }
    } @catch (NSException *exception) {
        // TODO: send failure message
    } @finally {
        // TODO: do something here
    }
}

+ (void)onDiscovery:(Epos2DeviceInfo *)deviceInfo {
    if (deviceInfo.deviceName != NULL && deviceInfo.deviceName != nil && deviceInfo.deviceName != @"") {
        EpsonEposPrinterInfo *printer;
        printer.ipAddress = deviceInfo.ipAddress;
        printer.bdAddress = deviceInfo.bdAddress;
        printer.macAddress = deviceInfo.macAddress;
        printer.model = deviceInfo.deviceName;
        printer.type = [NSString stringWithFormat:@"%d", deviceInfo.deviceType];
        printer.printType = [NSString stringWithFormat:@"%d", deviceInfo.deviceType];
        printer.target = deviceInfo.target;

        NSInteger printerIndex = -1;
        [printers enumerateObjectsUsingBlock:^(EpsonEposPrinterInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.ipAddress == deviceInfo.ipAddress) {
                __block NSInteger printerIndex = idx;
            }
        }];

        if (printerIndex > -1) {
            [printers setObject:printer atIndexedSubscript:printerIndex];
        } else {
            [printers addObject:printer];
        }

    }
}

- (bool)connectPrinter:(NSString *)target :(NSString *)series {
    NSInteger printCons = [self getPrinterConstant: series];
    if (mPrinter == NULL || mTarget == NULL) {
        mPrinter = [[Epos2Printer alloc] initWithPrinterSeries:printCons lang:0];
        mTarget = target;
    }

    @try {
        Epos2PrinterStatusInfo *status = mPrinter.getStatus;
        if (status.online != EPOS2_TRUE) {
            [mPrinter connect:target timeout:EPOS2_PARAM_DEFAULT];
        }
        mPrinter.clearCommandBuffer;
    } @catch (NSException *exception) {
        [self disconnectPrinter];
        return false;
    } @finally {
        return true;
    }

}

- (void)disconnectPrinter {
    if (mPrinter == nil) {
        return;
    }

    @try {
        mPrinter.disconnect;
        mPrinter = nil;
        mTarget = nil;
    } @catch (NSException *exception) {
        mPrinter.clearCommandBuffer;
    } @finally {
        //TODO: something
    }
}

- (void)onGenerateCommand:(NSDictionary *)command {

}

- (void)onPtrReceive:(Epos2Printer *)printerObj code:(int)code status:(Epos2PrinterStatusInfo *)status printJobId:(NSString *)printJobId {
    // TODO: IDK
}

- (void)onDiscovery:(Epos2DeviceInfo *)deviceInfo {
    //IDK
}

- (NSInteger)getPrinterConstant:(NSString *)series {
    if ([series  isEqual: @"TM_M10"]) {
        return EPOS2_TM_M10;
    } else if ([series  isEqual: @"TM_M30"]) {
        return EPOS2_TM_M30;
    } else if ([series  isEqual: @"TM_M30II"]) {
        return EPOS2_TM_M30II;
    } else if ([series  isEqual: @"TM_M50"]) {
        return EPOS2_TM_M50;
    } else if ([series  isEqual: @"TM_P20"]) {
        return EPOS2_TM_P20;
    } else if ([series  isEqual: @"TM_P60"]) {
        return EPOS2_TM_P60;
    } else if ([series  isEqual: @"TM_P60II"]) {
        return EPOS2_TM_P60II;
    } else if ([series  isEqual: @"TM_P80"]) {
        return EPOS2_TM_P80;
    } else if ([series  isEqual: @"TM_T20"]) {
        return EPOS2_TM_T20;
    } else if ([series  isEqual: @"TM_T60"]) {
        return EPOS2_TM_T60;
    } else if ([series  isEqual: @"TM_T70"]) {
        return EPOS2_TM_T70;
    } else if ([series  isEqual: @"TM_T81"]) {
        return EPOS2_TM_T81;
    } else if ([series  isEqual: @"TM_T82"]) {
        return EPOS2_TM_T82;
    } else if ([series  isEqual: @"TM_T83"]) {
        return EPOS2_TM_T83;
    } else if ([series  isEqual: @"TM_T83III"]) {
        return EPOS2_TM_T83III;
    } else if ([series  isEqual: @"TM_T88"]) {
        return EPOS2_TM_T88;
    } else if ([series  isEqual: @"TM_T90"]) {
        return EPOS2_TM_T90;
    } else if ([series  isEqual: @"TM_T100"]) {
        return EPOS2_TM_T100;
    } else if ([series  isEqual: @"TM_U220"]) {
        return EPOS2_TM_U220;
    } else if ([series  isEqual: @"TM_U330"]) {
        return EPOS2_TM_U330;
    } else if ([series  isEqual: @"TM_L90"]) {
        return EPOS2_TM_L90;
    } else if ([series  isEqual: @"TM_H6000"]) {
        return EPOS2_TM_H6000;
    } else {
        return 0;
    }
}

@end

