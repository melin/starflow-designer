package com.starflow.core.support {
	import com.starflow.components.ActImage;
	import com.starflow.core.util.Flow;
	import com.starflow.line.LinkLine;
	import com.starflow.model.Activity;
	import com.starflow.model.ExtendNode;
	import com.starflow.model.FinishActivity;
	import com.starflow.model.FreeActivity;
	import com.starflow.model.ManualActivity;
	import com.starflow.model.Operation;
	import com.starflow.model.Participant;
	import com.starflow.model.ProcessDefine;
	import com.starflow.model.SOAPParameter;
	import com.starflow.model.StartActivity;
	import com.starflow.model.SubProcessActivity;
	import com.starflow.model.ToolAppActivity;
	import com.starflow.model.TriggerEvent;
	import com.starflow.model.WSDLParameter;
	import com.starflow.model.WebServiceActivity;
	
	import flash.geom.Point;
	
	import it.sephiroth.utils.Entry;
	import it.sephiroth.utils.collections.iterators.Iterator;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;

	public class ProcessDefineXMLBuilder {
		public function ProcessDefineXMLBuilder() {
		}
		
		public static function createXML():String {
			var process:ProcessDefine = Flow.processDefine;
			var xml:String = '<?xml version="1.0" encoding="UTF-8"?>\n' +
				'<ProcessDefine name="' + process.name + '" version="' + process.version + '" chname="' + process.chname +'">\n' +
				process.createXml() + 
				'	<Activitys>\n';
			
			//环节
			var acts:ArrayList = new ArrayList();
			var iterator:Iterator = Flow.processDefine.actImageMap.entrySet().iterator();
			while(iterator.hasNext()) {
				var entry:Entry = iterator.next() as Entry;
				var _act:ActImage = entry.getValue() as ActImage;
				acts.addItemAt(_act, 0);
			}
			
			for(var k:int=0, num:int=acts.length; k<num; k++) {
				var act:ActImage = acts.getItemAt(k) as ActImage;
				xml = xml + 
					'		<Activity id="' + act.id + '" type="' + act.activity.type + '" name="' + act.text + '">\n';
				
				if(act.activity.type == "start") { //开始环节
					var startActivity:StartActivity = act.activity as StartActivity;
					xml = xml +
						'			<splitMode>'+startActivity.splitMode+'</splitMode>\n' +
						'			<action>'+startActivity.action+'</action>\n' +
						'			<Operaions>\n';
					var len:int = startActivity.operations.length;
					for(var i:int=0; i<len; i++) {
						var op:Operation = startActivity.operations.getItemAt(i) as Operation;
						xml = xml +'				' + op.createXml();
					}
					xml = xml +
						'			</Operaions>\n';
				} else if(act.activity.type == "finish") { //结束环节
					var finishActivity:FinishActivity = act.activity as FinishActivity;
					xml = xml +
						'			<joinMode>'+finishActivity.joinMode+'</joinMode>\n' +
						'			<activateRuleType>'+finishActivity.activateRuleType+'</activateRuleType>\n' +
						'			<startStrategybyAppAction>'+finishActivity.startStrategybyAppAction+'</startStrategybyAppAction>\n';
				} else if(act.activity.type == "toolApp") { //自动环节
					var toolAppActivity:ToolAppActivity = act.activity as ToolAppActivity;
					xml = xml +
						'			<splitMode>'+toolAppActivity.splitMode+'</splitMode>\n' +
						'			<joinMode>'+toolAppActivity.joinMode+'</joinMode>\n' +
						'			<executeAction>'+toolAppActivity.executeAction+'</executeAction>\n' +
						'			<invokePattern>'+toolAppActivity.invokePattern+'</invokePattern>\n' +
						'			<finishType>'+toolAppActivity.finishType+'</finishType>\n' +
						'			<transactionType>'+toolAppActivity.transactionType+'</transactionType>\n' +
						'			<exceptionStrategy>'+toolAppActivity.exceptionStrategy+'</exceptionStrategy>\n' +
						'			<exceptionAction>'+toolAppActivity.exceptionAction+'</exceptionAction>\n' +
						'			<activateRuleType>'+toolAppActivity.activateRuleType+'</activateRuleType>\n' +
						'			<startStrategybyAppAction>'+toolAppActivity.startStrategybyAppAction+'</startStrategybyAppAction>\n' +
						createEventXml(toolAppActivity.triggerEvents)+
						createExtendNodeXml(toolAppActivity.extendNodes);
				} else if(act.activity.type == "subProcess") { //子流程
					var subFlowActivity:SubProcessActivity = act.activity as SubProcessActivity;
					xml = xml +
						'			<splitMode>'+subFlowActivity.splitMode+'</splitMode>\n' +
						'			<invokePattern>'+subFlowActivity.invokePattern+'</invokePattern>\n' +
						'			<subProcess>'+subFlowActivity.subProcess+'</subProcess>\n' +
						'			<joinMode>'+subFlowActivity.joinMode+'</joinMode>\n' +
						'			<activateRuleType>'+subFlowActivity.activateRuleType+'</activateRuleType>\n' +
						'			<startStrategybyAppAction>'+subFlowActivity.startStrategybyAppAction+'</startStrategybyAppAction>\n' +
						createEventXml(subFlowActivity.triggerEvents);
				} else if(act.activity.type == "webservice") { // WebService 环节
					var webServiceActivity:WebServiceActivity = act.activity as WebServiceActivity;
					xml = xml +
						'			<splitMode>'+webServiceActivity.splitMode+'</splitMode>\n' +
						'			<locationURL>'+webServiceActivity.locationURL+'</locationURL>\n' +
						'			<operation>'+webServiceActivity.operation+'</operation>\n'+
						'			<Parameters>\n';
						len = webServiceActivity.parameters.length
					for(i=0; i<len; i++) {
						var param:WSDLParameter = webServiceActivity.parameters.getItemAt(i) as WSDLParameter;
						xml = xml +'				'+param.createXml();
					}
					xml = xml +
						'			</Parameters>\n' +
						'			<SOAPParameters>\n';
					len = webServiceActivity.SOAPParameters.length
					for(i=0; i<len; i++) {
						var param1:SOAPParameter = webServiceActivity.SOAPParameters.getItemAt(i) as SOAPParameter;
						xml = xml +'				'+param1.createXml();
					}
					xml = xml +
						'			</SOAPParameters>\n' +
						'			<joinMode>'+webServiceActivity.joinMode+'</joinMode>\n' +
						'			<invokePattern>'+webServiceActivity.invokePattern+'</invokePattern>\n' +
						'			<finishType>'+webServiceActivity.finishType+'</finishType>\n' +
						'			<transactionType>'+webServiceActivity.transactionType+'</transactionType>\n' +
						'			<exceptionStrategy>'+webServiceActivity.exceptionStrategy+'</exceptionStrategy>\n' +
						'			<exceptionAction>'+webServiceActivity.exceptionAction+'</exceptionAction>\n' +
						'			<activateRuleType>'+webServiceActivity.activateRuleType+'</activateRuleType>\n' +
						'			<startStrategybyAppAction>'+webServiceActivity.startStrategybyAppAction+'</startStrategybyAppAction>\n' +
					createEventXml(webServiceActivity.triggerEvents)+
					createExtendNodeXml(webServiceActivity.extendNodes);
				} else if(act.activity.type == "manual") { //人工环节
					var manualActivity:ManualActivity = act.activity as ManualActivity;
					xml = xml +
						'			<splitMode>'+manualActivity.splitMode+'</splitMode>\n' +
						'			<joinMode>'+manualActivity.joinMode+'</joinMode>\n' + 
						'			<participantType>'+manualActivity.participantType+'</participantType>\n' +
						'			<particiLogic>'+manualActivity.particiLogic+'</particiLogic>\n' +
						'			<particiSpecActID>'+manualActivity.particiSpecActID+'</particiSpecActID>\n' +
						'			<Participants>\n';
					len = manualActivity.participants.length;
					for(i=0; i<len; i++) {
						var p:Participant = manualActivity.participants.getItemAt(i) as Participant;
						xml = xml +'				'+p.createXml();
					}
					xml = xml +
						'			</Participants>\n' +
						'			<isAllowAppointParticipants>'+manualActivity.isAllowAppointParticipants+'</isAllowAppointParticipants>\n' +
						'			<isFreeActivity>'+manualActivity.isFreeActivity+'</isFreeActivity>\n' + 
						'			<freeRangeStrategy>'+manualActivity.freeRangeStrategy+'</freeRangeStrategy>\n' +
						'			<FreeActivities>\n';
					len = manualActivity.freeActivitys.length;
					for(i=0; i<len; i++) {
						var f:FreeActivity = manualActivity.freeActivitys.getItemAt(i) as FreeActivity;
						xml = xml +	'				'+f.createXml();
					}
					xml = xml +
						'			</FreeActivities>\n' +
						'			<isOnlyLimitedManualActivity>'+manualActivity.isOnlyLimitedManualActivity+'</isOnlyLimitedManualActivity>\n' +
						'			<wiMode>'+manualActivity.wiMode+'</wiMode>\n' + 
						'			<workitemNumStrategy>'+manualActivity.workitemNumStrategy+'</workitemNumStrategy>\n' + 
						'			<isSequentialExecute>'+manualActivity.isSequentialExecute+'</isSequentialExecute>\n' + 
						'			<finishRule>'+manualActivity.finishRule+'</finishRule>\n' + 
						'			<finishRequiredPercent>'+manualActivity.finishRequiredPercent+'</finishRequiredPercent>\n' + 
						'			<finishRquiredNum>'+manualActivity.finishRquiredNum+'</finishRquiredNum>\n' + 
						'			<isAutoCancel>'+manualActivity.isAutoCancel+'</isAutoCancel>\n' + 
						'			<limitTime>'+manualActivity.limitTime+'</limitTime>\n' +
						'			<activateRuleType>'+manualActivity.activateRuleType+'</activateRuleType>\n' +
						'			<startStrategybyAppAction>'+manualActivity.startStrategybyAppAction+'</startStrategybyAppAction>\n' +
						'			<resetParticipant>'+manualActivity.resetParticipant+'</resetParticipant>\n' +
						'			<action>'+manualActivity.action+'</action>\n' +
						'			<Operations>\n';
					len = manualActivity.operations.length;
					for(i=0; i<len; i++) {
						var op1:Operation = manualActivity.operations.getItemAt(i) as Operation;
						xml = xml +'				' + op1.createXml();
					}
					xml = xml +
						'			</Operations>\n' +
					createEventXml(manualActivity.triggerEvents)+
					createExtendNodeXml(manualActivity.extendNodes);
				}
				
				xml = xml + 
					'			<description>'+act.activity.description+'</description>\n' +
					'			<position left="' + act.x + '" top="' + act.y + '"/>\n' +
					'		</Activity>\n';
			}
			
			xml = xml + 
				'	</Activitys>\n' +
				'	<Transitions>\n';
			
			//连线
			iterator = Flow.processDefine.lineMap.values().iterator();
			while(iterator.hasNext()) {
				var line:LinkLine = iterator.next() as LinkLine;
				var count:int = line.getPoints().length;
				
				var ps:String = "";
				for(var j:int=0; j<count; j++) {
					var point:Point = line.getPoints().getItemAt(j) as Point;
					if(j==(count-1))
						ps = ps + point.x + "," + point.y;
					else
						ps = ps + point.x + "," + point.y + " ";
				}
				
				xml = xml + 
					'		<Transition id="' + line.id + '" from="' + line.getFrom() + '" to="' + line.getTo() + '" name="' + line.label.text + '">\n' +
					'			<isDefault>' + line.transition.isDefault + '</isDefault>\n' +
					'			<isSimpleExpression>' + line.transition.isSimpleExpression + '</isSimpleExpression>\n' +
					'			<leftValue>' + line.transition.leftValue + '</leftValue>\n' +
					'			<compType>' + line.transition.compType + '</compType>\n' +
					'			<rightValue>' + line.transition.rightValue + '</rightValue>\n' +
					'			<complexExpressionValue><![CDATA[ ' + line.transition.complexExpressionValue + ' ]]></complexExpressionValue>\n' +
					'			<priority>' + line.transition.priority + '</priority>\n' +
					'			<position points="' + ps + '"/>\n' +
					'			<description>' + line.transition.description + '</description>\n' +
					'		</Transition>\n'
			}
			
			xml = xml +
				'	</Transitions>\n' +
				'</ProcessDefine>\n'
			
			return xml;
		}
		
		public static function createEventXml(triggerEvents:ArrayCollection):String {
			var len:int = triggerEvents.length;
			var xml:String = '			<TriggerEvents>\n';
			for(var i:int=0; i<len; i++) {
				var te:TriggerEvent = triggerEvents.getItemAt(i) as TriggerEvent;
				xml = xml + '				' + te.createXml();
			}
			xml = xml + '			</TriggerEvents>\n';
			return xml;
		}
		
		public static function createExtendNodeXml(extendNodes:ArrayCollection):String {
			var len:int = extendNodes.length;
			var xml:String = '			<ExtendNodes>\n';
			for(var i:int=0; i<len; i++) {
				var te:ExtendNode = extendNodes.getItemAt(i) as ExtendNode;
				xml = xml + '				' + te.createXml();
			}
			xml = xml + '			</ExtendNodes>\n';
			return xml;
		}
	}
}