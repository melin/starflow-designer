package com.starflow.core.support {
	import com.starflow.components.ActImage;
	import com.starflow.components.EditableLabel;
	import com.starflow.core.util.Flow;
	import com.starflow.core.util.FlowUtil;
	import com.starflow.event.handle.FlowElementDDHandler;
	import com.starflow.line.LinkLine;
	import com.starflow.model.Activity;
	import com.starflow.model.FreeActivity;
	import com.starflow.model.Operation;
	import com.starflow.model.Participant;
	import com.starflow.model.Transition;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.URLVariables;
	
	import it.sephiroth.utils.HashMap;
	
	import mx.collections.ArrayList;
	import mx.core.FlexGlobals;
	import mx.managers.DragManager;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.mxml.HTTPService;

	/**
	 * 监控流程运行。
	 * @author bsli
	 * 
	 */	
	public class ViewFlowManager {
		private var flowDDHandler:FlowElementDDHandler = FlowElementDDHandler.getInstance();
		private var httpService:HTTPService;
		private var httpServiceTransCtrl:HTTPService;
		private var transCtrls:ArrayList = new ArrayList();
		private var acts:HashMap = new HashMap();
		
		public function ViewFlowManager(){
			httpService = new HTTPService();
			httpService.addEventListener(ResultEvent.RESULT, resultHandler);
			httpService.addEventListener(FaultEvent.FAULT, faultHandler);
			httpService.resultFormat = "xml";
			httpService.method = "POST";
			httpService.concurrency = "single";
			var params:Object = FlexGlobals.topLevelApplication.parameters;
			httpService.url = params.queryFlowUrl;
			
			httpServiceTransCtrl = new HTTPService();
			httpServiceTransCtrl.addEventListener(ResultEvent.RESULT, resultHandlerTransCtrl);
			httpServiceTransCtrl.addEventListener(FaultEvent.FAULT, faultHandler);
			httpServiceTransCtrl.resultFormat = "xml";
			httpServiceTransCtrl.method = "POST";
			httpServiceTransCtrl.concurrency = "single";
			httpServiceTransCtrl.url = params.queryTransctrlUrl;
		}
		
		/**
		 * 重新打开流程定义
		 * 
		 */		
		public function openFlow():void {
			var flashvars:Object = FlexGlobals.topLevelApplication.parameters; 
			var params:URLVariables = new URLVariables(); 
			params.id = flashvars.processInstId;
			httpServiceTransCtrl.send(params);
		}
		
		private function resultHandlerTransCtrl(event:ResultEvent):void {
			var result:XML = XML(event.result);  
			var nodes:XMLList = result..activity;  
			var node:XML = null;  
			for each (node in nodes) {
				acts.put(node.@id, node.@status)
			}
			
			var tranNodes:XMLList = result..transctrl;  
			for each (node in tranNodes) {
				var obj:Object = new Object();
				obj.src = node.@srcId;
				obj.dest = node.@destId;
				transCtrls.addItem(obj);
			}
			
			var flashvars:Object = FlexGlobals.topLevelApplication.parameters; 
			var params:URLVariables = new URLVariables(); 
			params = new URLVariables(); 
			params.id = flashvars.processDefId;
			httpService.send(params);
		}
		
		private function resultHandler(event:ResultEvent):void {
			var result:XML = XML(event.result);  
			var actNodes:XMLList = result..Activity;
			var tranNodes:XMLList = result..Transition;  
			var node:XML = null;  
			for each (node in actNodes) {
				var fix:String = "1";
				var len:int = transCtrls.length;
				for(var j:int=0; j<len; j++) {
					if(transCtrls.getItemAt(j).src == node.@id || 
						transCtrls.getItemAt(j).dest == node.@id) {
						fix = "7_0";
						break;
					}
				}
				
				//设置正在运行或终止环节图元
				var status:String = String(acts.getValue(node.@id));
				if(status == "10") //运行
					fix = "2";
				else if(status == "7") //终止
					fix = "8";
					
				if(node.@type == "start") {
					createAct(node, "images/start_"+fix+".gif");
				} else if(node.@type == "finish") {
					createAct(node, "images/finish_"+fix+".gif");
				} else if(node.@type == "manual") {
					createAct(node, "images/manual_"+fix+".gif");
				} else if(node.@type == "toolApp") {
					createAct(node, "images/toolapp_"+fix+".gif");
				} else if(node.@type == "subProcess") {
					createAct(node, "images/subflow_"+fix+".gif");
				} else if(node.@type == "webservice") {
					createAct(node, "images/subflow_"+fix+".gif");
				}
			}
			
			for each (node in tranNodes) {
				createTransition(node)
			}
		}
		
		private function createAct(node:XML, source:String):void {
			var act:ActImage = new ActImage();
			act.id = node.@id;
			act.source = source;
			act.text = node.@name;
			act.activity = new Activity();
			act.activity.type = node.@type;
			act.x = node.position.@left;
			act.y = node.position.@top;
			Flow.flowDesignerArea.addElement(act);
			Flow.processDefine.actImageMap.put(act.id, act);
		}
		
		public function createTransition(node:XML):void {
			var line:LinkLine = new LinkLine();
			var position:String = node.position.@points;
			var arr:Array = position.split(" ");
			for(var i:int=0,len:int=arr.length; i<len; i++) {
				var str:String = arr.pop() as String;
				var arr1:Array = str.split(",");
				var left:int = arr1.pop();
				var top:int = arr1.pop();
				line.addPointAt(new Point(top, left), 0);
			}
			
			//设置两个环节之间连线的颜色
			var flag:Boolean = true;
			len = transCtrls.length;
			for(var j:int=0; j<len; j++) {
				if(transCtrls.getItemAt(j).src == node.@from && 
					transCtrls.getItemAt(j).dest == node.@to) {
					flag = false;
					break;
				}
			}
			if(flag) {
				Flow.lineColor = 0xA0A0A0;
				Flow.arrowColor = 0x7F7F7F;
			} else {
				Flow.lineColor = 0xFF0000;
				Flow.arrowColor = 0xFF0000;
			}
			
			line.drawLine();
			Flow.flowDesignerArea.addElement(line);
			
			line.id = node.@id;
						
			line.label = new EditableLabel();
			line.label.text = node.@name;
			FlowUtil.setLineTextPoint(line);
			
			Flow.flowDesignerArea.addElement(line.label);
			FlowUtil.addLine(line.id, line);
		}
		
		private function faultHandler(event:FaultEvent):void {  
			trace(event.fault.faultString)
		}  
	}
}