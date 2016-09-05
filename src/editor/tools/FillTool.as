package editor.tools
{
	import editor.core.MDConfig;
	import editor.events.FillEvent;
	import editor.vos.Component;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import w11k.flash.AngularJSAdapter;
	
	[Event(name="complete", type="flash.events.Event")]
	
	public final class FillTool extends EventDispatcher
	{
		public function FillTool(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		
		public function fillComponent($componentId:String, $componentCode:String):void
		{
			AngularJSAdapter.getInstance().call("fillComponent(component)", {"componentId":$componentId, "componentCode":$componentCode});
		}
		
		public function fillComplete(componentId:String, hasCotent:Boolean):void
		{
			dispatchEvent(new FillEvent(FillEvent.COMPLETE, componentId, hasCotent));
		}
		
		private function findComponentById($id:uint):Component
		{
			return config.editingSheet 
				? config.editingSheet.componentsMap.componentMap[$id] : null;
		}
		
		private var config:MDConfig = MDConfig.instance;
	}
}