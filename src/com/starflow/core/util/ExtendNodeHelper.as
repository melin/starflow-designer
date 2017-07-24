package com.starflow.core.util {
	import com.starflow.core.data.DataHolder;
	import com.starflow.model.ExtendNode;
	import com.starflow.model.ManualActivity;
	import com.starflow.model.SubProcessActivity;
	import com.starflow.model.ToolAppActivity;
	import com.starflow.model.TriggerEvent;
	import com.starflow.model.WebServiceActivity;
	
	import flash.events.MouseEvent;
	
	import mx.controls.DataGrid;
	import mx.events.DataGridEvent;

	public class ExtendNodeHelper {
		public function ExtendNodeHelper() {
		}
		
		public static function addEvent_clickHandler(event:MouseEvent, extendNodeGrid:DataGrid, type:String):void {
			var extendNode:ExtendNode = new ExtendNode();
			if(type == 'flow') {
				Flow.processDefine.extendNodes.addItem(extendNode);
				extendNodeGrid.dataProvider = Flow.processDefine.extendNodes;
			} else {
				Flow.rcAct.activity.extendNodes.addItem(extendNode);
				extendNodeGrid.dataProvider = Flow.rcAct.activity.extendNodes;
			}
		}
		
		public static function removeEvent_clickHandler(event:MouseEvent, extendNodeGrid:DataGrid, type:String):void {
			if(type == 'flow') {
				if(extendNodeGrid.selectedItem != null) {
					var index:int = Flow.processDefine.extendNodes.getItemIndex(extendNodeGrid.selectedItem);
					Flow.processDefine.extendNodes.removeItemAt(index);
				}
			} else {
				if(extendNodeGrid.selectedItem != null) {
					var index1:int = -1;
					index1 = Flow.rcAct.activity.extendNodes.getItemIndex(extendNodeGrid.selectedItem)
					Flow.rcAct.activity.extendNodes.removeItemAt(index1);
				}
			}
		}
		
		public static function eventGrid_itemEditEndHandler(event:DataGridEvent):void {
			var dataField:String = event.dataField;
		}
	}
}