// See http://iphonedevwiki.net/index.php/Logos

#import <UIKit/UIKit.h>

@interface CustomViewController

@property (nonatomic, copy) NSString* newProperty;

+ (void)classMethod;

- (NSString*)getMyName;

- (void)newMethod:(NSString*) output;

@end

%hook CustomViewController

+ (void)classMethod
{
	%log;

	%orig;
}

%new
-(void)newMethod:(NSString*) output{
    NSLog(@"This is a new method : %@", output);
}

%new
- (id)newProperty {
    return objc_getAssociatedObject(self, @selector(newProperty));
}

%new
- (void)setNewProperty:(id)value {
    objc_setAssociatedObject(self, @selector(newProperty), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString*)getMyName
{
	%log;

    NSString* password = MSHookIvar<NSString*>(self,"_password");

    NSLog(@"password:%@", password);

    [%c(CustomViewController) classMethod];

    [self newMethod:@"output"];

    self.newProperty = @"newProperty";

    NSLog(@"newProperty : %@", self.newProperty);

	return %orig();
}

%end

%hook NSURLSession

// -(NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request
// completionHandler:(void (^)(NSData *data,NSURLResponse *response,NSError *error))completionHandler {
// void (^replacedCompletion)(NSData *,NSURLResponse *,NSError *) = ^void(NSData *newData,
//                                                                            NSURLResponse *newResponse,
//                                                                            NSError *newError) {
//
//         NSString *responseString = [[NSString alloc] initWithData:newData encoding:NSUTF8StringEncoding];
//         NSLog(@"responseString %@",responseString);
//         // completionHandler(newData, newResponse, newError);
//     };
//
//     return %orig(request, replacedCompletion);
// }

%end

%hook CQUser

-(double)end_time{

	return 1561391298;
}

%end
