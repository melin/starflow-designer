package com.starflow.core.util {
	import com.starflow.components.ActImage;
	import com.starflow.components.LineMovePoint;
	import com.starflow.line.LinkLine;
	
	import flash.geom.Point;
	
	import it.sephiroth.utils.Entry;
	import it.sephiroth.utils.EntrySet;
	import it.sephiroth.utils.collections.iterators.Iterator;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;
	import mx.utils.UIDUtil;
	
	import spark.components.ComboBox;
	import spark.events.DropDownEvent;

	public class FlowUtil {
		public function FlowUtil() {
		}
		
		/**
		 * 生成环节定义ID
		 *  
		 * @return 
		 * 
		 */
		public static var actIndex:int = 1;
		public static function getActId():String {
			return "Act_" + (actIndex++);
		}
		
		/**
		 * 生成连线ID
		 *  
		 * @return 
		 * 
		 */		
		public static var lineIndex:int = 1;
		public static function getLineId():String {
			return "Line_" + (lineIndex++);
		}
		
		/**
		 * 判断两个环节之间是否重复划线
		 *  
		 * @return 
		 * 
		 */	
		public static function isReLine(startId:String, finishId:String):Boolean {
			var iterator:Iterator = Flow.processDefine.lineMap.values().iterator();
			while(iterator.hasNext()) {
				var line:LinkLine = iterator.next() as LinkLine;
				if(startId == line.getFrom() && finishId == line.getTo())
					return true;
			}
			
			return false;
		}
		
		public static function addLine(id:String, line:LinkLine):void {
			Flow.processDefine.lineMap.put(id, line);
		}
		
		/**
		 * 计算连线在环节开始或者终点，想加的x，y的位置。
		 */
		public static function computerPoint(startX:int, startY:int, finishX:int, finishY:int):Array {
			var w:int = finishX - startX;
			var h:int = finishY - startY;
			var len:int = Math.sqrt(w*w + h*h);
			
			var x:int = (20*w)/len;
			var y:int = (20*h)/len;
			return [x, y];
		}
		
		/**
		 * 设置连线的文本说明文字的坐标位置
		 */
		public static function setLineTextPoint(line:LinkLine):void {
			var points:ArrayList = line.getPoints();
			var len:int = points.length;
			var midd:int = Math.ceil(len/2);
			
			var x:int, y:int;
			if(len%2 == 0) {
				var sPoint:Point = points.getItemAt(midd) as Point;
				var ePoint:Point = points.getItemAt(midd-1) as Point;
				x = (sPoint.x + ePoint.x)/2 - line.label.width/2;
				y = (sPoint.y + ePoint.y)/2;
				line.label.x = x;
				line.label.y = y;
			} else {
				var point:Point = points.getItemAt(midd-1) as Point;
				x = point.x - line.label.width/2;
				y = point.y;
				line.label.x = x;
				line.label.y = y;
			}
		}
		
		/**
		 * 清除移动节点 
		 * 
		 */		
		public static function deleteLineMovePoint():void {
			var movePoints:ArrayList = Flow.getLineMovePoint();
			for(var j:int=0, count:int=movePoints.length; j<count; j++) {
				Flow.flowDesignerArea.removeElement(movePoints.getItemAt(j) as LineMovePoint);
			}
			movePoints.removeAll();
		}
		
		/**
		 * 删除环节
		 */
		public static function deleteAct(actImage:ActImage):void {
			Flow.flowDesignerArea.removeElement(actImage);
			
			Flow.processDefine.actImageMap.remove(actImage.id);
			
			//删除连线
			var iterator:Iterator = Flow.processDefine.lineMap.values().iterator();
			var lines:ArrayList = new ArrayList();
			while(iterator.hasNext()) {
				var line:LinkLine = iterator.next() as LinkLine;
				if(actImage.id == line.getFrom()) {
					Flow.flowDesignerArea.removeElement(line.label);
					Flow.flowDesignerArea.removeElement(line);		
					lines.addItem(line.id);
				} else if(actImage.id == line.getTo()) {
					Flow.flowDesignerArea.removeElement(line.label);
					Flow.flowDesignerArea.removeElement(line);		
					lines.addItem(line.id);
				}
			}
			for(var i:int=0, len:int=lines.length; i<len; i++) {
				Flow.processDefine.lineMap.remove(lines.getItemAt(i));
			}
			
			deleteLineMovePoint();
		}
		
		/**
		 * 
		 * @param event
		 * @param combobox
		 * @param data
		 * 
		 */		
		public static function comboBox_renderHandler(combobox:ComboBox, data:Object, property:String):void {
			var arr:ArrayCollection = combobox.dataProvider as ArrayCollection;
			for(var i:int=0, len:int=arr.length; i<len; i++) {
				if(data[property] == arr.getItemAt(i).value) {
					combobox.selectedIndex = i;
					break;
				}
			}
		}
		
		/**
		 * 
		 * @param event
		 * @param combobox
		 * @param data
		 * @param valueSelected
		 * 
		 */		
		public static function comboBox_closeHandler(event:DropDownEvent, combobox:ComboBox, data:Object, 
													 eventTypeNameSelected:String, property:String):void {
			var obj:Object = combobox.selectedItem;
			eventTypeNameSelected = obj.name;
			data[property] = obj.value;	
		}
	}
}