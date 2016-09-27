package editor.commands
{
	
	/**
	 * 
	 * 修改组件。
	 * 
	 */
	
	
	import cn.mvc.utils.RegexpUtil;
	
	import editor.consts.URLConsts;
	import editor.views.Debugger;
	import editor.vos.Component;
	
	
	public final class EdtComponentCommand extends _InternalCommCommand
	{
		
		/**
		 * 
		 * 构造函数。
		 * 
		 * @param $component:Component 要修改的组件。
		 * @param $scope:Object 要修改的组件属性集合，格式为：<br>
		 * {<br>
		 * &nbsp;&nbsp;x:100,<br>
		 * &nbsp;&nbsp;y:100,<br>
		 * &nbsp;&nbsp;width:100,<br>
		 * &nbsp;&nbsp;height:100,<br>
		 * &nbsp;&nbsp;order:2,<br>
		 * &nbsp;&nbsp;label:"组件1"<br>
		 * 
		 */
		
		public function EdtComponentCommand($component:Component, $scope:Object)
		{
			super();
			
			item  = $component;
			scope = $scope;
			
			url = RegexpUtil.replaceTag(URLConsts.URL_COMPONENT_AMD, provider);
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		override protected function excuteCommand():void
		{
			updatable = false;
			
			for (var key:String in scope)
			{
				try {
					if(!updatable && item[key]!= scope[key]) updatable = true;
					item[key] = scope[key];
				} catch(e:Error) {trace(e.getStackTrace())}
			}
			
			if (updatable)
			{
				var data:Object = JSON.parse(item.toJSON());
				
				data.label = item.label;
				
				data.componentTypeCode = item.componentTypeCode;
				
				communicate(JSON.stringify(data));
			}
			else
			{
				commandEnd();
			}
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		override protected function update($result:Object = null):void
		{
			if ($result is String) $result = JSON.parse($result as String);
			if ($result.result == "success")
			{
				//update view
				if (!config.isLayoutOpened)
					vars.canvas.updateComponent(item);
			}
			else
			{
				Debugger.log("添加页面数据出错，此原因可能是服务端问题，请联系服务端管理员！");
			}
		}
		
		
		/**
		 * @private
		 */
		private var updatable:Boolean;
		
		/**
		 * @private
		 */
		private var item:Component;
		
		/**
		 * @private
		 */
		private var scope:Object;
		
	}
}