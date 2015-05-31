//
//  ApiManager.m
//  VK_API_Walls
//
//  Created by Sergey Yasnetsky on 30.05.15.
//  Copyright (c) 2015 Sergey Yasnetsky. All rights reserved.
//

#import "ApiManager.h"
#import "Result.h"
#include "AppConstant.h"

//#define MAIN_URL   @"https://api.vk.com/method/"


@implementation ApiManager

+ (ApiManager *) managerWithDelegate: (id<APIMAnagerDelegate>) aDelegate {

    return [[ApiManager alloc] initWithDelegate:aDelegate];

}

- (id)initWithDelegate: (id<APIMAnagerDelegate>) aDelegate
{
    self = [super init];
    if (self) {
        self.delegate = aDelegate;
    }
    return self;
}


- (void) getDataFormWall: (NSDictionary *) params {

    NSURL * url = [NSURL URLWithString:MAIN_URL];
    
    
    AFHTTPRequestOperationManager * manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
    [manager GET:@"wall.get" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {

//      NSLog(@"responseObject %@", responseObject);
    
       
        Result * res = [[Result alloc] initWithDictionary:responseObject];
        
        [[res.response objectAtIndex:3]text];
        
        if ([self.delegate respondsToSelector:@selector(response:Answer:)]) {
            [self.delegate response:self Answer:res];
            
        }
        
        NSLog(@"[[res.response objectAtIndex:3]text] %@",[[res.response objectAtIndex:3]text]);

      /*
        NSArray * array = [responseObject objectForKey:@"response"];
        
        NSDictionary * dict = [[array objectAtIndex:1] objectForKey:@"attachment"];
        
        NSDictionary * dict2 = [dict objectForKey:@"photo"];
        NSString * link = [dict2 objectForKey:@"src_small"];
        
        
        NSLog(@"link %@", link);
*/
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if ([self.delegate respondsToSelector:@selector(responseError:Error:)]) {
            [self.delegate responseError:self Error:error];
            }
        }];
    
    }
@end
