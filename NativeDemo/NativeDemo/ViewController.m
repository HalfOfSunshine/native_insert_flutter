//
//  ViewController.m
//  NativeDemo
//
//  Created by 麻明康 on 2024/6/2.
//

#import "ViewController.h"
#import <Flutter/Flutter.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(IBAction)openFlutterPage:(id)sender{
    FlutterViewController *VC = [FlutterViewController new];
    [VC setInitialRoute:@"one"];
    [self presentViewController:VC animated:YES completion:^{
            
    }];
}
- (IBAction)openFlutterPage2:(id)sender {
    FlutterViewController *VC = [FlutterViewController new];
    [VC setInitialRoute:@"two"];
    [self presentViewController:VC animated:YES completion:^{
            
    }];
}
@end
