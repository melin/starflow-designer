package com.starflow.model {
	import mx.collections.ArrayCollection;

	public class SubProcessActivity extends Activity {
		//分支模式
		public var splitMode:String = "XOR";
		//聚合模式
		public var joinMode:String = "XOR";
		
		//子流程
		public var invokePattern:String = "synchronous";
		public var subProcess:String = "";
		
		//触发事件
		public var triggerEvents:ArrayCollection = new ArrayCollection();
		
		//重启规则
		public var activateRuleType:String = "directRunning";
		public var startStrategybyAppAction:String = "";
		
		public function SubProcessActivity() {
			super();
		}
	}
}