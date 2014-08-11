//
//  MTHTMLNode.swift
//  MTHTMLParser
//
//  Created by KikuraYuichirou on 2014/07/31.
//  Copyright (c) 2014年 KikuraYuichirou. All rights reserved.
//

import Foundation

public class MTHTMLNode: Equatable {
	
	var tagName: String
	var children: [MTHTMLNode] = []
	var parentNode: MTHTMLNode?
	var attribute: Dictionary<String, String> = Dictionary<String, String>()
	
	init(_ tagName: String) {
		self.tagName = tagName
	}

	func print(indent: String = "") {
		println("\(indent)<\(tagName)>")

		for child in children {
			child.print(indent: indent+"    ")
		}
		
		println("\(indent)</\(tagName)>")
	}
}

extension MTHTMLNode {
	public func isChild(child: MTHTMLNode) -> Bool {
		return !(!find(children, child))
	}
	
	public func appendChild(child: MTHTMLNode) {
		if (child.parentNode) {
			if (child.parentNode! === self) {
				return
			}
			
			child.parentNode!.removeChild(child)
		}
		
		self.children.append(child)
		child.parentNode = self
	}
	
	public func removeChild(child: MTHTMLNode) {
		if (!self.isChild(child)) {
			return
		}
		
		let index: Int = find(children, child)!

		children.removeAtIndex(index)
		child.parentNode = nil
	}
}

public func ==(lhs: MTHTMLNode, rhs: MTHTMLNode) -> Bool {
	return (lhs === rhs)
}
