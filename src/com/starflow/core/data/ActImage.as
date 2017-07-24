package com.starflow.core.data {
	public class ActImage {
		[Bindable]
		public var label:String;
		[Bindable]
		public var type:String;
		[Bindable]
		public var imageFile:String;
		public function ActImage(label:String, type:String, imageFile:String) {
			this.label = label;
			this.type = type;
			this.imageFile = imageFile;
		}
	}
}