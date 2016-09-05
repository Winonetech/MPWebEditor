package editor.commands
{
	import cn.mvc.collections.Map;
	
	import editor.events.FillEvent;
	import editor.views.Debugger;
	import editor.vos.Component;
	
	import flash.events.Event;
	
	import w11k.flash.AngularJSAdapter;

	public final class FillContent extends _InternalCommand
	{
		public function FillContent($componentId:String, $componentCode:String)
		{
			super();
			componentCode = $componentCode;
			componentId = $componentId;
		}
		
		override public function execute():void
		{
			commandStart();
			excuteCommand();
		}
		
		/**
		 * @inheritDoc
		 */
		
		override protected function excuteCommand():void
		{
			var complete:Function = function(e:FillEvent):void
			{
				vars.fillTool.removeEventListener(Event.COMPLETE, complete);
				
				findComponentById(e.componentId).hasContent = e.hasContent;
				
				commandEnd();
			};
			vars.fillTool.addEventListener(Event.COMPLETE, complete);
			vars.fillTool.fillComponent(componentId, componentCode);
		}
		
		private function findComponentById($id:String):Component
		{
			return config.editingSheet 
				? config.editingSheet.componentsMap.componentMap[$id] : null;
		}
		
		private var componentCode:String;
		private var componentId:String;
	}
}