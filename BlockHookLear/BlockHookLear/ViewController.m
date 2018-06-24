//
//  ViewController.m
//  BlockHookLear
//
//  Created by Hades on 2018/6/24.
//  Copyright © 2018年 王磊磊. All rights reserved.
//

#import "ViewController.h"
#import <BlockHookKit/BlockHookKit.h>
//#import <BlockHookKit/BlockHook.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSObject *z = NSObject.new;
    int (^block)(int, int) = ^(int x, int y) {
        int result = x + y;
        NSLog(@"%d + %d = %d, z is a NSObject: %p", x, y, result, z);
        return result;
    };
    
    
    BHToken *tokenInstead = [block block_hookWithMode:BlockHookModeInstead usingBlock:^(BHToken *token, int x, int y){
        [token invokeOriginalBlock];
        NSLog(@"let me see original result: %d", *(int *)(token.retValue));
        // change the block imp and result
        *(int *)(token.retValue) = x * y;
        NSLog(@"hook instead: '+' -> '*'");
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
