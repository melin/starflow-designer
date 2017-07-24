package com.starflow.core.support {
	import com.starflow.components.ActImage;
	import com.starflow.components.EditableLabel;
	import com.starflow.core.data.DataHolder;
	import com.starflow.core.util.Flow;
	import com.starflow.core.util.FlowUtil;
	import com.starflow.event.handle.FlowElementDDHandler;
	import com.starflow.line.LinkLine;
	import com.starflow.model.ExtendNode;
	import com.starflow.model.FinishActivity;
	import com.starflow.model.FreeActivity;
	import com.starflow.model.ManualActivity;
	import com.starflow.model.Operation;
	import com.starflow.model.Participant;
	import com.starflow.model.StartActivity;
	import com.starflow.model.SubProcessActivity;
	import com.starflow.model.ToolAppActivity;
	import com.starflow.model.Transition;
	import com.starflow.model.TriggerEvent;
	import com.starflow.model.WSDLParameter;
	import com.starflow.model.WebServiceActivity;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.URLVariables;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;
	import mx.core.FlexGlobals;
	import mx.managers.DragManager;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.mxml.HTTPService;

	/**
	 * 更新流程定义。
	 * @author bsli
	 * 
	 */	
	public class UpdateFlowManager {
		private var flowDDHandler:FlowElementDDHandler = FlowElementDDHandler.getInstance();
		private var httpService:HTTPService;
		
		public function UpdateFlowManager(){
			httpService = new HTTPService();
			httpService.addEventListener(ResultEvent.RESULT, resultHandler);
			httpService.addEventListener(FaultEvent.FAULT, faultHandler);
			httpService.resultFormat = "xml";
			httpService.method = "POST";
			var params:Object = FlexGlobals.topLevelApplication.parameters;
			httpService.url = params.queryFlowUrl;
		}
		
		/**
		 * 重新打开流程定义
		 * 
		 */		
		public function openFlow():void {
			var flashvars:Object = FlexGlobals.topLevelApplication.parameters; 
			var params:URLVariables = new URLVariables(); 
			params.id = flashvars.processDefId;
			httpService.send(params);
		}
		
		private function resultHandler(event:ResultEvent):void {
			var result:XML = XML(event.result);  
			var actNodes:XMLList = result..Activity;
			var tranNodes:XMLList = result..Transition;  
			var node:XML = null;  
			for each (node in actNodes) {
				if(node.@type == "start")
					createStartAct(node);
				else if(node.@type == "finish")
					createFinishAct(node);
				else if(node.@type == "manual")
					createManualAct(node);
				else if(node.@type == "toolApp")
					createToolAppAct(node);
				else if(node.@type == "subProcess")
					createSubflow(node);
				else if(node.@type == "webservice")
					createWebServiceAct(node);
			}
			
			for each (node in tranNodes) {
				createTransition(node)
			}
			
			//流程属性
			Flow.processDefine.name = result.@name;
			Flow.processDefine.chname = result.@chname;
			Flow.processDefine.version = result.@version;
			Flow.processDefine.limitTime = result.ProcessProperty.limitTime;
			Flow.processDefine.description = result.ProcessProperty.description;
			Flow.processDefine.processStarterType = result.ProcessProperty.processStarterType;
			var teNodes:XMLList = result.ProcessProperty.TriggerEvents;
			if(teNodes.length()>0)
				Flow.processDefine.triggerEvents = createTriggerEvent(teNodes[0]);
			var eeNodes:XMLList = result.ProcessProperty.ExtendNodes;
			if(eeNodes.length()>0)
				Flow.processDefine.extendNodes = createExtendNode(eeNodes[0]);
			var nodes:XMLList = result..processStarter;
			var pnode:XML = null;  
			for each (pnode in nodes) {
				var participant:Participant = new Participant();
				participant.id = pnode.@id;
				participant.name = pnode.@name;
				participant.type = pnode.@type;
				if(pnode.@type == "organization")
					participant.typeName = "机构";
				else if(pnode.@type == "person")
					participant.typeName = "人员";
				else if(pnode.@type == "role")
					participant.typeName = "角色";
				Flow.processDefine.processStarters.addItem(participant);
			}
		}
		
		private function createStartAct(node:XML):void {
			var startAct:ActImage = new ActImage();
			var activity:StartActivity = new StartActivity();
			startAct.id = "act_start";
			startAct.source = "images/start_7_0.gif";
			startAct.text = node.@name;
			activity.type = node.@type;
			startAct.x = node.position.@left;
			startAct.y = node.position.@top;
			startAct.addEventListener(MouseEvent.MOUSE_MOVE, flowDDHandler.mouseMoveHandler);
			startAct.addEventListener(MouseEvent.MOUSE_DOWN, function(event:MouseEvent):void {
				flowDDHandler.mouseDownHandler(event, DragManager.MOVE, node.@name, 'start');
			});
			
			activity.splitMode = node.splitMode;
			
			//环节操作信息
			activity.action = node.action;
			var operaionNodes:XMLList = node..operaion;
			var opnode:XML = null;  
			for each (opnode in operaionNodes) {
				var operation:Operation = new Operation();
				operation.id = opnode.@id;
				operation.code = opnode.@code;
				operation.action = opnode.@action;
				operation.name = opnode.@name;
				activity.operations.addItem(operation);
			}
			
			activity.description = node.description;
			startAct.activity = activity;
			Flow.processDefine.actImageMap.put("act_start", startAct);
			Flow.flowDesignerArea.addElement(startAct);
		}
		
		private function createFinishAct(node:XML):void {
			var finishAct:ActImage = new ActImage();
			var activity:FinishActivity = new FinishActivity();
			finishAct.id = "act_finish";
			finishAct.source = "images/finish_7_0.gif";
			finishAct.text = node.@name;
			activity.type = node.@type;
			finishAct.x = node.position.@left;
			finishAct.y = node.position.@top;
			finishAct.addEventListener(MouseEvent.MOUSE_MOVE, flowDDHandler.mouseMoveHandler);
			finishAct.addEventListener(MouseEvent.MOUSE_DOWN, function(event:MouseEvent):void {
				flowDDHandler.mouseDownHandler(event, DragManager.MOVE, node.@name, 'finish');
			});
			
			activity.joinMode = node.joinMode;
			activity.activateRuleType = node.activateRuleType;
			activity.startStrategybyAppAction = node.startStrategybyAppAction;
			activity.description = node.description;
			finishAct.activity = activity;
			Flow.processDefine.actImageMap.put("act_finish", finishAct);
			Flow.flowDesignerArea.addElement(finishAct);
		}
		
		private function createToolAppAct(node:XML):void {
			var toolAppAct:ActImage = new ActImage();
			var activity:ToolAppActivity = new ToolAppActivity();
			toolAppAct.id = node.@id;
			toolAppAct.source = "images/toolapp_7_0.gif";
			toolAppAct.text = node.@name;
			activity.type = node.@type;
			toolAppAct.x = node.position.@left;
			toolAppAct.y = node.position.@top;
			toolAppAct.addEventListener(MouseEvent.MOUSE_MOVE, flowDDHandler.mouseMoveHandler);
			toolAppAct.addEventListener(MouseEvent.MOUSE_DOWN, function(event:MouseEvent):void {
				flowDDHandler.mouseDownHandler(event, DragManager.MOVE, node.@name, 'toolApp');
			});
			
			activity.splitMode = node.splitMode;
			activity.joinMode = node.joinMode;
			activity.executeAction = node.executeAction;
			activity.invokePattern = node.invokePattern;
			activity.finishType = node.finishType;
			activity.transactionType = node.transactionType;
			activity.exceptionStrategy = node.exceptionStrategy;
			activity.exceptionAction = node.exceptionAction;
			activity.activateRuleType = node.activateRuleType;
			activity.startStrategybyAppAction = node.startStrategybyAppAction;
			activity.description = node.description;
			
			activity.triggerEvents = createTriggerEvent(node);
			activity.extendNodes = createExtendNode(node);
			toolAppAct.activity = activity;
			Flow.processDefine.actImageMap.put(toolAppAct.id, toolAppAct);
			Flow.flowDesignerArea.addElement(toolAppAct);
			
			var _id:int = int(toolAppAct.id.substr(4));
			if(FlowUtil.actIndex <= _id)
				FlowUtil.actIndex = _id + 1;
		}
		
		private function createWebServiceAct(node:XML):void {
			var wsAppAct:ActImage = new ActImage();
			var activity:WebServiceActivity = new WebServiceActivity();
			wsAppAct.id = node.@id;
			wsAppAct.source = "images/ws_7_0.gif";
			wsAppAct.text = node.@name;
			activity.type = node.@type;
			wsAppAct.x = node.position.@left;
			wsAppAct.y = node.position.@top;
			wsAppAct.addEventListener(MouseEvent.MOUSE_MOVE, flowDDHandler.mouseMoveHandler);
			wsAppAct.addEventListener(MouseEvent.MOUSE_DOWN, function(event:MouseEvent):void {
				flowDDHandler.mouseDownHandler(event, DragManager.MOVE, node.@name, 'toolApp');
			});
			
			activity.locationURL = node.locationURL;
			activity.operation = node.operation;
			var paramNodes:XMLList = node..Parameters..parameter;
			var pnode:XML = null;  
			for each (pnode in paramNodes) {
				var param:WSDLParameter = new WSDLParameter();
				param.name = pnode.@name;
				param.dataType = pnode.@dataType;
				param.fillBack = (pnode.@fillBack=="true" ? true:false);
				param.mode = pnode.@mode;
				if(param.mode == "parameter")
					param.modeName = "参数";
				else
					param.modeName = "返回值";
				param.value = pnode.@value;
				if(param.value == "")
					param.value = pnode.value;
				
				param.valueType = pnode.@valueType;
				if(param.valueType == "variable")
					param.valueTypeName = "变量";
				else
					param.valueTypeName = "常量";
				activity.parameters.addItem(param);
			}
			
			activity.splitMode = node.splitMode;
			activity.joinMode = node.joinMode;
			activity.invokePattern = node.invokePattern;
			activity.finishType = node.finishType;
			activity.transactionType = node.transactionType;
			activity.exceptionStrategy = node.exceptionStrategy;
			activity.exceptionAction = node.exceptionAction;
			activity.activateRuleType = node.activateRuleType;
			activity.startStrategybyAppAction = node.startStrategybyAppAction;
			activity.description = node.description;
			
			activity.triggerEvents = createTriggerEvent(node);
			activity.extendNodes = createExtendNode(node);
			wsAppAct.activity = activity;
			Flow.processDefine.actImageMap.put(wsAppAct.id, wsAppAct);
			Flow.flowDesignerArea.addElement(wsAppAct);
			
			var _id:int = int(wsAppAct.id.substr(4));
			if(FlowUtil.actIndex <= _id)
				FlowUtil.actIndex = _id + 1;
		}
		
		private function createSubflow(node:XML):void {
			var subflowAct:ActImage = new ActImage();
			var activity:SubProcessActivity = new SubProcessActivity();
			subflowAct.id = node.@id;
			subflowAct.source = "images/subflow_7_0.gif";
			subflowAct.text = node.@name;
			activity.type = node.@type;
			subflowAct.x = node.position.@left;
			subflowAct.y = node.position.@top;
			subflowAct.addEventListener(MouseEvent.MOUSE_MOVE, flowDDHandler.mouseMoveHandler);
			subflowAct.addEventListener(MouseEvent.MOUSE_DOWN, function(event:MouseEvent):void {
				flowDDHandler.mouseDownHandler(event, DragManager.MOVE, node.@name, 'subflow');
			});
			
			activity.splitMode = node.splitMode;
			activity.joinMode = node.joinMode;
			activity.invokePattern = node.invokePattern;
			activity.subProcess = node.subProcess;
			activity.description = node.description;
			activity.activateRuleType = node.activateRuleType;
			activity.startStrategybyAppAction = node.startStrategybyAppAction;
			
			activity.triggerEvents = createTriggerEvent(node);
			subflowAct.activity = activity;
			Flow.processDefine.actImageMap.put(subflowAct.id, subflowAct);
			Flow.flowDesignerArea.addElement(subflowAct);
			
			var _id:int = int(subflowAct.id.substr(4));
			if(FlowUtil.actIndex <= _id)
				FlowUtil.actIndex = _id + 1;
		}
		
		private function createManualAct(node:XML):void {
			//基本信息
			var manualAct:ActImage = new ActImage();
			var activity:ManualActivity = new ManualActivity();
			manualAct.id = node.@id;
			manualAct.source = "images/manual_7_0.gif";
			manualAct.text = node.@name;
			activity.type = node.@type;
			manualAct.x = node.position.@left;
			manualAct.y = node.position.@top;
			manualAct.addEventListener(MouseEvent.MOUSE_MOVE, flowDDHandler.mouseMoveHandler);
			manualAct.addEventListener(MouseEvent.MOUSE_DOWN, function(event:MouseEvent):void {
				flowDDHandler.mouseDownHandler(event, DragManager.MOVE, node.@name, 'manual');
			});
			
			activity.splitMode = node.splitMode;
			activity.joinMode = node.joinMode;
			
			//环节操作信息
			activity.action = node.action;
			var operationNodes:XMLList = node..operation;
			var opnode:XML = null;  
			for each (opnode in operationNodes) {
				var operation:Operation = new Operation();
				operation.id = opnode.@id;
				operation.code = opnode.@code;
				operation.action = opnode.@action;
				operation.name = opnode.@name;
				activity.operations.addItem(operation);
			}
			
			//参与者
			activity.participantType = node.participantType;
			activity.isAllowAppointParticipants = node.isAllowAppointParticipants;
			activity.particiLogic = node.particiLogic;
			activity.particiSpecActID = node.particiSpecActID;
			var particiNodes:XMLList = node..participant;
			var pnode:XML = null;  
			for each (pnode in particiNodes) {
				var participant:Participant = new Participant();
				participant.id = pnode.@id;
				participant.name = pnode.@name;
				participant.type = pnode.@type;
				if(pnode.@type == "organization")
					participant.typeName = "机构";
				else if(pnode.@type == "person")
					participant.typeName = "人员";
				else if(pnode.@type == "role")
					participant.typeName = "角色";
				activity.participants.addItem(participant);
			}
			//自由流
			activity.isFreeActivity = (node.isFreeActivity=="true" ? true : false);
			activity.freeRangeStrategy = node.freeRangeStrategy;
			var freeActNodes:XMLList = node..freeActivity;
			var fanode:XML = null;  
			for each (fanode in freeActNodes) {
				var freeActivity:FreeActivity = new FreeActivity();
				freeActivity.id = fanode.@id;
				freeActivity.name = fanode.@name;
				activity.freeActivitys.addItem(freeActivity);
			}
			activity.isOnlyLimitedManualActivity = (node.isOnlyLimitedManualActivity=="true" ? true : false);
			
			//多工作项
			activity.wiMode = node.wiMode;
			activity.workitemNumStrategy = node.workitemNumStrategy;
			activity.isAllowAppointParticipants = node.isAllowAppointParticipants;
			activity.finishRule = node.finishRule;
			activity.finishRequiredPercent = node.finishRequiredPercent;
			activity.finishRquiredNum = node.finishRquiredNum;
			activity.isAutoCancel = node.isAutoCancel;
			activity.limitTime = node.limitTime;
			activity.activateRuleType = node.activateRuleType;
			activity.startStrategybyAppAction = node.startStrategybyAppAction;
			activity.resetParticipant = node.resetParticipant;
			
			activity.description = node.description;
			
			activity.triggerEvents = createTriggerEvent(node);
			activity.extendNodes = createExtendNode(node);
			manualAct.activity = activity;
			Flow.processDefine.actImageMap.put(manualAct.id, manualAct);
			Flow.flowDesignerArea.addElement(manualAct);
			
			var _id:int = int(manualAct.id.substr(4));
			if(FlowUtil.actIndex <= _id)
				FlowUtil.actIndex = _id + 1;
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
			line.drawLine();
			Flow.flowDesignerArea.addElement(line);
			
			line.id = node.@id;
			line.transition = new Transition();
			line.transition.from = node.@from;
			line.transition.to = node.@to;
			line.transition.isDefault = (node.isDefault=="true" ? true:false);
			line.transition.isSimpleExpression = (node.isSimpleExpression=="true" ? true:false);
			line.transition.leftValue = node.leftValue;
			line.transition.compType = node.compType;
			line.transition.rightValue = node.rightValue;
			line.transition.complexExpressionValue = node.complexExpressionValue;
			line.transition.priority = node.priority;
			line.transition.description = node.description;
			
			line.label = new EditableLabel();
			line.label.text = node.@name;
			FlowUtil.setLineTextPoint(line);
			
			Flow.flowDesignerArea.addElement(line.label);
			FlowUtil.addLine(line.id, line);
			
			var _id:int = int(line.id.substr(5));
			if(FlowUtil.lineIndex <= _id)
				FlowUtil.lineIndex = _id + 1;
		}
		
		private function faultHandler(event:FaultEvent):void {  
			trace(event.fault.faultString)
		} 
		
		private function createTriggerEvent(node:XML):ArrayCollection {
			var eventNodes:XMLList = node..event;
			var enode:XML = null; 
			var events:ArrayCollection = new ArrayCollection();
			for each (enode in eventNodes) {
				var te:TriggerEvent = new TriggerEvent();
				te.eventType = enode.@eventType;
				te.eventTypeName = DataHolder.getTriggerEventTypeName(te.eventType);
				te.invokePattern = enode.@invokePattern;
				if(te.invokePattern == "synchronous")
					te.invokePatternName = "同步";
				else
					te.invokePatternName = "异步";
					
				te.transactionType = enode.@transactionType;
				te.exceptionStrategy = enode.@exceptionStrategy;
				if(te.exceptionStrategy == "rollback")
					te.exceptionStrategyName == "回滚异常";
				else
					te.exceptionStrategyName == "忽略异常";
				
				te.description = enode.@description;
				te.action = enode.@action;
				events.addItem(te);
			}
			
			return events;
		}
		
		private function createExtendNode(node:XML):ArrayCollection {
			var extendNodes:XMLList = node..extendNode;
			var enode:XML = null; 
			var nodes:ArrayCollection = new ArrayCollection();
			for each (enode in extendNodes) {
				var te:ExtendNode = new ExtendNode();
				te.key = enode.@key;
				te.value = enode.@value;
				te.description = enode.@description;
				
				nodes.addItem(te);
			}
			
			return nodes;
		}
	}
}