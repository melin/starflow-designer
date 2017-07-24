package com.starflow.model {
	public class Operation {
		public var id:String;
		public var code:String;
		public var action:String;
		public var name:String;
		
		public function Operation(){
		}
		
		public function createXml():String {
			var xml:String = '<operation id="'+id+'" code="'+code+'" action="'+action+'" name="'+name+'"/>\n';
			return xml;
		}
	}
}