package com.starflow.model {
	public class Participant {
		public var id:String;
		public var name:String;
		public var type:String;
		public var typeName:String;
		public function Participant() {
		}
		
		public function createXml():String {
			var xml:String = '<participant id="'+id+'" name="'+name+'" type="'+type+'"/>\n';;
			return xml;
		}
	}
}