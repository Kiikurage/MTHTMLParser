//
//  MTHTMLTextNode.swift
//  MTHTMLParser
//
//  Created by KikuraYuichirou on 2014/07/31.
//  Copyright (c) 2014年 KikuraYuichirou. All rights reserved.
//

import Foundation

class MTHTMLTextNode: MTHTMLNode {
	
	var text: String = ""
	
	init (_ text: String) {
		super.init("TEXTNODE")
		self.text = text
	}

	override func print(indent: String = "") {
		println(indent + text)
	}
}