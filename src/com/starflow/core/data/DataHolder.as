package com.starflow.core.data {
	import it.sephiroth.utils.HashMap;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;

	public class DataHolder {
		private static var actImages:ArrayList = null;
		private static var triggerEventTypes:HashMap = null;
		
		[Bindable]
		public static var triggerFlowEvents:ArrayCollection = new ArrayCollection([
			{"value": "before-start-proc", "name": "流程启动前"},
			{"value": "after-start-proc", "name": "流程启动后"},
			{"value": "before-complete-proc", "name": "流程完成前"},
			{"value": "after-complete-proc", "name": "流程完成后"}
		]);
		
		[Bindable]
		public static var triggerMActEvents:ArrayCollection = new ArrayCollection([
			{"value": "before-start-act", "name": "活动启动前"},
			{"value": "after-start-act", "name": "活动启动后"},
			{"value": "before-complete-act", "name": "活动完成前"},
			{"value": "after-complete-act", "name": "活动完成后"},
			{"value": "after-create-wi", "name": "工作项创建后"},
			{"value": "after-get-wi", "name": "工作项领取后"},
			{"value": "after-canel-wi", "name": "工作项取消领取后"},
			{"value": "before-complete-wi", "name": "工作项完成前"},
			{"value": "after-complete-wi", "name": "工作项完成后"}
		]);
		
		[Bindable]
		public static var triggerActEvents:ArrayCollection = new ArrayCollection([
			{"value": "before-start-act", "name": "活动启动前"},
			{"value": "after-start-act", "name": "活动启动后"},
			{"value": "before-complete-act", "name": "活动完成前"},
			{"value": "after-complete-act", "name": "活动完成后"}
		]);
		
		[Bindable]
		public static var invokePatterns:ArrayCollection = new ArrayCollection([
			{"value": "synchronous", "name": "同步"},
			{"value": "asynchronous", "name": "异步"}
		]);
		
		[Bindable]
		public static var transactionTypes:ArrayCollection = new ArrayCollection([
			{"value": "join"},
			{"value": "suspend"}
		]);
		
		[Bindable]
		public static var exceptionStrategys:ArrayCollection = new ArrayCollection([
			{"value": "rollback", "name": "回滚异常"},
			{"value": "ignore", "name": "忽略异常"}
		]);

		public function DataHolder() {
		}
		
		public static function getActImages():ArrayList {
			if(actImages == null) {
				actImages = new ArrayList();
				actImages.addItem(new ActImage('人工环节', 'manual', 'images/manual_7_0.gif'));
				actImages.addItem(new ActImage('自动环节', 'toolApp', 'images/toolapp_7_0.gif'));
				actImages.addItem(new ActImage('子流程', 'subProcess', 'images/subflow_7_0.gif'));
				//actImages.addItem(new ActImage('WebService环节', 'webservice', 'images/ws_7_0.gif'));
				//actImages.addItem(new ActImage('电子邮件', 'email', 'images/email_7_0.gif'));
			}
			return actImages;
		}
		
		public static function getTriggerEventTypeName(type:String):String {
			if(triggerEventTypes == null) {
				triggerEventTypes = new HashMap();
				triggerEventTypes.put("before-start-proc", "流程启动前");
				triggerEventTypes.put("after-start-proc", "流程启动后");
				triggerEventTypes.put("before-finish-proc", "流程完成前");
				triggerEventTypes.put("after-finish-proc", "流程完成后");
				
				triggerEventTypes.put("before-start-act", "活动启动前");
				triggerEventTypes.put("after-start-act", "活动启动后");
				triggerEventTypes.put("before-finish-act", "活动完成前");
				triggerEventTypes.put("after-finish-act", "活动完成后");
				triggerEventTypes.put("after-create-wi", "工作项创建后");
				triggerEventTypes.put("after-get-wi", "工作项领取后");
				triggerEventTypes.put("after-cancel-wi", "工作项取消领取后");
				triggerEventTypes.put("before-finish-wi", "工作项完成前");
				triggerEventTypes.put("after-finish-wi", "工作项完成后");
			}
			return triggerEventTypes.getValue(type) as String;
		}
	}
}