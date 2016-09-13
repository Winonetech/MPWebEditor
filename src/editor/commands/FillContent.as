package editor.commands
{
	import cn.mvc.collections.Map;
	
	import editor.views.Debugger;
	import editor.vos.Component;
	
	import flash.events.Event;
	
	import w11k.flash.AngularJSAdapter;

	public final class FillContent extends _InternalCommand
	{
		public function FillContent($componentId:String, $componentCode:String)
		{
			super();
			component["componentCode"] = $componentCode;
			component["componentId"] = $componentId;
		}
		
		override public function execute():void
		{
			commandStart();
			excuteCommand();
			commandEnd();
		}
		
		/**
		 * @inheritDoc
		 */
		
		override protected function excuteCommand():void
		{
			vars.fillTool.fillComponent(component);
		}
		
		private function findComponentById($id:String):Component
		{
			return config.editingSheet 
				? config.editingSheet.componentsMap.componentMap[$id] : null;
		}
		private var component:Object = {};
	}
}