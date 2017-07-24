package com.starflow.line
{
	import com.starflow.components.ActImage;
	import com.starflow.components.EditableLabel;
	import com.starflow.components.win.TransitionWin;
	import com.starflow.core.support.LineMenuBuilder;
	import com.starflow.core.support.RightClickManager;
	import com.starflow.core.util.Flow;
	import com.starflow.core.util.FlowUtil;
	import com.starflow.event.handle.LinkLineHandler;
	import com.starflow.model.Transition;
	
	import flash.display.CapsStyle;
	import flash.display.JointStyle;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.collections.ArrayList;
	import mx.controls.Menu;
	import mx.core.UIComponent;
	import mx.events.MenuEvent;
	
	
	public class LinkLine extends UIComponent{
		
		//连线所有折点
		private var points:ArrayList = new ArrayList();
		//线提示语
		private var tip:String="";
		//是否要箭头
		private var isArrow:Boolean=true;
		//箭头大小
		private var radius:uint=6;
		
		[Embed("images/icons/ten.png")]
		public var customCursor:Class;
		
		public var label:EditableLabel;
		public var transition:Transition;
		
		public function LinkLine(){
			super();
			this.doubleClickEnabled = true;
			var linkLineHandler:LinkLineHandler = new LinkLineHandler();
			linkLineHandler.setLine(this);
			
			if(!Flow.isViewFlow) {
				this.addEventListener(MouseEvent.DOUBLE_CLICK, linkLineHandler.doubleClickHandle);
				this.addEventListener(RightClickManager.RIGHT_CLICK, LineMenuBuilder.getInstance().rightClickHandler);
			}
		}
		
		//获得线的角度
		public function getAngle():Number{
			var len:int = points.length;
			var tmpx:Number=points.getItemAt(len-1).x - points.getItemAt(len-2).x;
			var tmpy:Number=points.getItemAt(len-2).y - points.getItemAt(len-1).y;
			var angle:Number= Math.atan2(tmpy,tmpx)*(180/Math.PI);
			return angle;
		}
		
		/**
		 * 重新计算开始和结束点的坐标。
		 * 
		 */
		public var newStartPoint:Point;
		public var newFinishPoint:Point;
		private function computerStartFinishPoint():void {
			var len:int = points.length;
			var arr:Array = FlowUtil.computerPoint(points.getItemAt(0).x, points.getItemAt(0).y, 
				points.getItemAt(1).x, points.getItemAt(1).y);
			newStartPoint = new Point(points.getItemAt(0).x+arr[0], points.getItemAt(0).y+arr[1]);
			
			arr = FlowUtil.computerPoint(points.getItemAt(len-1).x, points.getItemAt(len-1).y, 
				points.getItemAt(len-2).x, points.getItemAt(len-2).y);
			newFinishPoint = new Point(points.getItemAt(len-1).x+arr[0], points.getItemAt(len-1).y+arr[1]);
		}
		
		//画线
		public function drawLine():void{
			computerStartFinishPoint();
			
			var len:int = points.length;
			this.graphics.clear();
			this.graphics.lineStyle(1,Flow.lineColor, 1.0, false, "normal", CapsStyle.SQUARE, JointStyle.ROUND, 2);
			
			var arr:Array = FlowUtil.computerPoint(points.getItemAt(0).x, points.getItemAt(0).y, 
				points.getItemAt(1).x, points.getItemAt(1).y);
			this.graphics.moveTo(points.getItemAt(0).x+arr[0], points.getItemAt(0).y+arr[1]);
			
			for(var i:int=1; i<len-1; i++) {
				this.graphics.lineTo(points.getItemAt(i).x,points.getItemAt(i).y);
			}
			
			arr = FlowUtil.computerPoint(points.getItemAt(len-1).x, points.getItemAt(len-1).y, 
				points.getItemAt(len-2).x, points.getItemAt(len-2).y);
			this.graphics.lineTo(points.getItemAt(len-1).x+arr[0], points.getItemAt(len-1).y+arr[1]);
			
			this.toolTip=tip;
			if(isArrow){
				var angle:Number = this.getAngle();
				var centerX:Number = points.getItemAt(len-1).x+arr[0] - radius * Math.cos(angle*(Math.PI/180));
				var centerY:Number = points.getItemAt(len-1).y+arr[1] + radius * Math.sin(angle*(Math.PI/180));
				var topX:Number = points.getItemAt(len-1).x+arr[0];
				var topY:Number = points.getItemAt(len-1).y+arr[1];
				
				var leftX:Number = centerX + radius * Math.cos((angle+120)*(Math.PI/180));
				var leftY:Number = centerY - radius * Math.sin((angle+120)*(Math.PI/180));
				var rightX:Number = centerX + radius * Math.cos((angle+240)*(Math.PI/180));
				var rightY:Number = centerY - radius * Math.sin((angle+240)*(Math.PI/180));
				this.graphics.beginFill(Flow.arrowColor,1);
				this.graphics.lineStyle(1,Flow.lineColor,1);
				this.graphics.moveTo(topX,topY);
				this.graphics.lineTo(leftX,leftY);
				this.graphics.lineTo(centerX,centerY);
				this.graphics.lineTo(rightX,rightY);
				this.graphics.lineTo(topX,topY);
				this.graphics.endFill();
			}
		}
		public function removeLine():void{
			this.graphics.clear();
		}
		
		public function addPoint(point:Point):LinkLine {
			this.points.addItem(point);
			return this;
		}
		
		public function addPointAt(point:Point, index:int):LinkLine {
			this.points.addItemAt(point, index);
			return this;
		}
		
		public function getPoints():ArrayList {
			return this.points;	
		}
		
		public function setTip(tip:String):void {
			this.tip=tip;
		}
		public function setArrow(flag:Boolean):void {
			this.isArrow=flag;
		}
		
		public function getFrom():String {
			return this.transition.from;
		}
		
		public function getTo():String {
			return this.transition.to;
		}
	}
}