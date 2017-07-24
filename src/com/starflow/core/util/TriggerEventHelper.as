package com.starflow.core.util {
	import com.starflow.core.data.DataHolder;
	import com.starflow.model.ManualActivity;
	import com.starflow.model.SubProcessActivity;
	import com.starflow.model.ToolAppActivity;
	import com.starflow.model.TriggerEvent;
	import com.starflow.model.WebServiceActivity;
	
	import flash.events.MouseEvent;
	
	import mx.controls.DataGrid;
	import mx.events.DataGridEvent;

	public class TriggerEventHelper {
		public function TriggerEventHelper() {
		}
		
		public static function addEvent_clickHandler(event:MouseEvent, eventGrid:DataGrid, type:String):void {
			var triggerEvent:TriggerEvent = new TriggerEvent();
			if(type == 'flow') {
				triggerEvent.eventType = "before-start-proc";
				triggerEvent.eventTypeName = DataHolder.getTriggerEventTypeName(triggerEvent.eventType);
				Flow.processDefine.triggerEvents.addItem(triggerEvent);
				eventGrid.dataProvider = Flow.processDefine.triggerEvents;
			} else {
				triggerEvent.eventType = "before-start-act";
				triggerEvent.eventTypeName = DataHolder.getTriggerEventTypeName(triggerEvent.eventType);
				
				if(type == "manual") {
					var activity1:ManualActivity = Flow.rcAct.activity as ManualActivity;
					activity1.triggerEvents.addItem(triggerEvent);
					eventGrid.dataProvider = activity1.triggerEvents;
				} else if(type == "webservice") { 
					var activity2:WebServiceActivity = Flow.rcAct.activity as WebServiceActivity;
					activity2.triggerEvents.addItem(triggerEvent);
					eventGrid.dataProvider = activity2.triggerEvents;
				} else if(type == "toolApp") {
					var activity3:ToolAppActivity = Flow.rcAct.activity as ToolAppActivity;
					activity3.triggerEvents.addItem(triggerEvent);
					eventGrid.dataProvider = activity3.triggerEvents;
				} else if(type == "subProcess") {
					var activity4:SubProcessActivity = Flow.rcAct.activity as SubProcessActivity;
					activity4.triggerEvents.addItem(triggerEvent);
					eventGrid.dataProvider = activity4.triggerEvents;
				}
			}
		}
		
		public static function removeEvent_clickHandler(event:MouseEvent, eventGrid:DataGrid, type:String):void {
			if(type == 'flow') {
				if(eventGrid.selectedItem != null) {
					var index:int = Flow.processDefine.triggerEvents.getItemIndex(eventGrid.selectedItem);
					Flow.processDefine.triggerEvents.removeItemAt(index);
				}
			} else {
				if(eventGrid.selectedItem != null) {
					var index1:int = -1;
					if(type == "manual") {
						var activity1:ManualActivity = Flow.rcAct.activity as ManualActivity;
						index1 = activity1.triggerEvents.getItemIndex(eventGrid.selectedItem)
						activity1.triggerEvents.removeItemAt(index1);
					} else if(type == "webservice") {
						var activity2:WebServiceActivity = Flow.rcAct.activity as WebServiceActivity;
						index1 = activity2.triggerEvents.getItemIndex(eventGrid.selectedItem)
						activity2.triggerEvents.removeItemAt(index1);
					} else if(type == "toolApp") {
						var activity3:ToolAppActivity = Flow.rcAct.activity as ToolAppActivity;
						index1 = activity3.triggerEvents.getItemIndex(eventGrid.selectedItem)
						activity3.triggerEvents.removeItemAt(index1);
					} else if(type == "subProcess") {
						var activity4:SubProcessActivity = Flow.rcAct.activity as SubProcessActivity;
						index1 = activity4.triggerEvents.getItemIndex(eventGrid.selectedItem)
						activity4.triggerEvents.removeItemAt(index1);
					}
				}
			}
		}
		
		public static function eventGrid_itemEditEndHandler(event:DataGridEvent):void {
			var dataField:String = event.dataField;
		}
	}
}