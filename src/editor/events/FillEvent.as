package editor.events
{
	import flash.events.Event;
	
	public final class FillEvent extends Event
	{
		public function FillEvent($type:String, $componentId:String, $hasContent:Boolean, $bubbles:Boolean=false, $cancelable:Boolean=false)
		{
			super($type, $bubbles, $cancelable);
			
			componentId = $componentId;
			hasContent = $hasContent;
		}
		
		public var componentId:String;
		
		public var hasContent:Boolean;
		
		public static const COMPLETE:String = "complete";
		
	}
}