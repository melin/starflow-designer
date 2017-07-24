package com.starflow.model {
	
	public class SOAPParameter {
		public var name:String;
		public var value:String = "";
		public var valueType:String = "variable";
		public var valueTypeName:String = "变量";
		
		public function SOAPParameter() {
		}
		
		public function createXml():String {
			var xml:String = '<parameter name="'+name+'" value="'+value+'" valueType="'+valueType+'"/>\n';
			return xml;
		}
	}
}