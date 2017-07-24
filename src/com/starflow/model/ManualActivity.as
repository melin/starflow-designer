package com.starflow.model {
	import mx.collections.ArrayCollection;

	public class ManualActivity extends Activity {
		//参与者
		public var participantType:String = "process-starter";
		public var particiSpecActID:String = "";
		public var particiLogic:String = "";
		public var participants:ArrayCollection = new ArrayCollection();
		public var isAllowAppointParticipants:Boolean = false;
		
		//多工作工作项
		public var wiMode:String = "single";
		public var workitemNumStrategy:String = "";
		public var finishRule:String = "";
		public var finishRquiredNum:String = "";
		public var finishRequiredPercent:String = "";
		public var isSequentialExecute:Boolean = false;
		public var isAutoCancel:Boolean = false;
		
		//自由活动
		public var isFreeActivity:Boolean = false;
		public var freeRangeStrategy:String = "";
		public var isOnlyLimitedManualActivity:Boolean = true;
		public var freeActivitys:ArrayCollection = new ArrayCollection();
		
		//环节时限
		public var limitTime:String = "";
		
		//环节操作
		public var action:String = "";
		public var operations:ArrayCollection = new ArrayCollection();
		
		//分支模式
		public var splitMode:String = "XOR";
		//聚合模式
		public var joinMode:String = "XOR";
		
		//触发事件
		public var triggerEvents:ArrayCollection = new ArrayCollection();
		
		//重启规则
		public var activateRuleType:String = "directRunning";
		public var startStrategybyAppAction:String = "";
		//重新启动规则，重设参与者的方式
		public var resetParticipant:String = "originalParticipant";
		
		public function ManualActivity(){
			super();
		}
	}
}