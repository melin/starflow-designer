package com.starflow.model {
	public class FinishActivity extends Activity {
		//聚合模式
		public var joinMode:String = "XOR";
		
		//重启规则
		public var activateRuleType:String = "directRunning";
		public var startStrategybyAppAction:String = "";
		
		public function FinishActivity(){
			super()
		}
	}
}