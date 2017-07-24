package com.starflow.core.util {
	import com.starflow.components.ActImage;
	import com.starflow.components.LineMovePoint;
	import com.starflow.line.LinkLine;
	import com.starflow.model.ProcessDefine;
	import com.starflow.model.Transition;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;
	
	import spark.components.SkinnableContainer;
	
	public class Flow {
		
		public static var flowDesignerArea:SkinnableContainer;
		
		/**
		 * 流程定制区域是否可以拖动，默认值为flase，不可以拖动。
		 */		
		public static var isDD:Boolean = false;
		
		/**
		 * 监控流程，去掉环节和连线的右键菜单。去掉连线的移动节点功能
		 */
		public static var isViewFlow:Boolean = false;
		
		//线条颜色
		public static var lineColor:uint=0x8894AC;
		
		//箭头颜色
		public static var arrowColor:uint=0x527AB8;
		
		/**
		 * 当前显示的移动节点
		 */		
		private static var lineMovePoints:ArrayList = new ArrayList();
		public static var moveLine:LinkLine;
		
		/**
		 * 当前鼠标选择的移动节点，（mouseOver选择的节点）
		 */
		public static var currentMovePoint:LineMovePoint;
		
		/**
		 * 鼠标右击选择的连线
		 */
		public static var rcLine:LinkLine;
		
		/**
		 * 鼠标右击选择的环节
		 */
		public static var rcAct:ActImage;
		
		/**
		 * 焦点环节
		 */
		public static var focusAct:ActImage = null;
		
		/**
		 * 弹出属性窗口时，还能响应右键菜单bug，通过该属性控制
		 */
		public static var enableRightClick:Boolean = true;
		
		/**
		 * 流程定义对象
		 */
		public static var processDefine:ProcessDefine = new ProcessDefine();
		
		/**
		 * 环节模板信息
		 */
		public static var pageTemplates:ArrayCollection = null;
		
		/**
		 * 环节操作信息
		 */
		public static var operations:ArrayCollection = null;
		
		/**
		 * 参与者规则逻辑数据
		 */
		public static var particiLogices:ArrayCollection = null;
		
		/**
		 * 环节启动规则逻辑数据
		 */
		public static var activateRules:ArrayCollection = null;
		
		/**
		 * 自动环节执行逻辑数据
		 */
		public static var executeActions:ArrayCollection = null;
		
		/**
		 * 自动环节异常执行逻辑数据
		 */
		public static var exceptionActions:ArrayCollection = null;
		
		public function Flow() {
		}
		
		public static function addLineMovePoint(movePoint:LineMovePoint):void {
			lineMovePoints.addItem(movePoint);
		}
		
		public static function getLineMovePoint():ArrayList {
			return lineMovePoints
		}
	}
}