//
//  definitions.h
//  skyInnerSX
//
//  Created by skyworth on 14-9-26.
//  Copyright (c) 2014年 wziiy. All rights reserved.
//

#ifndef skyInnerSX_definitions_h
#define skyInnerSX_definitions_h

// 锚点定位
typedef struct skyResizableAnchorPoint
{
    CGFloat adjustX;
    CGFloat adjustY;
    CGFloat adjustH;
    CGFloat adjustW;
    int     direction;
}skyResizableAnchorPoint;

// 位置与锚点对
typedef struct skyPointAndResizableAnchorPoint
{
    CGPoint point;
    skyResizableAnchorPoint anchor;
}skyPointAndResizableAnchorPoint;


// 协议类型定义

//
// 命令延迟
#define SKY_SEND_DELAY          200

//
// 调试输出
#define DEBUG_LOG
#ifdef DEBUG_LOG
#define LOG_MESSAGE      NSLog
#else
#define LOG_MESSAGE
#endif

#endif