//
//  main.swift
//  MTHTMLParser
//
//  Created by KikuraYuichirou on 2014/07/31.
//  Copyright (c) 2014年 KikuraYuichirou. All rights reserved.
//

import Foundation

println("start")
var parser = MTHTMLParser()
parser.get(NSURL(string: "https://twitter.com/"))

