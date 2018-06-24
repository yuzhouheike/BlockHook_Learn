//  weibo: http://weibo.com/xiaoqing28
//  blog:  http://www.alonemonkey.com
//
//  BlockHook_learn_MDDylib.m
//  BlockHook_learn_MDDylib
//
//  Created by Hades on 2018/6/24.
//  Copyright (c) 2018年 王磊磊. All rights reserved.
//

#import "BlockHook_learn_MDDylib.h"
#import <CaptainHook/CaptainHook.h>
#import <UIKit/UIKit.h>
#import <Cycript/Cycript.h>
#import <MDCycriptManager.h>
#import <BlockHookKit/BlockHookKit.h>
#import "IIFishBind.h"

CHConstructor{
    NSLog(INSERT_SUCCESS_WELCOME);
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        
#ifndef __OPTIMIZE__
        CYListenServer(6666);

        MDCycriptManager* manager = [MDCycriptManager sharedInstance];
        [manager loadCycript:NO];

        NSError* error;
        NSString* result = [manager evaluateCycript:@"UIApp" error:&error];
        NSLog(@"result: %@", result);
        if(error.code != 0){
            NSLog(@"error: %@", error.localizedDescription);
        }
#endif
        
    }];
}


CHDeclareClass(CustomViewController)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wstrict-prototypes"

//add new method
CHDeclareMethod1(void, CustomViewController, newMethod, NSString*, output){
    NSLog(@"This is a new method : %@", output);
}

#pragma clang diagnostic pop

CHOptimizedClassMethod0(self, void, CustomViewController, classMethod){
    NSLog(@"hook class method");
    CHSuper0(CustomViewController, classMethod);
}

CHOptimizedMethod0(self, NSString*, CustomViewController, getMyName){
    //get origin value
    NSString* originName = CHSuper(0, CustomViewController, getMyName);
    
    NSLog(@"origin name is:%@",originName);
    
    //get property
    NSString* password = CHIvar(self,_password,__strong NSString*);
    
    NSLog(@"password is %@",password);
    
    [self newMethod:@"output"];
    
    //set new property
    self.newProperty = @"newProperty";
    
    NSLog(@"newProperty : %@", self.newProperty);
    
    //change the value
    return @"Hades";
    
}

//add new property
CHPropertyRetainNonatomic(CustomViewController, NSString*, newProperty, setNewProperty);

CHDeclareClass(AFHTTPSessionManager);

// - (id)POST:(id)arg1 parameters:(id)arg2 progress:(id)arg3 success:(id)arg4 failure:(id)arg5
CHMethod(5, void, AFHTTPSessionManager, POST, id, arg1, parameters, id, arg2, progress, id, arg3, success, id, arg4, failure, id, arg5)
{
    
    NSLog(@"url=================================：%@\n=====================================\n %@", arg1, arg2);
//
  
    
    void (^newSucess)(NSURLSessionDataTask *task, id responseObject) = ^void(NSURLSessionDataTask *task, id responseObject){
        
        NSLog(@"responseObject:%@", responseObject);
//        arg4(task,responseObject);
    };
       return CHSuper(5, AFHTTPSessionManager, POST, arg1, parameters,arg2, progress, arg3, success, arg4, failure, arg5);
    
//        BHToken *tokenInstead = [arg4 block_hookWithMode:BlockHookModeInstead usingBlock:^(BHToken *token, NSURLSessionDataTask * _Nonnull task,id  _Nullable responseObject){
//            [token invokeOriginalBlock];
//            NSLog(@"let me see original result: %d", *(int *)(token.retValue));
//            // change the block imp and result
//    //        *(int *)(token.retValue) = x * y;
//            NSLog(@"hook instead: %@", responseObject);
//        }];
//    [IIFishBind bindFishes:@[
//                             [IIFish postBlock:arg4],
//                             [IIFish observer:self
//                                     callBack:^(IIFishCallBack *callBack, id deadFish) {
//                                         NSLog(@"fuck %@ + %@ = %@", callBack.args[0], callBack.args[1], callBack.resule);
//                                         // 3.1 + 4.1 = 7.199999999999999
//                                     }]
//                             ]];
//
//    [IIFishBind bindFishes:@[
//                             [IIFish postBlock:arg5],
//                             [IIFish observer:self
//                                     callBack:^(IIFishCallBack *callBack, id deadFish) {
//                                         NSLog(@"fuck %@ + %@ = %@", callBack.args[0], callBack.args[1], callBack.resule);
//                                         // 3.1 + 4.1 = 7.199999999999999
//                                     }]
//                             ]];
//    void (^replacedCompletion)(NSData *,NSURLResponse *,NSError *) = ^void(NSData *newData,
//                                                                           NSURLResponse *newResponse,
//                                                                           NSError *newError) {
//
//        NSString *responseString = [[NSString alloc] initWithData:newData encoding:NSUTF8StringEncoding];
//        NSLog(@"responseString %@",responseString);
//        completionHandler(newData, newResponse, newError);
//    };
    
 
}

CHMethod(5, void, AFHTTPSessionManager, GET, id, arg1, parameters, id, arg2, progress, id, arg3, success, id, arg4, failure, id, arg5)
{
    NSLog(@"url=================================：%@\n=====================================\n %@", arg1, arg2);
    

    void (^newSucess)(NSURLSessionDataTask *task, id responseObject) = ^void(NSURLSessionDataTask *task, id responseObject){
        
        NSLog(@"打印请求回来的数据====================\n%@", responseObject);
        //        arg4(task,responseObject);
    };
    return CHSuper(5, AFHTTPSessionManager, GET, arg1, parameters,arg2, progress, arg3, success, newSucess, failure, arg5);
 
}

CHConstructor{
    CHLoadLateClass(CustomViewController);
    CHClassHook0(CustomViewController, getMyName);
    CHClassHook0(CustomViewController, classMethod);
    
    CHHook0(CustomViewController, newProperty);
    CHHook1(CustomViewController, setNewProperty);
    
    CHLoadLateClass(AFHTTPSessionManager);
//    CHClassHook(5, AFHTTPSessionManager, POST, parameters, progress, success, failure);
    CHClassHook(5, AFHTTPSessionManager, GET, parameters, progress, success, failure);
}

