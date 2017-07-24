package com.starflow.core.support {
	import com.starflow.components.ActImage;
	import com.starflow.components.win.FinishActWin;
	import com.starflow.components.win.ManualActWin;
	import com.starflow.components.win.StartActWin;
	import com.starflow.components.win.SubFlowActWin;
	import com.starflow.components.win.ToolappActWin;
	import com.starflow.components.win.WebServiceActWin;
	import com.starflow.core.util.Flow;
	import com.starflow.core.util.FlowUtil;
	import com.starflow.line.LinkLine;
	
	import flash.events.MouseEvent;
	
	import it.sephiroth.utils.Entry;
	import it.sephiroth.utils.collections.iterators.Iterator;
	
	import mx.collections.ArrayList;
	import mx.controls.Menu;
	import mx.events.MenuEvent;

	public class ActMenuBuilder {
		private var menuData:Array = [  
			{label: "环节属性", type: "normal", id: 'config'},
			{label: "删除环节", type: "normal", id: 'delete'}   
		];
		
		private var menuDataExt:Array = [  
			{label: "环节属性", type: "normal", id: 'config'},
			{label: "删除环节", type: "normal", id: 'delete', enabled:false}   
		];  
		
		public var menu:Menu;
		private static var instance:ActMenuBuilder;
		
		public function ActMenuBuilder(){
			menu = Menu.createMenu(Flow.flowDesignerArea, menuData, false);
			menu.width=100;
			menu.addEventListener(MenuEvent.ITEM_CLICK, this.menuItemClick);
		}
		
		public static function getInstance():ActMenuBuilder {
			if(instance == null)
				instance = new ActMenuBuilder();
			
			return instance;
		}
		
		public function rightClickHandler(event:MouseEvent):void {
			if(Flow.enableRightClick) {
				Flow.rcAct = event.currentTarget as ActImage;
				if(Flow.rcAct.activity.type=="start" || Flow.rcAct.activity.type=="finish")
					menu.dataProvider = menuDataExt;
				else
					menu.dataProvider = menuData;
				menu.hide();
				menu.show(event.stageX, event.stageY);
			}
		}
		
		private function menuItemClick(event:MenuEvent):void {
			if(event.item.id == 'delete')
				this.deleteActRightClick(event);
			else if(event.item.id == 'config') {
				if(Flow.rcAct.activity.type == "start")
					StartActWin.show();
				else if(Flow.rcAct.activity.type == "finish")
					FinishActWin.show();
				else if(Flow.rcAct.activity.type == "manual")
					ManualActWin.show();
				else if(Flow.rcAct.activity.type == "toolApp")
					ToolappActWin.show();
				else if(Flow.rcAct.activity.type == "subProcess")
					SubFlowActWin.show();
				else if(Flow.rcAct.activity.type == "webservice")
					WebServiceActWin.show();
			}
		}
		
		/**
		 * 右键删除菜单，删除当前环节图元，同时删除与当前环节关联的图元。
		 * 
		 */
		private function deleteActRightClick(event:MenuEvent):void {
			if(Flow.rcAct == null)
				return;
			
			FlowUtil.deleteAct(Flow.rcAct);
		}
	}
}