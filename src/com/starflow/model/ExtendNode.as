package com.starflow.model {
	public class ExtendNode {
		public var key:String = "";
		public var value:String = "";
		public var description:String = "";
		
		public function createXml():String {
			var xml:String = '<extendNode key="'+key+'" value="'+value+'" description="'+description+'" />\n';
			
			return xml;
		}
		
		public function ExtendNode() {
		}
	}
}