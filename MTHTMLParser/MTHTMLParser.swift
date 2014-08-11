//
//  MTHTMLParser.swift
//  MTHTMLParser
//
//  Created by KikuraYuichirou on 2014/07/31.
//  Copyright (c) 2014年 KikuraYuichirou. All rights reserved.
//

import Foundation

public class MTHTMLParser: NSObject {
	private enum NodeType {
		case Open;
		case Close;
		case OpenClose;
	}

	let regHTMLTag = MTRegExp("<(/?)([^>\\\"\\\'\\s/]+)((?:[^/>\\\"\\\']+|\\\"[^\\\"]+\\\"|\\\'[^\\\']+\\\')*)(/?)>")
	var rootNode: MTHTMLNode = MTHTMLNode("ROOT_NODE")
	var contextNode: MTHTMLNode
	var receivedData: NSMutableData?
	
	init() {
		contextNode = rootNode
		super.init()
	}
}

extension MTHTMLParser {
	public func parse(html: String) -> [MTHTMLNode] {
		
		contextNode = rootNode

		let tagTexts = html.match(regHTMLTag)
		var cursor: Int = 0
		
		if (tagTexts) {
			for tagText in tagTexts! {
				let texts = tagText.texts
				
				let tagType: NodeType = (texts[1] == "/") ? .Close : (texts[4] == "/") ? .OpenClose : .Open
				let tagName = texts[2]
				let tagAttrText = texts[3]
				
				if (tagText.ranges[0].location != cursor) {
					addTextNode(html, start: cursor, end: tagText.ranges[0].location)
				}
				
				switch tagType {
				case .Open:
					openTag(tagName, attr: tagAttrText)
					break;
					
				case .Close:
					closeTag()
					break;
					
				case .OpenClose:
					openTag(tagName, attr: tagAttrText)
					closeTag()
					break;
				}

				cursor = tagText.ranges[0].location + tagText.ranges[0].length
			}
		}
		
		var result = contextNode.children
		return result
	}
	
	private func openTag(tagName: String, attr tagAttrText: String) {
		let newNode = MTHTMLNode(tagName)
	
		contextNode.appendChild(newNode)
		contextNode = newNode
	}
	
	private func closeTag() {
		contextNode = contextNode.parentNode!
	}
	
	private func addTextNode(html: String, start startIndex: Int, end endIndex: Int) {
		let range = Range<String.Index>(
			start: advance(html.startIndex, startIndex),
			end: advance(html.startIndex, endIndex)
		)
		
		let textNode = MTHTMLTextNode(html[range])
		contextNode.appendChild(textNode)
	}
}

extension MTHTMLParser: NSURLConnectionDelegate, NSURLConnectionDataDelegate {

	public func get(url: NSURL) {
		var request = NSURLRequest(URL: url);
		var connection = NSURLConnection(request: request, delegate: self)

		receivedData = NSMutableData()
	}
	
	public func connection(connection: NSURLConnection!, willSendRequest request: NSURLRequest!, redirectResponse response: NSURLResponse!) -> NSURLRequest! {
		println("willSend")
		
		return request
	}
	
	public func connection(connection: NSURLConnection!, didFailWithError error: NSError!) {
		println(error)
	}
	
	public func connection(connection: NSURLConnection!, didReceiveData data: NSData!) {
		println("!")

		receivedData!.appendData(data)
	}

	public func connectionDidFinishLoading(connection: NSURLConnection!) {
		println("end")

		var html: String = NSString(data: receivedData!, encoding: NSUTF8StringEncoding)
		
		let nodes = parse(html)
		for node in nodes {
			node.print()
		}
	}

}