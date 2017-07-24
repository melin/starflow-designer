package com.starflow.model {
	public class FreeActivity {
		public var id:String;
		public var name:String;
		public var type:String;
		public var typeName:String;
		public function FreeActivity(){
		}
		
		public function createXml():String {
			var xml:String = '<freeActivity id="'+id+'" name="'+name+'" />\n';
			return xml;
		}
	}
}