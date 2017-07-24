package com.starflow.event.handle {
	import com.starflow.core.support.ActMenuBuilder;
	import com.starflow.core.util.Flow;
	import com.starflow.core.util.FlowUtil;
	
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;

	/**
	 * 键盘事件处理器
	 *  
	 * @author Administrator
	 * 
	 */	
	public class KeyboardHandler {
		private static var instance:KeyboardHandler = null;
		private var actImageDDHandler:FlowElementDDHandler = FlowElementDDHandler.getInstance();
		
		public static function getInstance():KeyboardHandler {
			if(instance == null)
				instance = new KeyboardHandler();
			return instance;
		}
		
		public function KeyboardHandler(){
			
		}
		
		public function keyDownHandler(event:KeyboardEvent):void {
			event.stopPropagation();
			if(event.keyCode == Keyboard.DELETE) {
				this.deleteKeyHandler(event);
			} else if(event.keyCode == Keyboard.UP) {
				if(Flow.focusAct != null) {
					moveActImage(Flow.focusAct.x, Flow.focusAct.y-1)
				}
			} else if(event.keyCode == Keyboard.DOWN) {
				if(Flow.focusAct != null) {
					moveActImage(Flow.focusAct.x, Flow.focusAct.y+1)
				}
			} else if(event.keyCode == Keyboard.LEFT) {
				if(Flow.focusAct != null) {
					moveActImage(Flow.focusAct.x-1, Flow.focusAct.y)
				}
			} else if(event.keyCode == Keyboard.RIGHT) {
				if(Flow.focusAct != null) {
					moveActImage(Flow.focusAct.x+1, Flow.focusAct.y)
				}
			}
		}
		
		/**
		 * 键盘上下左右键，移动鼠标。
		 *  
		 * @param x
		 * @param y
		 * 
		 */		
		private function moveActImage(x:int, y:int):void {
			Flow.focusAct.x = x;
			Flow.focusAct.y = y;
			actImageDDHandler.reDrawLines(Flow.focusAct);
		}
		
		private function deleteKeyHandler(event:KeyboardEvent):void {
			if(Flow.currentMovePoint != null)
				LineMovePointHandler.getInstance().deleteMovePointHandler(event);
			else {
				if(Flow.focusAct == null || Flow.focusAct.activity.type == 'start'
					|| Flow.focusAct.activity.type == 'finish')
					return;
				
				FlowUtil.deleteAct(Flow.focusAct);
			}
		}
	}
}