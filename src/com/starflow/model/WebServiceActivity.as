package com.starflow.model {
	import mx.collections.ArrayCollection;

	public class WebServiceActivity extends Activity {
		//分支模式
		public var splitMode:String = "XOR";
		//聚合模式
		public var joinMode:String = "XOR";
		
		//自动环节
		public var finishType:String = "toolApp";
		public var invokePattern:String = "synchronous";
		public var transactionType:String = "join";
		public var exceptionStrategy:String = "ignore";
		public var exceptionAction:String = "";
		
		//触发事件
		public var triggerEvents:ArrayCollection = new ArrayCollection();
		
		//重启规则
		public var activateRuleType:String = "directRunning";
		public var startStrategybyAppAction:String = "";
		
		//WSDL配置
		public var locationURL:String = "";
		public var operation:String = "";
		public var parameters:ArrayCollection = new ArrayCollection();
		public var SOAPParameters:ArrayCollection = new ArrayCollection();
		
		public function WebServiceActivity() {
			super();
		}
	}
}