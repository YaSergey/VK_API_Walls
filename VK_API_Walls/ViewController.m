//
//  ViewController.m
//  VK_API_Walls
//
//  Created by Sergey Yasnetsky on 30.05.15.
//  Copyright (c) 2015 Sergey Yasnetsky. All rights reserved.
//

#import "ViewController.h"
#import "ApiManager.h"
#import "Result.h"
#import "TextCalculation.h"
#import <SDWebImage/UIImageView+WebCache.h>
#include "AppConstant.h"




@interface ViewController () <APIMAnagerDelegate>

@property (nonatomic, strong) NSMutableArray * arrayResult;
@property (nonatomic, weak) UIImage * imageView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

NSDictionary * params = [[NSDictionary alloc] initWithObjectsAndKeys:
    GROUP_ID_AppleInsider, @"owner_id",
    @100, @"count",
    @10, @"offset",
    @"onwer", @"filter",
    nil];

    [[ApiManager managerWithDelegate:self]getDataFormWall:params];

}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) response: (ApiManager *) manager Answer: (id) respObject {

    if ([respObject isKindOfClass:[Result class]]) {
        Result * res = (id) respObject;
        
          int photoCount = 0;
        
        for (int i =1; i < [res.response count]; i++) {
            
            if ([[[res.response objectAtIndex:i]attachment]photo]) {
                
                photoCount++;
                
                NSLog(@"YES");
                
            }else{
                
                NSLog(@"NO");

            }
            
        }
            
for (int i = 1; i < [res.response count]; i++) {
NSString * linkNews = [[[[res.response objectAtIndex:i]attachment]photo]src_big];
                
CGFloat heightNews = [[[[res.response objectAtIndex:i]attachment]photo]height];
CGFloat widthNews =  [[[[res.response objectAtIndex:i]attachment]photo]width];

                
NSString * text = [[res.response objectAtIndex:i]text];

    text = [text stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
   
    [SDWebImageDownloader.sharedDownloader downloadImageWithURL:[NSURL URLWithString:linkNews]
                                                        options:0
                                                       progress:^(NSInteger  receivedSize, NSInteger expectedSize)
     {
         // progression tracking code
     }
                                                      completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished)
     {
         if (image && finished)
         {
             
             dispatch_async(dispatch_get_main_queue(), ^{
             
             CGFloat heightNeeded  = [self heghtImage:heightNews Width:widthNews];
             
             UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, heightNeeded)];
             
             imageView.image = [self resizing_Image:image height:heightNeeded width: self.view.frame.size.width];
             
             UITextView * textView = [[UITextView alloc]initWithFrame:CGRectMake(0, heightNeeded, self.view.frame.size.width, [TextCalculation heightForText:text View:self.view Font:[UIFont systemFontOfSize:14]])];
             
             textView.userInteractionEnabled = NO;
             textView.font = [UIFont systemFontOfSize:14];
             textView.text = text;
             
             UIView * viewNews = [[UIView  alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, imageView.bounds.size.height + textView.bounds.size.height)];
             
             [imageView addSubview:textView];
             [viewNews addSubview:imageView];
             
             [self.arrayResult addObject:viewNews];
 
                 NSLog(@" %lu, %d", (unsigned long)self.arrayResult.count, photoCount);
                 
             if (self.arrayResult.count == photoCount) {
                 
                 [self.tableView reloadData];
                }
             
             });
             // do something with image
            }
        }];

    }

        self.arrayResult = [[NSMutableArray alloc] init];
    
    }

}
- (void) responseError: (ApiManager *) manager Error: (NSError *) error {
    
    NSLog(@"error %@", error);
    
}

// расчет высоты и ширины картинки, чтобы она помещалась на всю ширину экрана
- (CGFloat) heghtImage: (CGFloat) height Width: (CGFloat) width  {
    
    CGFloat heghtTotal = 0.0;
    CGFloat proportion = 0.0;
    
    if (width > self.view.frame.size.width) {
        if (height > width) {
            proportion = height/width;
            
            heghtTotal = self.view.frame.size.width * proportion;
        }
        else {
            proportion = width/height;
            
            heghtTotal = self.view.frame.size.width / proportion;
        
        }
    }
    else {
        if (width < self.view.frame.size.width) {
            proportion = self.view.frame.size.width - width;
            
            heghtTotal = height + proportion;
        }
        else {
            
            heghtTotal = height;
            
        }
    }
    return heghtTotal;
    
}

- (UIImage *) resizing_Image: (UIImage *) image height: (CGFloat) height width: (CGFloat) width{

    float actualHeight = image.size.height;
    float actualWidth = image.size.width;
    float imgRatio = actualWidth/actualHeight;
    float maxRatio = width/height;
    
    
    if (imgRatio !=maxRatio) {
        if (imgRatio < maxRatio) {
            imgRatio = height / actualHeight;
            actualWidth = imgRatio * actualWidth;
            actualWidth = height;
        }
        else{
            imgRatio = width/ actualWidth;
            actualHeight= imgRatio * actualHeight;
            actualWidth = width;
            
        }
    }
    NSLog(@"actualWidth %f %f", actualHeight, actualWidth);
    CGRect  rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
    UIGraphicsBeginImageContext(rect.size);
    
    [image drawInRect:rect];
    UIImage* img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
    
}


# pragma mark UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    
    return self.arrayResult.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString * cellId = @"Cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    for (UIView * view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    [cell.contentView addSubview:[self.arrayResult objectAtIndex:indexPath.row]];
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    UIView * newsView = [self.arrayResult objectAtIndex:indexPath.row];
    
    return newsView.bounds.size.height;
    

}

@end
