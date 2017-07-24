package com.starflow.model {
	public class Transition {
		public var isDefault:Boolean = true;
		public var priority:int = 40;
		public var isSimpleExpression:Boolean = true;
		public var leftValue:String = "";
		public var compType:String = "EQ";
		public var rightValue:String = "";
		public var complexExpressionValue:String = "";
		public var from:String = "";
		public var to:String = "";
		
		public var description:String = "";
		public function Transition(){
		}
	}
}