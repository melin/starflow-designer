package com.starflow.core.support {
	import flash.display.Sprite;
	import flash.events.*;
	import flash.text.TextField;
	
	import mx.events.*;
	import mx.preloaders.DownloadProgressBar;

	public class FlowDownloadProgressBar extends DownloadProgressBar {
		private var progressBar:Sprite;
		private var myLabel:TextField;
		private var proBar:ProBar;
		public function FlowDownloadProgressBar() {
			super(); 
		}
		
		override public function set preloader(s:Sprite):void {
			s.addEventListener(ProgressEvent.PROGRESS,inProgress);
			s.addEventListener(Event.COMPLETE,complete);
			s.addEventListener(FlexEvent.INIT_COMPLETE,initComplete);
			s.addEventListener(FlexEvent.INIT_PROGRESS,initProgress);
		}
		
		private function inProgress(e:ProgressEvent):void {//进度条显示的百分数方法
			var barWidth:Number = e.bytesLoaded/e.bytesTotal*100;        
			if(proBar==null){
				proBar=new ProBar();
				proBar.x=(this.stage.stageWidth-this.width)/2-40;
				proBar.y=(this.stage.stageHeight-this.height)/2-18;
				this.addChild(proBar);
				
				myLabel=new TextField();
				myLabel.x=(this.stage.stageWidth-this.width)/2+40;
				myLabel.y=(this.stage.stageHeight-this.height)/2;
				myLabel.textColor=0x8579E9;
				this.addChild(myLabel);
				
			}
			proBar.setProBar(int(barWidth));
			myLabel.text="已经加载："+int(barWidth)+" %";
		}
		
		private function complete(e:Event):void {
			myLabel.text="下载完毕";
			trace("下载完毕");
		}
		private function initComplete(e:FlexEvent):void {
			myLabel.text="初始化完毕"//初始完后要派发 Complete 事件，不然不会进入第二帧
			dispatchEvent(new Event(Event.COMPLETE));
		}
		private function initProgress(e:FlexEvent):void {//进度条开始加载的方法
			myLabel.text="初始化...";
		}
	}
}