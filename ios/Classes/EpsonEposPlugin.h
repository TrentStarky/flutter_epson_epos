#import <Flutter/Flutter.h>
#import "libepos2.h"

@interface EpsonEposPlugin : NSObject<FlutterPlugin, Epos2DiscoveryDelegate, Epos2PtrReceiveDelegate>

+ (void)registerWithRegistar:(NSObject<FlutterPluginRegistrar>*)registrar;

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result;

- (void)onDiscovery:(FlutterMethodCall*)call result:(FlutterResult)result;

- (void)onDiscoveryTCP:(FlutterMethodCall*)call result:(FlutterResult)result;

- (void)onDiscoveryBT:(FlutterMethodCall*)call result:(FlutterResult)result;

- (void)onDiscoveryUSB:(FlutterMethodCall*)call result:(FlutterResult)result;

- (void)onGetPrinterInfo:(FlutterMethodCall*)call result:(FlutterResult)result;

- (void)isPrinterConnected:(FlutterMethodCall*)call result:(FlutterResult)result;

- (void)getPrinterSetting:(FlutterMethodCall*)call result:(FlutterResult)result;

- (void)setPrinterString:(FlutterMethodCall*)call result:(FlutterResult)result;

- (void)onPrint:(FlutterMethodCall*)call result:(FlutterResult)result;

+ (void)onDiscovery:(Epos2DeviceInfo *)deviceInfo;

- (bool)connectPrinter:(NSString *)target :(NSString *)series;

- (void)disconnectPrinter;

- (void)onGenerateCommand:(NSDictionary *)command;

- (NSInteger)getPrinterConstant:(NSString *)series;
@end

@interface EpsonEposPrinterInfo : NSObject
@property NSString *ipAddress;
@property NSString *bdAddress;
@property NSString *macAddress;
@property NSString *model;
@property NSString *type;
@property NSString *printType;
@property NSString *target;
@end

@interface EpsonEposPrinterResult : NSObject
@property NSString *type;
@property BOOL success;
@property NSString *message;
@property NSMutableArray *content;
@end
