package com.starflow.event.handle {
	import com.starflow.components.ActImage;
	import com.starflow.components.LineMovePoint;
	import com.starflow.core.util.Flow;
	import com.starflow.core.util.FlowUtil;
	import com.starflow.line.LinkLine;
	
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import it.sephiroth.utils.collections.iterators.Iterator;
	
	import mx.collections.ArrayList;
	import mx.events.DragEvent;
	import mx.managers.DragManager;

	public class LineMovePointHandler {
		private var x:int;
		private var y:int;
		private var imgText:String;
		private static var instance:LineMovePointHandler;
		
		
		public static function getInstance():LineMovePointHandler {
			if(instance == null)
				instance = new LineMovePointHandler();
			return instance;
		}
		
		public function LineMovePointHandler() {
		}
		
		public function mouseDownHandler(event:MouseEvent):void {
			event.stopPropagation();
			this.x = event.currentTarget.mouseX;
			this.y = event.currentTarget.mouseY;
		}
		
		public function mouseMoveHandler(event:MouseEvent):void {
			event.stopPropagation();
			var movePont:LineMovePoint = event.currentTarget as LineMovePoint;
			var proxy:LineMovePoint = new LineMovePoint();
			DragManager.doDrag(movePont, null, event, proxy);
		}
		
		public function dragDropHandler(event:DragEvent):void {
			event.stopPropagation();
			
			if(!isDragDrop(event)) {
				//如果是连线第一个或者最后一个移动点，通过判断坐标位置，判断移动到那个新的环节上，并重新划线
				var iter:Iterator = Flow.processDefine.actImageMap.values().iterator();
				while(iter.hasNext()) {
					var actImage:ActImage = iter.next() as ActImage;
					var mx:int = event.currentTarget.mouseX - x;
					var my:int = event.currentTarget.mouseY - y;
					if(actImage.x<mx && mx<(actImage.x+40) && 
						actImage.y<my && my<(actImage.y+40))
						reDrawLine(event, actImage)
				}
			} else {
				var movePoint:LineMovePoint = null;
				movePoint = LineMovePoint(event.dragInitiator);
				movePoint.x = event.currentTarget.mouseX - x;
				movePoint.y = event.currentTarget.mouseY - y;
				reDrawLine(event);
			}
		}
		
		/**
		 * 如果是连线第一个或者最后一个移动点。需要判断移动到的位置是否在一个新的环节上。
		 */		
		private function isDragDrop(event:DragEvent):Boolean {
			var movePoint:LineMovePoint = LineMovePoint(event.dragInitiator);
			if(movePoint.index == 0)
				return false;
			else if(movePoint.index == (Flow.getLineMovePoint().length-1))
				return false
			return true;
		}
		
		/**
		 * 移动节点后，重新划线
		 *  
		 * @param event
		 * 
		 */		
		public function reDrawLine(event:DragEvent, actImage:ActImage = null):void {
			var currentMovePoint:LineMovePoint = LineMovePoint(event.dragInitiator);
			var movePoints:ArrayList = Flow.getLineMovePoint();
			var line:LinkLine = new LinkLine();
			for(var i:int=0, len:int=movePoints.length; i<len; i++) {
				var movePoint:LineMovePoint = movePoints.getItemAt(i) as LineMovePoint;
				if(i==currentMovePoint.index) {
					//如果移动的是第一个或者最后一个移动点，计算器移动位置，
					if(i==0 || i == (len-1)) {
						line.addPoint(new Point(actImage.x + 20, actImage.y + 20));
						resetMovePoint(i, actImage.id);
					} else
						line.addPoint(new Point(event.currentTarget.mouseX, event.currentTarget.mouseY));
					movePoint.isVisual = false;
				} else {
					if(!movePoint.isVisual)
						line.addPoint(new Point(movePoint.point.x, movePoint.point.y));
				}
			}
			line.id = Flow.moveLine.id;
			line.transition = Flow.moveLine.transition;
			line.label = Flow.moveLine.label;
			
			FlowUtil.addLine(line.id, line);
			Flow.flowDesignerArea.removeElement(Flow.moveLine);
			line.drawLine();
			Flow.moveLine = line;
			Flow.flowDesignerArea.addElement(line);
			//重新设置连线文字说明文字的位置
			FlowUtil.setLineTextPoint(line);
			line.dispatchEvent(new MouseEvent(MouseEvent.DOUBLE_CLICK));
		}
		
		/**
		 * 需要修改Transition的from或者to属性值
		 *   
		 * @return 
		 * 
		 */		
		private function resetMovePoint(index:int, id:String):void {
			if(index == 0) 
				Flow.moveLine.transition.from = id;
			else
				Flow.moveLine.transition.to = id;
		}
		
		/**
		 * delete键删除选择的移动节点，并拉直连线 
		 * @param event
		 * 
		 */		
		public function deleteMovePointHandler(event:KeyboardEvent):void {
			if(Flow.currentMovePoint == null)
				return;
			
			var movePoint:LineMovePoint = Flow.currentMovePoint;
			var movePoints:ArrayList = Flow.getLineMovePoint();
			var line:LinkLine = new LinkLine();
			for(var i:int=0, len:int=movePoints.length; i<len; i++) {
				var mpoint:LineMovePoint = movePoints.getItemAt(i) as LineMovePoint;
				if(movePoint.index != i && !mpoint.isVisual) {
					line.addPoint(new Point(mpoint.point.x, mpoint.point.y));
				}
			}
			line.id = Flow.moveLine.id;
			line.transition = Flow.moveLine.transition;
			line.label = Flow.moveLine.label;
			
			FlowUtil.addLine(line.id, line);
			Flow.flowDesignerArea.removeElement(Flow.moveLine);
			line.drawLine();
			Flow.moveLine = line;
			Flow.flowDesignerArea.addElement(line);
			//重新设置连线文字说明文字的位置
			FlowUtil.setLineTextPoint(line);
			line.dispatchEvent(new MouseEvent(MouseEvent.DOUBLE_CLICK));
			Flow.currentMovePoint = null;
		}
	}
}