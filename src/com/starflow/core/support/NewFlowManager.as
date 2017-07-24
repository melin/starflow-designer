package com.starflow.core.support {
	import com.starflow.components.ActImage;
	import com.starflow.core.util.Flow;
	import com.starflow.event.handle.FlowElementDDHandler;
	import com.starflow.model.FinishActivity;
	import com.starflow.model.StartActivity;
	
	import flash.events.MouseEvent;
	
	import mx.core.FlexGlobals;
	import mx.managers.DragManager;

	/**
	 * 新建流程，默认创建开始和结束环节。
	 * @author bsli
	 * 
	 */	
	public class NewFlowManager {
		private var flowDDHandler:FlowElementDDHandler = FlowElementDDHandler.getInstance();
		
		public function NewFlowManager(){
		}
		
		/**
		 * 为新流程创建开始和结束环节
		 * 
		 */		
		public function createFlow():void {
			var flashvars:Object = FlexGlobals.topLevelApplication.parameters;
			if(flashvars.version != "") {
				var newVersion:String = "";
				var verNums:Array = flashvars.version.split(".");
				var third:int = int(verNums.pop());
				var second:int = int(verNums.pop());
				var first:int = int(verNums.pop());
				if(third!=9){
					newVersion =  first +"."+ second +"."+(third+1);
				}
				if(9==third && second!=9){
					newVersion = first +"."+(second+1)+".1";
				}
				if(9==third && 9==second){
					newVersion = (first+1)+".1.1";
				}
				Flow.processDefine.version = newVersion;
			}
			Flow.processDefine.chname = flashvars.processCHName;
			Flow.processDefine.name = flashvars.processDefName;
			
			//开始环节
			var startAct:ActImage = new ActImage();
			startAct.activity = new StartActivity();
			startAct.id = "act_start";
			startAct.source = "images/start_7_0.gif";
			startAct.text = "开始";
			startAct.activity.type = "start";
			startAct.x = 40;
			startAct.y = 120;
			startAct.addEventListener(MouseEvent.MOUSE_MOVE, flowDDHandler.mouseMoveHandler);
			startAct.addEventListener(MouseEvent.MOUSE_DOWN, function(event:MouseEvent):void {
					flowDDHandler.mouseDownHandler(event, DragManager.MOVE, '开始', 'start');
				});
			Flow.processDefine.actImageMap.put("act_start", startAct);
			Flow.flowDesignerArea.addElement(startAct);
			
			//结束环节
			var finishAct:ActImage = new ActImage();
			finishAct.activity = new FinishActivity();
			finishAct.id = "act_finish";
			finishAct.source = "images/finish_7_0.gif";
			finishAct.text = "结束";
			finishAct.activity.type = "finish";
			finishAct.x = 500;
			finishAct.y = 120;
			finishAct.addEventListener(MouseEvent.MOUSE_MOVE, flowDDHandler.mouseMoveHandler);
			finishAct.addEventListener(MouseEvent.MOUSE_DOWN, function(event:MouseEvent):void {
				flowDDHandler.mouseDownHandler(event, DragManager.MOVE, '结束', 'finish');
			});
			Flow.processDefine.actImageMap.put("act_finish", finishAct);
			Flow.flowDesignerArea.addElement(finishAct);
		}
	}
}