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
#import <AFNetworking.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//
    NSObject *z = NSObject.new;
    int (^block)(int, int) = ^(int x, int y) {
        int result = x + y;
        NSLog(@"%d + %d = %d, z is a NSObject: %p", x, y, result, z);
        return result;
    };
//    void (^block)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject);
    
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", nil];
    [manger GET:@"http://super.xianjinxia.com/credit-user/reg-get-code?clientType=ios&appName=jsxjx&deviceId=009b8410354044699013b6bf7c101f2&appVersion=2.6.1&packageId=com.innext.XianjinXia&mobilePhone=17600230975" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       
        NSLog(@"%@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
    
//    BHToken *tokenInstead = [^block block_hookWithMode:BlockHookModeInstead usingBlock:^(BHToken *token, NSURLSessionDataTask * _Nonnull task,id  _Nullable responseObject){
//        [token invokeOriginalBlock];
//        NSLog(@"let me see original result: %d", *(int *)(token.retValue));
//        // change the block imp and result
////        *(int *)(token.retValue) = x * y;
//        NSLog(@"hook instead: %@", responseObject);
//    }];
    
//    BHToken *tokenAfter = [block block_hookWithMode:BlockHookModeAfter usingBlock:^(BHToken *token, int x, int y){
//        // print args and result
//        NSLog(@"hook after block! %d * %d = %d", x, y, *(int *)(token.retValue));
//    }];
//
//    BHToken *tokenBefore = [block block_hookWithMode:BlockHookModeBefore usingBlock:^(id token){
//        // BHToken has to be the first arg.
//        NSLog(@"hook before block! token:%@", token);
//    }];
//
//    BHToken *tokenDead = [block block_hookWithMode:BlockHookModeDead usingBlock:^(id token){
//        // BHToken is the only arg.
//        NSLog(@"block dead! token:%@", token);
//    }];
//
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSLog(@"hooked block");
//        int ret = block(3, 5);
//        NSLog(@"hooked result:%d", ret);
//        // remove all tokens when you don't need.
//        // reversed order of hook.
////        [tokenBefore remove];
////        [tokenAfter remove];
//        [tokenInstead remove];
//        NSLog(@"remove tokens, original block");
//        ret = block(3, 5);
//        NSLog(@"original result:%d", ret);
//        //        [tokenDead remove];
//    });
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
