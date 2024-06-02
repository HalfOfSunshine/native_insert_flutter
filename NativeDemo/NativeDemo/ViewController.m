//
//  ViewController.m
//  NativeDemo
//
//  Created by 麻明康 on 2024/6/2.
//

#import "ViewController.h"
#import <Flutter/Flutter.h>
@interface ViewController ()
//避免每次调用都加载一个渲染引擎
//使用同一个渲染引擎后不能使用setInitialRoute传值了，不会多次调用runApp了
@property (nonatomic, strong) FlutterEngine *flutterEngine;
@property (nonatomic, strong) FlutterViewController *flutterVC;
@property (nonatomic, strong) FlutterBasicMessageChannel *messageChannel;
@end

@implementation ViewController

- (FlutterEngine *)flutterEngine{
    if (!_flutterEngine) {
        FlutterEngine *engine = [[FlutterEngine alloc]initWithName:@"hank"];
        //为什么要这么写呢？有空可以研究下
        if ([engine run]) {
            _flutterEngine = engine;
        }
//        _flutterEngine = [[FlutterEngine alloc]initWithName:@"hank"];
//        [_flutterEngine run]
    }
    return _flutterEngine;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self flutterEngine];
    self.flutterVC = [[FlutterViewController alloc] initWithEngine:self.flutterEngine nibName:nil bundle:nil];
    self.flutterVC.modalPresentationStyle = UIModalPresentationOverFullScreen;

    
    self.messageChannel = [FlutterBasicMessageChannel messageChannelWithName:@"messageChannel" binaryMessenger:self.flutterVC.binaryMessenger];
    [self.messageChannel setMessageHandler:^(id  _Nullable message, FlutterReply  _Nonnull callback) {
        NSLog(@"收到了flutter的信息%@",message);
    }];
    // Do any additional setup after loading the view.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    static int a=0;
    [self.messageChannel sendMessage:[NSString stringWithFormat:@"%i",a++]];
}
-(IBAction)openFlutterPage:(id)sender{
    FlutterMethodChannel *methodChannel = [FlutterMethodChannel methodChannelWithName:@"one_page" binaryMessenger:self.flutterVC.binaryMessenger];
    [methodChannel invokeMethod:@"setTitle" arguments:@"one"];
    [self presentViewController:self.flutterVC animated:YES completion:nil];
    //监听flutter 事件
    [methodChannel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
        if ([call.method isEqualToString:@"exit"]) {
            [self.flutterVC dismissViewControllerAnimated:YES completion:nil];
        }
    }];
    
    
}
- (IBAction)openFlutterPage2:(id)sender {

    FlutterMethodChannel *methodChannel = [FlutterMethodChannel methodChannelWithName:@"two_page" binaryMessenger:self.flutterVC.binaryMessenger];
    [methodChannel invokeMethod:@"setTitle" arguments:@"two"];

    [self presentViewController:self.flutterVC animated:YES completion:nil];
    
    [methodChannel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
        if ([call.method isEqualToString:@"exit"]) {
            [self.flutterVC dismissViewControllerAnimated:YES completion:nil];
        }
    }];
    
}
@end
