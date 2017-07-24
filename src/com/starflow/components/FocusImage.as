package com.starflow.components {
	import com.starflow.core.util.Flow;
	
	import flash.events.FocusEvent;
	
	import mx.controls.Image;
	import mx.managers.IFocusManagerComponent;

	public class FocusImage extends Image implements IFocusManagerComponent {
		public function FocusImage() {
			super();
			
			//==========================================================
			super.focusEnabled = true;
			super.tabEnabled = true
			super.mouseFocusEnabled = true;
			
			//==========================================================
			super.setStyle("focusThickness", 2);
		}
		
		override protected function focusInHandler(event :FocusEvent) :void {
			super.focusInHandler(event);
			
			if(super.focusManager != null) {
				super.focusManager.showFocus();
			}
			
			Flow.focusAct = event.target.parent as ActImage;
		}
		
		override protected function focusOutHandler(event :FocusEvent) :void {
			super.focusOutHandler(event);
			
			if(super.focusManager != null) {
				super.focusManager.hideFocus();
			}
			
			Flow.focusAct = null;
		}
	}
}