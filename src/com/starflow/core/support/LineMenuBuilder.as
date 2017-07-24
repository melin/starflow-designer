package com.starflow.core.support {
	import com.starflow.components.win.TransitionWin;
	import com.starflow.line.LinkLine;
	
	import flash.events.MouseEvent;
	
	import mx.controls.Menu;
	import mx.events.MenuEvent;
	import com.starflow.core.util.Flow;
	import com.starflow.core.util.FlowUtil;

	public class LineMenuBuilder {
		private static var menuData:Array = [  
			{label: "连线属性", type: "normal", id: 'config'},
			{label: "删除连线", type: "normal", id: 'delete'}   
		];
		private var menu:Menu;
		private static var instance:LineMenuBuilder;
		
		public function LineMenuBuilder() {
			menu = Menu.createMenu(Flow.flowDesignerArea, menuData, false);
			menu.width=100;
			menu.addEventListener(MenuEvent.ITEM_CLICK, menuItemClick);
		}
		
		private function menuItemClick(event:MenuEvent):void {
			if(event.item.id == 'delete')
				this.deleteLinkRightClick(event);
			else if(event.item.id == 'config')
				TransitionWin.show();
		}
		
		public static function getInstance():LineMenuBuilder {
			if(instance == null)
				instance = new LineMenuBuilder();
			
			return instance;
		}
		
		/**
		 * 右键删除连线
		 * 
		 */
		private function deleteLinkRightClick(event:MenuEvent):void {
			Flow.processDefine.lineMap.remove(Flow.rcLine.id);
			Flow.flowDesignerArea.removeElement(Flow.rcLine.label);
			Flow.flowDesignerArea.removeElement(Flow.rcLine);
			
			FlowUtil.deleteLineMovePoint();
		}
		
		public function rightClickHandler(event:MouseEvent):void {
			if(Flow.enableRightClick) {
				menu.hide();
				Flow.rcLine = event.target as LinkLine;
				menu.show(event.stageX, event.stageY);
			}
		}
	}
}