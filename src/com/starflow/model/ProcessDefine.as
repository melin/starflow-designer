package com.starflow.model {
	import it.sephiroth.utils.HashMap;
	
	import mx.collections.ArrayCollection;

	public class ProcessDefine {
		public var name:String = "";
		public var version:String = "1.1.1";
		public var chname:String = "";
		public var description:String = "";
		public var limitTime:String = "0";
		
		public var processStarterType:String = "all";
		public var processStarters:ArrayCollection = new ArrayCollection();
		
		//触发事件
		public var triggerEvents:ArrayCollection = new ArrayCollection();
		//扩展属性
		public var extendNodes:ArrayCollection = new ArrayCollection();
		//流程所有连线
		public var lineMap:HashMap = new HashMap();
		//流程所有环节
		public var actImageMap:HashMap = new HashMap();
		
		public function ProcessDefine(){
		}
		
		public function createXml():String {
			var xml:String = '	<ProcessProperty>\n' +
				'		<limitTime>' + limitTime + '</limitTime>\n' +
				'		<processStarterType>' + processStarterType + '</processStarterType>\n' +
				'		<description>' + description + '</description>\n' +
				'		<ProcessStarters>\n';
			
			var len:int = processStarters.length;
			for(var i:int=0; i<len; i++) {
				var p1:Participant = processStarters.getItemAt(i) as Participant;
				xml = xml +'			' + p1.createXml();
			}
			xml = xml +
				'		</ProcessStarters>\n'+
				'		<TriggerEvents>\n';
			
			len = triggerEvents.length;
			for(i=0; i<len; i++) {
				var te:TriggerEvent = triggerEvents.getItemAt(i) as TriggerEvent;
				xml = xml +'			' + te.createXml();
			}
			xml = xml +
				'		</TriggerEvents>\n'+
				'		<ExtendNodes>\n';
			
			len = extendNodes.length;
			for(i=0; i<len; i++) {
				var node:ExtendNode = extendNodes.getItemAt(i) as ExtendNode;
				xml = xml +'			' + node.createXml();
			}
			xml = xml +
				'		</ExtendNodes>\n'+
				'	</ProcessProperty>\n';
			
			return xml;
		}
		
	}
}