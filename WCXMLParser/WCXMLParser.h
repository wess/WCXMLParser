//
//  WCXMLParser.h
//  Matters
//
//  Created by Wess Cope on 5/22/12.
//  Copyright (c) 2012 Wess Cope. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    WCXMLParserProcessNamespaces        = 1 << 0,
    WCXMLParserReportNamespacePrefixes  = 1 << 1,
    WCXMLParserResolveExternalEntities  = 1 << 2,
} WCXMLParserOptions;

@class WCXMLParser;
typedef void (^WCXMLParserElementStartedCallback)(WCXMLParser * parser, NSString * elementName, NSDictionary * attributes);
typedef void (^WCXMLParserElementEndedCallback)(WCXMLParser * parser, NSString * elementName, NSString * elementText);

typedef void(^WCXMLParserSuccessCallback)(WCXMLParser *parser, id parsedObject);
typedef void(^WCXMLParserErrorCallback)(WCXMLParser *parser, NSError *error);

@interface WCXMLParser : NSObject<NSXMLParserDelegate>

@property (strong, nonatomic) WCXMLParserElementStartedCallback elementStartedCallback;
@property (strong, nonatomic) WCXMLParserElementEndedCallback elementEndedCallback;

@property (strong, nonatomic) WCXMLParserSuccessCallback  successCallback;
@property (strong, nonatomic) WCXMLParserErrorCallback    errorCallback;
@property (assign, nonatomic) WCXMLParserOptions          options;

#pragma mark - Setup
- (id)initWithParser:(NSXMLParser *)parser;
- (id)initWithData:(NSData *)data;

#pragma mark - Process

- (void)parse;
- (void)stopParsing;

#pragma mark - Convenience

+ (void)parseWithParser:(NSXMLParser *)parser success:(WCXMLParserSuccessCallback)success failure:(WCXMLParserErrorCallback)failure;
+ (void)parseWithParser:(NSXMLParser *)parser success:(WCXMLParserSuccessCallback)success failure:(WCXMLParserErrorCallback)failure elementStarted:(WCXMLParserElementStartedCallback)elementStarted elementEnded:(WCXMLParserElementEndedCallback)elementEnded;

+ (void)parseXMLString:(NSString *)string withOptions:(WCXMLParserOptions)options success:(WCXMLParserSuccessCallback)success failure:(WCXMLParserErrorCallback)failure;
+ (void)parseXMLData:(NSData *)data withOptions:(WCXMLParserOptions)options success:(WCXMLParserSuccessCallback)success failure:(WCXMLParserErrorCallback)failure;
+ (void)parseContentFromURL:(NSURL *)url withOptions:(WCXMLParserOptions)options success:(WCXMLParserSuccessCallback)success failure:(WCXMLParserErrorCallback)failure;

@end
