package com.starflow.event.handle {
	import com.starflow.components.ActImage;
	import com.starflow.components.LineMovePoint;
	import com.starflow.core.util.Flow;
	import com.starflow.core.util.FlowUtil;
	import com.starflow.line.LinkLine;
	import com.starflow.model.Activity;
	import com.starflow.model.ManualActivity;
	import com.starflow.model.SubProcessActivity;
	import com.starflow.model.ToolAppActivity;
	import com.starflow.model.WebServiceActivity;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.*;
	
	import it.sephiroth.utils.Entry;
	import it.sephiroth.utils.collections.iterators.Iterator;
	
	import mx.collections.ArrayList;
	import mx.controls.Image;
	import mx.events.DragEvent;
	import mx.managers.DragManager;
	
	import spark.components.Label;
	import spark.components.SkinnableContainer;
	import spark.primitives.Line;

	/**
	 * 流程定制区域，流程图元拖动处理。
	 * 
	 * @author libinsong1204@gmail.com
	 * 
	 */	
	public class FlowElementDDHandler {
		private var x:int;
		private var y:int;
		private var feedback:String;
		private var imgText:String;
		private var type:String;
		private static var instance:FlowElementDDHandler;
		private var lineMovePointHandler:LineMovePointHandler = LineMovePointHandler.getInstance();
		
		private var isDD4LeftActImage:Boolean = false;
		
		public static function getInstance():FlowElementDDHandler {
			if(instance == null)
				instance = new FlowElementDDHandler();
			return instance;
		}
		
		public function FlowElementDDHandler() {
		}
		
		/**
		 * 双击流程定制区域，清除移动节点 
		 * @param event
		 * 
		 */		
		public function dbClickHandler(event:MouseEvent):void {
			FlowUtil.deleteLineMovePoint();
		}
		
		/**
		 * click流程定制区域，选择移动节点状态恢复为：normal
		 */
		public function clickHandler(event:MouseEvent):void {
			if(Flow.currentMovePoint != null) {
				Flow.currentMovePoint.currentState = "normal";
				Flow.currentMovePoint = null;
			}
		}
		
		public function mouseDownHandler(event:MouseEvent, feedback:String, imgText:String, type:String, isDD:Boolean = false):void {
			isDD4LeftActImage = isDD;
			if(!Flow.isDD && !isDD4LeftActImage)
				return;
			
			this.x = event.currentTarget.mouseX;
			this.y = event.currentTarget.mouseY;
			this.feedback = feedback;
			this.imgText = imgText;
			this.type = type;
		}
		
		public function mouseMoveHandler(event:MouseEvent):void {
			if(!Flow.isDD && !isDD4LeftActImage)
				return;
			
			var dragSrc:ActImage = event.currentTarget as ActImage;
			
			if(dragSrc != null) {
				var proxy:Image = new Image();
				proxy.width = dragSrc.width;
				proxy.height = dragSrc.height;
				proxy.source = dragSrc.source;
				proxy.buttonMode = true;
				DragManager.doDrag(dragSrc, null, event, proxy);
			} else {
				//从左边拖动图元到流程定制区域
				var dragSrcImg:Image = event.currentTarget as Image;
				var proxyImg:Image = new Image();
				proxyImg.width = dragSrcImg.width;
				proxyImg.height = dragSrcImg.height;
				proxyImg.source = dragSrcImg.source;
				proxyImg.buttonMode = true;
				DragManager.doDrag(dragSrcImg, null, event, proxyImg);
			}
		}
		
		public function dragOverHandler(event:DragEvent):void {
			if(!Flow.isDD && !isDD4LeftActImage)
				return;
			
			if (this.feedback == DragManager.COPY) {                    
				DragManager.showFeedback(DragManager.COPY);
				return;
			}
			else {
				DragManager.showFeedback(DragManager.MOVE);
				return;
			}
		}
		
		public function dragEnterHandler(event:DragEvent):void {
			DragManager.acceptDragDrop(event.currentTarget as SkinnableContainer);
		}
		
		public function dragDropHandler(event:DragEvent):void {
			var className:String = getQualifiedClassName(event.dragInitiator);
			if(className == "com.starflow.components::LineMovePoint") {
				lineMovePointHandler.dragDropHandler(event);
				return;
			}
			
			if(!Flow.isDD && !isDD4LeftActImage)
				return;
			
			var newImage:ActImage = null;
			if (this.feedback == DragManager.COPY) {
				var draggedImage:Image = Image(event.dragInitiator);
				
				newImage = new ActImage();
				newImage.text = this.imgText;
				if(this.type == "manual")
					newImage.activity = new ManualActivity();
				else if(this.type == "toolApp")
					newImage.activity = new ToolAppActivity();
				else if(this.type == "subProcess")
					newImage.activity = new SubProcessActivity();
				else if(this.type == "webservice")
					newImage.activity = new WebServiceActivity();
				
				newImage.activity.type = this.type;
				newImage.source = draggedImage.source.toString();
				newImage.width = draggedImage.width;
				newImage.x = event.currentTarget.contentMouseX - x;
				newImage.y = event.currentTarget.contentMouseY - y;
				newImage.height = draggedImage.height;
				newImage.id = FlowUtil.getActId();
				
				newImage.addEventListener(MouseEvent.MOUSE_MOVE, this.mouseMoveHandler);
				newImage.addEventListener(MouseEvent.MOUSE_DOWN, function(event:MouseEvent):void {
					mouseDownHandler(event, DragManager.MOVE, this.imgText, this.type);
				});
				Flow.flowDesignerArea.addElement(newImage);
				
				Flow.processDefine.actImageMap.put(newImage.id, newImage);
			} else {
				newImage = ActImage(event.dragInitiator);
				newImage.x = event.currentTarget.mouseX - x;
				newImage.y = event.currentTarget.mouseY - y;
				reDrawLines(newImage);
			}
			
			//如果有连线移动点，清除
			FlowUtil.deleteLineMovePoint();
		}
		
		/**
		 * 拖动图元以后，需要重新设置与拖动环节连线的位置
		 *  
		 * @param actImage
		 * @param container
		 * 
		 */		
		public function reDrawLines(actImage:ActImage):void {
			var iterator:Iterator = Flow.processDefine.lineMap.values().iterator();
			while(iterator.hasNext()) { 
				var line:LinkLine = iterator.next() as LinkLine;
				var len:int = line.getPoints().length;
				
				var newLine:LinkLine;
				if(line.getTo() == actImage.id) {
					newLine = new LinkLine();
					for(var i:int=0; i<(len-1); i++)
						newLine.getPoints().addItem(line.getPoints().getItemAt(i));
					newLine.getPoints().addItem(new Point(actImage.x+20, actImage.y+20));
					
					_ReDrawLines(newLine, line);
				} else if(line.getFrom() == actImage.id) {
					newLine = new LinkLine();
					newLine.getPoints().addItem(new Point(actImage.x+20, actImage.y+20));
					for(var j:int=1; j<len; j++)
						newLine.getPoints().addItem(line.getPoints().getItemAt(j));
					
					_ReDrawLines(newLine, line);
				}
			}
		}
		
		private function _ReDrawLines(newLine:LinkLine, oldLine:LinkLine):void {
			newLine.id = oldLine.id;
			newLine.transition = oldLine.transition;
			newLine.label = oldLine.label;
			newLine.drawLine();
			
			FlowUtil.addLine(newLine.id, newLine);
			
			Flow.flowDesignerArea.removeElement(oldLine);
			//重新设置连线文字说明文字的位置
			FlowUtil.setLineTextPoint(newLine);
			Flow.flowDesignerArea.addElement(newLine);
		}
	}
}