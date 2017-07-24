package com.starflow.event.handle {
	import com.starflow.components.win.FlowWin;
	import com.starflow.core.support.ProcessDefineXMLBuilder;
	import com.starflow.core.support.ValidateProcessDefine;
	import com.starflow.core.util.Flow;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Utils3D;
	import flash.net.FileReference;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	import flash.utils.getQualifiedClassName;
	
	import mx.controls.Alert;
	import mx.controls.menuClasses.MenuBarItem;
	import mx.core.FlexGlobals;
	import mx.core.IUITextField;
	import mx.core.UITextField;
	import mx.events.MenuEvent;
	import mx.graphics.codec.JPEGEncoder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;

	public class ToolBarHandler {
		private static var file:FileReference = new FileReference();
		private static var processDefId:String = "";
   
		public function ToolBarHandler(){
			
		}
		
		public static function itemClickHandler(event:MouseEvent):void {
			try {
				var item:MenuBarItem = MenuBarItem(event.target);
			} catch(errObject:Error) {
				return;
			}
			var textField:UITextField = UITextField(item.getChildAt(1));
			var label:String = textField.text;
			if(label == "连线" || label == "拖动")
				linkLineMenuHandle(textField);
			else if(label == "属性")
				FlowWin.show();
			else if(label == "保存")
				save();
			else if(label == "截图")
				photoFlow();
			else if(label == "验证") {
				if(ValidateProcessDefine.validate()) {
					Alert.show("流程定义验证不正确");
				} else {
					Alert.show("流程定义验证正确");
				}
			} else if(label == "测试") {
				Alert.show(ProcessDefineXMLBuilder.createXML());
			}
		}
		
		private static function linkLineMenuHandle(textField:UITextField):void {
			if(Flow.isDD) {
				Flow.isDD = false;
				textField.text = '连线';
			} else {
				Flow.isDD = true;
				textField.text = '拖动';
			}
		}
		
		private static function photoFlow():void {
			var bitmapData:BitmapData = new BitmapData(Flow.flowDesignerArea.width, Flow.flowDesignerArea.height);   
			bitmapData.draw(Flow.flowDesignerArea, new Matrix());   
			var bitmap : Bitmap = new Bitmap(bitmapData);   
			var jpg:JPEGEncoder = new JPEGEncoder();   
			var ba:ByteArray = jpg.encode(bitmapData);   
			file.save(ba,"flow.jpg");    
		}
		
		private static function save():void {
			if(ValidateProcessDefine.validate()) {
				Alert.show("流程定义验证不正确，不能保存。");
				return;
			}
			
			var flashvars:Object = FlexGlobals.topLevelApplication.parameters;
			var httpService:HTTPService = new HTTPService();
			httpService.resultFormat = "text";
			httpService.method = "POST";
			httpService.url = flashvars.saveFlowUrl;
			httpService.addEventListener(ResultEvent.RESULT, function(event:ResultEvent):void {
				processDefId = event.result as String;
				Alert.show("保存成功");
			});
			httpService.addEventListener(FaultEvent.FAULT, function(event:FaultEvent):void {
				Alert.show("保存失败");
			});
			
			var params:URLVariables = new URLVariables(); 
			if(processDefId == "")
				params.processDefId = flashvars.processDefId;
			else
				params.processDefId = processDefId;
			params.processDefContent = ProcessDefineXMLBuilder.createXML();
			params.processDefName = Flow.processDefine.name;
			params.processCHName = Flow.processDefine.chname;
			params.versionSign = Flow.processDefine.version;
			params.limitTime = Flow.processDefine.limitTime;
			params.description = Flow.processDefine.description;
			
			httpService.send(params);
		}
	}
}