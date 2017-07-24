package com.starflow.model {
	public class TriggerEvent {
		public var eventType:String;
		public var eventTypeName:String;
		public var action:String = "";
		public var invokePattern:String = "synchronous";
		public var invokePatternName:String = "同步";
		public var transactionType:String = "suspend";
		public var exceptionStrategy:String = "rollback";
		public var exceptionStrategyName:String = "回滚异常";
		public var description:String = "";
		
		public function createXml():String {
			var xml:String = '<event eventType="'+eventType+'" action="'+action+'" '+
				'invokePattern="'+invokePattern+'" transactionType="'+transactionType+'" '+
				'exceptionStrategy="'+exceptionStrategy+'" description="'+description+'" />\n';
			
			return xml;
		}
		
		public function TriggerEvent(){
		}
	}
}