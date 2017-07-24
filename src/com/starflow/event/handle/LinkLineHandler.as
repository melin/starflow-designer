package com.starflow.event.handle {
	import com.starflow.components.ActImage;
	import com.starflow.components.EditableLabel;
	import com.starflow.components.LineMovePoint;
	import com.starflow.core.util.Flow;
	import com.starflow.core.util.FlowUtil;
	import com.starflow.line.LinkLine;
	import com.starflow.model.Transition;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.profiler.showRedrawRegions;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import mx.collections.ArrayList;
	import mx.controls.Alert;
	
	import spark.components.SkinnableContainer;

	public class LinkLineHandler {
		private var mouseDownPoint : Point = new Point(); 
		private var isLinkLine:Boolean =  false;
		private var startX:Number;
		private var startY:Number;
		private var lastActImage:ActImage;
		private var lineColor:uint=0x000000;
		
		//连线，开始环节ID
		private var startId:String;
		
		private var lineMovePointHandler:LineMovePointHandler = LineMovePointHandler.getInstance();
		private var line:LinkLine;
		
		public function LinkLineHandler(){
		}
		
		public function onMouseDown(event:MouseEvent):void {
			if(Flow.isDD)
				return;
			var type:String = getQualifiedClassName(event.target.parent);
			if("com.starflow.components::FocusImage" != type)
				return;
			
			startId = event.target.parent.parent.id;
			isLinkLine = true;
			lastActImage = event.target.parent.parent as ActImage;
			/*startX = event.currentTarget.contentMouseX;
			startY = event.currentTarget.contentMouseY;*/
			startX = lastActImage.x + 20;
			startY = lastActImage.y + 20;
		}
		
		public function onMouseMove(event:MouseEvent):void {
			if(Flow.isDD)
				return;
			
			if(isLinkLine) {
				var container:SkinnableContainer = event.currentTarget as SkinnableContainer;
				if(line != null)
					container.removeElement(line);
				line = new LinkLine();
				line.addPoint(new Point(startX,startY));
				
				var finishX:int = event.currentTarget.contentMouseX;
				var finishY:int = event.currentTarget.contentMouseY;
				var arr:Array = computerMouseXY(finishX, finishY);
				line.addPoint(new Point(finishX - arr[0], finishY - arr[1]));
				
				line.drawLine();
				container.addElement(line);
			}
		}
		
		private function computerMouseXY(endX:int, endY:int):Array {
			var w:int = endX - startX;
			var h:int = endY - startY;
			var len:int = Math.sqrt(w*w + h*h);
			return [(-12*w)/len, (-12*h)/len];
		}
		
		public function onMouseUp(event:MouseEvent):void {
			if(Flow.isDD)
				return;
			if(!isLinkLine)
				return;
			
			isLinkLine = false;
			if(line == null)
				return;
			
			var container:SkinnableContainer = event.currentTarget as SkinnableContainer;
			var type:String = getQualifiedClassName(event.target.parent);
			if("com.starflow.components::FocusImage" != type && line != null){
				container.removeElement(line);
				line = null;
				return;
			}
			
			var actImage:ActImage = event.target.parent.parent as ActImage;
			var endId:String = actImage.id;
			//不可自己连接自己
			if(startId == endId && line != null) {
				container.removeElement(line);
				line = null;
				return;
			}
			//两个环节之间不可重复连线
			if(FlowUtil.isReLine(startId, endId)){
				container.removeElement(line);
				line = null;
				return;
			}
			
			//重新设置连线终点的位置
			container.removeElement(line);
			line = new LinkLine();
			var endX:int = actImage.x + 20;
			var endY:int = actImage.y + 20;
			line.addPoint(new Point(startX, startY));
			line.addPoint(new Point(endX, endY));
			line.drawLine();
			container.addElement(line);
			
			line.id = FlowUtil.getLineId();
			
			line.transition = new Transition();
			line.transition.from = startId;
			line.transition.to = endId;
			FlowUtil.addLine(line.id, line);
			
			creatLineText(line);
			line = null;
		}
		
		/**
		 * 创建连线的文本说明文字
		 */
		private function creatLineText(line:LinkLine):void {
			line.label = new EditableLabel();
			FlowUtil.setLineTextPoint(line);
			Flow.flowDesignerArea.addElement(line.label);
		}
		
		/**
		 * 双击连线，添加连线可移动点
		 */
		public function doubleClickHandle(event:MouseEvent):void {
			event.stopPropagation();
			
			//防止多次双击连线，出现异常。
			FlowUtil.deleteLineMovePoint();
			
			Flow.moveLine = this.line;
			var len:int = line.getPoints().length;
			var index:int = 0;
			for(var i:int=0; i<len; i++) {
				var movePoint:LineMovePoint = new LineMovePoint();
				if(i==0)
					movePoint.point = line.newStartPoint;
				else if(i == (len-1))
					movePoint.point = line.newFinishPoint;
				else
					movePoint.point = line.getPoints().getItemAt(i) as Point;
				
				movePoint.index = index++;
				movePoint.isVisual = false;
				movePoint.addEventListener(MouseEvent.MOUSE_DOWN, lineMovePointHandler.mouseDownHandler);
				movePoint.addEventListener(MouseEvent.MOUSE_MOVE, lineMovePointHandler.mouseMoveHandler);
				Flow.flowDesignerArea.addElement(movePoint);
				movePoint.point = line.getPoints().getItemAt(i) as Point;
				Flow.addLineMovePoint(movePoint);
				
				if((i+1) < len) {
					var movePointZJ:LineMovePoint = new LineMovePoint();
					if(i==0)
						movePointZJ.startPoint = line.newStartPoint;
					else
						movePointZJ.startPoint = line.getPoints().getItemAt(i) as Point;
					
					if((i+2)==len)
						movePointZJ.finishPoint = line.newFinishPoint;
					else
						movePointZJ.finishPoint = line.getPoints().getItemAt(i+1) as Point;
					
					movePointZJ.index = index++;
					movePointZJ.isVisual = true;
					movePointZJ.addEventListener(MouseEvent.MOUSE_DOWN, lineMovePointHandler.mouseDownHandler);
					movePointZJ.addEventListener(MouseEvent.MOUSE_MOVE, lineMovePointHandler.mouseMoveHandler);
					Flow.addLineMovePoint(movePointZJ)
					Flow.flowDesignerArea.addElement(movePointZJ);
				}
			}
		}
		
		public function setLine(line:LinkLine):void {
			this.line = line;
		}
	}
}