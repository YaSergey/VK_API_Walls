//
//  ApiManager.h
//  VK_API_Walls
//
//  Created by Sergey Yasnetsky on 30.05.15.
//  Copyright (c) 2015 Sergey Yasnetsky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>


@protocol APIMAnagerDelegate;


@interface ApiManager : NSObject

@property   (nonatomic, weak) id <APIMAnagerDelegate> delegate;

- (void) getDataFormWall: (NSDictionary *) params;

+ (ApiManager *) managerWithDelegate: (id<APIMAnagerDelegate>) aDelegate;
- (id)initWithDelegate: (id<APIMAnagerDelegate>) aDelegate;


@end


@protocol APIMAnagerDelegate <NSObject>

@required
- (void) response: (ApiManager *) manager Answer: (id) respObject;
- (void) responseError: (ApiManager *) manager Error: (NSError *) error;


@end