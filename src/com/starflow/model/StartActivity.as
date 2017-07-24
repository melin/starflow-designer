package com.starflow.model {
	import mx.collections.ArrayCollection;

	public class StartActivity extends Activity {
		//分支模式
		public var splitMode:String = "XOR";
		//环节操作
		public var action:String = "";
		public var operations:ArrayCollection = new ArrayCollection();
		
		public function StartActivity() {
		}
	}
}