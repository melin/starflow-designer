package com.starflow.model {
	import it.sephiroth.utils.HashMap;
	
	import mx.collections.ArrayCollection;
	
	public class Activity {
		//环节名称
		public var name:String = "";
		//环节类型
		public var type:String = "manual";
		//环节描述
		public var description:String = "";
		//扩展属性
		public var extendNodes:ArrayCollection = new ArrayCollection();
		
		public function Activity(){
		}
	}
}