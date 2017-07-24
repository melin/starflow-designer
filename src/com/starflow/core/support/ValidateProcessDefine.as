package com.starflow.core.support {
	import com.starflow.components.ActImage;
	import com.starflow.core.util.Flow;
	import com.starflow.line.LinkLine;
	import com.starflow.model.FinishActivity;
	import com.starflow.model.ManualActivity;
	import com.starflow.model.SubProcessActivity;
	import com.starflow.model.ToolAppActivity;
	import com.starflow.model.WebServiceActivity;
	
	import it.sephiroth.utils.collections.iterators.Iterator;

	/**
	 * 验证流程定义
	 *  
	 * @author libisnong1204@hotmail.com
	 * 
	 */	
	public class ValidateProcessDefine {
		public function ValidateProcessDefine() {
		}
		
		public static function validate():Boolean {
			var iterAct:Iterator = Flow.processDefine.actImageMap.values().iterator();
			var flag:Boolean = false;
			while(iterAct.hasNext()) {
				var actImage:ActImage = iterAct.next() as ActImage;
				actImage.toolTipText = "";
				if(actImage.activity.type == "start")
					flag = checkStart(actImage);
				else if(actImage.activity.type == "finish")
					flag = checkFinish(actImage);
				else if(actImage.activity.type == "manual")
					flag = checkManual(actImage);
				else if(actImage.activity.type == "toolApp")
					flag = checkToolApp(actImage);
				else if(actImage.activity.type == "subProcess")
					flag = checkSubFlow(actImage);
				else if(actImage.activity.type == "webservice")
					flag = checkWebService(actImage);
			}
			return flag;
		}
		
		/**
		 * 检测开始环节配置 
		 * @param actImage
		 * 
		 */	
		public static function checkManual(actImage:ActImage):Boolean {
			var flag:Boolean = checkIsolateActivity(actImage);
			if(actImage.text == "") {
				flag = true
				actImage.toolTipText = actImage.toolTipText + "["+actImage.text+"]人工环节必须指定环节名称\n";
			}
			
			var activity:ManualActivity = actImage.activity as ManualActivity;
			
			if(activity.participantType == "org-role" && activity.participants.length == 0) {
				flag = true;
				actImage.toolTipText = actImage.toolTipText + "["+actImage.text+"]人工环节参与者类型为组织机构与角色，值不能为空\n";
			} else if(activity.participantType == "act-executer" && activity.particiSpecActID == "") {
				flag = true;
				actImage.toolTipText = actImage.toolTipText + "["+actImage.text+"]人工环节参与者类型为活动执行者，值不能为空\n";
			} else 	if(activity.participantType == "act-logic" && activity.particiLogic == "") {
				flag = true;
				actImage.toolTipText = actImage.toolTipText + "["+actImage.text+"]人工环节参与者类型为规则逻辑中获取，值不能为空\n";
			}
			
			if(activity.finishRule == "specifyNum" && activity.finishRquiredNum == "") {
				flag = true;
				actImage.toolTipText = actImage.toolTipText + "["+actImage.text+"]人工环节多工作项设置，完成个数值不能为空\n";
			} else 	if(activity.finishRule == "specifyPercent" && activity.finishRequiredPercent == "") {
				flag = true;
				actImage.toolTipText = actImage.toolTipText + "["+actImage.text+"]人工环节多工作项设置，完成百分比值不能为空\n";
			}
			
			if(activity.freeRangeStrategy == "freeWithinActivityList" && activity.freeActivitys.length == 0) {
				flag = true;
				actImage.toolTipText = actImage.toolTipText + "["+actImage.text+"]人工环节在指定活动列表范围内自由，值不能为空\n";
			}
			
			if(activity.activateRuleType == "startStrategybyApp" && 
				activity.startStrategybyAppAction == "") {
				flag = true
				actImage.toolTipText = actImage.toolTipText + "["+actImage.text+"]人工环节启动策略由规则逻辑返回值确定，必须指定执行逻辑\n";
			}
			
			changeImage(actImage, flag);
			return flag;
		}
		
		/**
		 * 检测开始环节配置 
		 * @param actImage
		 * 
		 */	
		public static function checkStart(actImage:ActImage):Boolean {
			var flag:Boolean = checkIsolateActivity(actImage);
			if(actImage.text == "") {
				flag = true
				actImage.toolTipText = actImage.toolTipText + "["+actImage.text+"]开始环节必须指定环节名称\n";
			}
			
			changeImage(actImage, flag);
			return flag;
		}
		
		/**
		 * 检测开始环节配置 
		 * @param actImage
		 * 
		 */	
		public static function checkFinish(actImage:ActImage):Boolean {
			var flag:Boolean = checkIsolateActivity(actImage);
			if(actImage.text == "") {
				flag = true
				actImage.toolTipText = actImage.toolTipText + "["+actImage.text+"]结束环节必须指定环节名称\n";
			}
			
			var activity:FinishActivity = actImage.activity as FinishActivity;
			if(activity.activateRuleType == "startStrategybyApp" && 
				activity.startStrategybyAppAction == "") {
				flag = true
				actImage.toolTipText = actImage.toolTipText + "["+actImage.text+"]结束环节启动策略由规则逻辑返回值确定，必须指定执行逻辑\n";
			}
			
			changeImage(actImage, flag);
			return flag;
		}
		
		/**
		 * 检测自动环节配置 
		 * @param actImage
		 * 
		 */		
		public static function checkToolApp(actImage:ActImage):Boolean {
			var flag:Boolean = checkIsolateActivity(actImage);
			if(actImage.text == "") {
				flag = true
				actImage.toolTipText = actImage.toolTipText + "["+actImage.text+"]自动环节必须指定环节名称\n";
			}
			
			var activity:ToolAppActivity = actImage.activity as ToolAppActivity;
			/*if(activity.executeAction == "") {
				flag = true
				actImage.toolTipText = actImage.toolTipText + "["+actImage.text+"]自动环节必须指定执行逻辑\n";
			}*/
			if(activity.activateRuleType == "startStrategybyApp" && 
				activity.startStrategybyAppAction == "") {
				flag = true
				actImage.toolTipText = actImage.toolTipText + "["+actImage.text+"]自动环节启动策略由规则逻辑返回值确定，必须指定执行逻辑\n";
			}
			
			changeImage(actImage, flag);
			return flag;
		}
		
		/**
		 * 检测WebService环节配置 
		 * @param actImage
		 * 
		 */		
		public static function checkWebService(actImage:ActImage):Boolean {
			var flag:Boolean = checkIsolateActivity(actImage);
			if(actImage.text == "") {
				flag = true
				actImage.toolTipText = actImage.toolTipText + "["+actImage.text+"]WebService环节必须指定环节名称\n";
			}
			
			var activity:WebServiceActivity = actImage.activity as WebServiceActivity;
			if(activity.locationURL == "") {
				flag = true
				actImage.toolTipText = actImage.toolTipText + "["+actImage.text+"]WebService环节必须指定服务地址\n";
			}
			if(activity.operation == "") {
				flag = true
				actImage.toolTipText = actImage.toolTipText + "["+actImage.text+"]WebService环节必须指定服务操作\n";
			}
			if(activity.activateRuleType == "startStrategybyApp" && 
				activity.startStrategybyAppAction == "") {
				flag = true
				actImage.toolTipText = actImage.toolTipText + "["+actImage.text+"]WebService环节启动策略由规则逻辑返回值确定，必须指定执行逻辑\n";
			}
			
			changeImage(actImage, flag);
			return flag;
		}
		
		/**
		 * 检测子流程配置 
		 * @param actImage
		 * 
		 */		
		public static function checkSubFlow(actImage:ActImage):Boolean {
			var flag:Boolean = checkIsolateActivity(actImage);
			if(actImage.text == "") {
				flag = true
				actImage.toolTipText = actImage.toolTipText + "["+actImage.text+"]子流程必须指定环节名称\n";
			}
			
			var activity:SubProcessActivity = actImage.activity as SubProcessActivity;
			if(activity.subProcess == "") {
				flag = true
				actImage.toolTipText = actImage.toolTipText + "["+actImage.text+"]子流程必须指定流程\n";
			}
			if(activity.activateRuleType == "startStrategybyApp" && 
				activity.startStrategybyAppAction == "") {
				flag = true
				actImage.toolTipText = actImage.toolTipText + "["+actImage.text+"]子流程节启动策略由规则逻辑返回值确定，必须指定执行逻辑\n";
			}
			
			changeImage(actImage, flag);
			return flag;
		}
		
		/**
		 * 所有环节必须直接或间接的与开始环节相连
		 * 
		 */		
		private static function checkIsolateActivity(actImage:ActImage):Boolean {
			/*var flag:Boolean = true;
			actImage.toolTipText = "";
			
			if(actImage.id == "act_start") {
				var iterTran:Iterator = Flow.processDefine.lineMap.values().iterator();
				while(iterTran.hasNext()) {
					var line:LinkLine = iterTran.next() as LinkLine;
					if(line.transition.from == actImage.id) {
						flag = false;
						break;
					}
				}
				if(flag) {
					actImage.toolTipText = actImage.toolTipText + "["+actImage.text+"]环节是一个孤立的环节\n";
				}
			} else {
				flag = checkToStart(actImage);
				if(flag) {
					actImage.toolTipText = actImage.toolTipText + "["+actImage.text+"]环节无法到达，所有环节必须直接或间接与开始环节相连\n";
				}
			}*/
		
			return false;
		}
		
		private static function checkToStart(actImage:ActImage):Boolean {
			var iterTran:Iterator = Flow.processDefine.lineMap.values().iterator();
			var flag:Boolean = true;
			while(iterTran.hasNext()) {
				var line:LinkLine = iterTran.next() as LinkLine;
				if(line.transition.to == actImage.id) {
					if(line.transition.from == "act_start") {
						flag = false;
					} else {
						var act:ActImage = 
							Flow.processDefine.actImageMap.getValue(line.transition.from) as ActImage;
						if(flag)
							flag = checkToStart(act);
					}
				}
			}
			return flag;
		}
		
		/**
		 * 切换图片
		 * 
		 */	
		private static function changeImage(actImage:ActImage, flag:Boolean):void {
			if(flag)
				actImage.source = actImage.source.replace("0", "1");
			else
				actImage.source = actImage.source.replace("1", "0");
		}
	}
}