package com.starflow.core.support {
	import com.starflow.core.util.Flow;
	
	import flash.events.KeyboardEvent;
	
	import mx.managers.PopUpManager;
	
	import spark.components.Group;

	public class WindowManager {
		public function WindowManager() {
		}
		
		private static var _show:Boolean = false;
		
		public static function show(instance:Group):void {
			//if ( _show ) hide(instance);
			
			instance.setFocus();
			PopUpManager.addPopUp(instance, Flow.flowDesignerArea, true);
			PopUpManager.centerPopUp(instance);
			
			Flow.enableRightClick = false;
			_show = true;
		}
		
		public static function hide(instance:Group):void {
			//if ( !_show ) return;
			
			PopUpManager.removePopUp(instance);
			
			Flow.enableRightClick = true;
			_show = false;
		}
	}
}