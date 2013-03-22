//
//  ViewController.m
//  SaveWebview
//
//  Created by James Graham on 3/22/13.
//  Copyright (c) 2013 James Graham. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSURL *url = [NSURL URLWithString:@"http://news.google.com"];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [webview loadRequest:request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)saveWebview: (id)sender
{
    NSString *currentURLString =  [[NSString alloc] initWithString:[webview stringByEvaluatingJavaScriptFromString:@"window.location.href"]];
    NSURL *currentUrl = [NSURL URLWithString:currentURLString];
    NSString *withoutw = [[[NSString alloc] initWithFormat:@"%@",[currentUrl host]] stringByReplacingOccurrencesOfString:@"www." withString:@""];
    NSArray *firstSplit = [withoutw componentsSeparatedByString:@"."];
    NSString *newDocumentName = [firstSplit objectAtIndex:0];
    
    //Create original tmp bounds
    CGRect tmpFrame = webview.frame;
    CGRect tmpBounds = webview.bounds;
    CGRect aFrame = webview.bounds;
    aFrame.size.width = 768; 
    aFrame.size.height = webview.bounds.size.height;
    webview.frame = aFrame;
    aFrame.size.height = [webview sizeThatFits:[[UIScreen mainScreen] bounds].size].height;
    
    webview.frame = aFrame;
    
    UIGraphicsBeginImageContext([webview sizeThatFits:[[UIScreen mainScreen] bounds].size]);
    CGContextRef resizedContext = UIGraphicsGetCurrentContext();
    
    [webview.layer renderInContext:resizedContext];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    webview.frame = tmpFrame;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *pngPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",newDocumentName]];
    NSError *error;
    [UIImagePNGRepresentation(image) writeToFile:pngPath options:NSDataWritingAtomic error:&error];
    
    NSURL *url = [NSURL fileURLWithPath:pngPath];

    NSLog(@"url with new image %@",url);
    NSString *file_ready_message = [[NSString alloc] initWithFormat:@"%@",url];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"File Ready" message:file_ready_message delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
    [alertView show];

    webview.bounds = tmpBounds;
    webview.frame = tmpFrame;
}

@end
