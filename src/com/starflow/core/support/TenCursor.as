package com.starflow.core.support {
	import flash.display.Sprite;

	public class TenCursor extends Sprite {
		//线条颜色
		private var lineColor:uint=0x000000;
		
		public function TenCursor() {
			this.graphics.lineStyle(1, lineColor);
			this.graphics.moveTo(0, 10);
			this.graphics.lineTo(20, 10);
			
			this.graphics.moveTo(10, 0);
			this.graphics.lineTo(10, 20);
			super();
		}
	}
}