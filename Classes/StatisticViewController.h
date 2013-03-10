//
//  StatisticViewController.h
//  SimpleEKDemo
//
//  Created by Tzviki Fisher on 8/22/12.
//  Copyright (c) 2012 Leumi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPTGraphHostingView.h"

@interface StatisticViewController : UIViewController<CPTBarPlotDataSource, CPTBarPlotDelegate> 
    @property (nonatomic, strong) IBOutlet CPTGraphHostingView *hostView;
-(void)initPlot;
-(void)configureGraph;
-(void)configurePlots;
-(void)configureAxes;
-(void)hideAnnotation:(CPTGraph *)graph;
@end
