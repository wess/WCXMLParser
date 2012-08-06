WCXMLParser
==========
WCXMLParser is a block based XML parser based on NSXMLParser, with a pretty package wrapped around it. Syntax/Structure inspired by AFNetworking (I built it to work with AFNetworking's AFXMLRequestOperation and not have to use delegates).  Wanted to make parsing XML painless as possible.

### Using WCXMLParser
To use, simply drop the WXCMLParser.m/.h files into your project (fyi, it is ARC), include the .h file and you should be ready to go.

---

#### WCXMLParser Methods

```objectivec
/**
	Your WCXMLParser options are pretty much the same as the NSXMLParser ones
	 	WCXMLParserProcessNamespaces
    	WCXMLParserReportNamespacePrefixes
    	WCXMLParserResolveExternalEntities
 */

// Already have a parser, you can throw it in to use with the callbacks (looking at you AFNetworking)
+ (void)parseWithParser:(NSXMLParser *)parser success:(WCXMLParserSuccessCallback)success failure:(WCXMLParserErrorCallback)failure;

// Parse using an XML String
+ (void)parseXMLString:(NSString *)string withOptions:(WCXMLParserOptions)options success:(WCXMLParserSuccessCallback)success failure:(WCXMLParserErrorCallback)failure;

// Parse with data
+ (void)parseXMLData:(NSData *)data withOptions:(WCXMLParserOptions)options success:(WCXMLParserSuccessCallback)success failure:(WCXMLParserErrorCallback)failure;

// Even parse XML from a URL (RSS/ATOM feed for example)
+ (void)parseContentFromURL:(NSURL *)url withOptions:(WCXMLParserOptions)options success:(WCXMLParserSuccessCallback)success failure:(WCXMLParserErrorCallback)failure;

```

### Example
```objectivec

    [WCXMLParser parseContentFromURL:[NSURL URLWithString:@"https://github.com/wess.atom"] withOptions:0 success:^(WCXMLParser *parser, id parsedObject) {
        for(NSDictionary *entry in [[parsedObject objectForKey:@"feed"] objectForKey:@"entry"])
            [_items addObject:[[entry objectForKey:@"title"] objectForKey:@"text"]];
        
        [self.tableView reloadData];
    } failure:^(WCXMLParser *parser, NSError *error) {
        NSLog(@"PARSE ERROR: %@", [error description]);        
    }];

```


---

#### Notes:
- This project uses ARC
- This is still in early stages

---


If you have an suggestions, contributes, etc.. Feel free to send me a message here or hit me up on twitter (@wesscope) and I will do what I can to get back with ya.

Thanks, 
Wess

---

## License
Copyright (c) 2012, Wess Cope
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, 
are permitted provided that the following conditions are met:

Redistributions of source code must retain the above copyright notice,
this list of conditions and the following disclaimer.
Redistributions in binary form must reproduce the above copyright 
notice, this list of conditions and the following disclaimer in 
the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE 
LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
POSSIBILITY OF SUCH DAMAGE.