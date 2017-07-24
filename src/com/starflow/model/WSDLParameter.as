package com.starflow.model {
	
	public class WSDLParameter {
		public var name:String;
		public var dataType:String;
		public var fillBack:Boolean = false;
		public var mode:String;
		public var modeName:String;
		public var value:String = "";
		public var valueType:String = "variable";
		public var valueTypeName:String = "变量";
		
		public function WSDLParameter() {
		}
		
		public function createXml():String {
			var xml:String = "";
			if(value.indexOf("fm:") == 0) {
				xml = '<parameter name="'+name+'" dataType="'+dataType+'" fillBack="'+fillBack+'" mode="'+mode+'" valueType="'+valueType+'">\n';
				xml = xml + "					<value><![CDATA[ "+value+" ]]></value>\n"
				xml = xml + "				</parameter>\n"
			} else
				xml = '<parameter name="'+name+'" dataType="'+dataType+'" fillBack="'+fillBack+'" mode="'+mode+'" value="'+value+'" valueType="'+valueType+'"/>\n';
			return xml;
		}
	}
}