/*
 * PhoneGap is available under *either* the terms of the modified BSD license *or* the
 * MIT License (2008). See http://opensource.org/licenses/alphabetical for full text.
 * 
 * Copyright (c) 2005-2010, Nitobi Software Inc.
 */


#import "PhoneGapViewController.h"
#import "PhoneGapDelegate.h" 

@implementation PhoneGapViewController

@synthesize supportedOrientations, webView;

- (id) init
{
    if (self = [super init]) {
		// do other init here
	}
	didDrawStartupImage = NO;
	
	return self;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation) interfaceOrientation 
{
	BOOL autoRotate = [self.supportedOrientations count] > 1; // autorotate if only more than 1 orientation supported
	if (autoRotate)
	{
		if ([self.supportedOrientations containsObject:
			 [NSNumber numberWithInt:interfaceOrientation]]) {
			return YES;
		}
    }
	
	return NO;
}

/**
 Called by UIKit when the device starts to rotate to a new orientation.  This fires the \c setOrientation
 method on the Orientation object in JavaScript.  Look at the JavaScript documentation for more information.
 */
- (void)willRotateToInterfaceOrientation: (UIInterfaceOrientation)toInterfaceOrientation duration: (NSTimeInterval)duration {
	double i = 0;
	
	switch (toInterfaceOrientation){
		case UIInterfaceOrientationPortrait:
			i = 0;
			break;
		case UIInterfaceOrientationPortraitUpsideDown:
			i = 180;
			break;
		case UIInterfaceOrientationLandscapeLeft:
			i = 90;
			break;
		case UIInterfaceOrientationLandscapeRight:
			i = -90;
			break;
	}
	
	if (!didDrawStartupImage)
	{
		UIInterfaceOrientation orientation = toInterfaceOrientation; //[[UIApplication sharedApplication] statusBarOrientation];
		
		UIImage* image;
		UIImageView* imageView = (UIImageView*) [self.view.window viewWithTag:1];
		
		if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)
		{
			imageView.transform = CGAffineTransformMakeRotation(180 * 0.0174532925);
		} else {
			image = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Default-Landscape" ofType:@"png"]];
			imageView.image = image;
			[imageView sizeToFit];
			[image release];
			
			CGAffineTransform transform;
			if (orientation == UIInterfaceOrientationLandscapeLeft) {
				transform = CGAffineTransformMakeRotation(-90 * 0.0174532925);
				transform = CGAffineTransformTranslate(transform, -128, -128);
			} else {
				transform = CGAffineTransformMakeRotation(90 * 0.0174532925);
				transform = CGAffineTransformTranslate(transform, 128, 128);
			}
			imageView.transform = transform;
		}
		
		//[imageView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
		//[self.view.window addSubview:imageView];
		//[imageView release];
	}
	didDrawStartupImage = YES;
	
	[webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"navigator.orientation.setOrientation(%f);", i]];
}

- (void) setWebView:(UIWebView*) theWebView {
    webView = theWebView;
}

@end