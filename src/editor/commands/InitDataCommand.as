package editor.commands
{
	
	/**
	 * 
	 * 初始化元素类型。
	 * 
	 */
	
	
	import cn.mvc.utils.ArrayUtil;
	import cn.mvc.utils.IDUtil;
	import cn.mvc.utils.ObjectUtil;
	
	import editor.core.ed;
	import editor.utils.VOUtil;
	import editor.views.Debugger;
	import editor.vos.*;
	
	
	public final class InitDataCommand extends _InternalCommand
	{
		
		/**
		 * 
		 * 构造函数。
		 * 
		 */
		
		public function InitDataCommand()
		{
			super();
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		override protected function excuteCommand():void
		{
			data = provider.raw["layout"];
			
			if (data is String) data = ObjectUtil.convert(data, Object);
			
			if (data)
			{
				//总节目版面集合
				initLayout();
				//初始化元素类别
				initComponentTypes();
				//广告版面
				initAD(data.ad);
				//普通版面
				initPages(data.pages, layout);
				//设定首页，初始化所有组件至页面的链接
				initOthers();
			}
		}
		
		
		/**
		 * @private
		 */
		private function initLayout():void
		{
			if (data.id == undefined || data.id == "" || data.id == "0")
			{
				data["$new"] = true;
				data.id = IDUtil.generateID("program");
			}
			provider.program = layout = new PLayout(data);
		}
		
		/**
		 * @private
		 */
		private function initComponentTypes():void
		{
			var componentTypes:Object = provider.raw["componentTypes"];
			if (componentTypes && componentTypes.length)
			{
				var l:uint = componentTypes.length;
				for (var i:uint = 0; i < l; i++)
				{
					var componentType:ComponentType = new ComponentType(componentTypes[i]);
					ArrayUtil.push(layout.componentTypesArr, componentType);
					layout.componentTypesMap[componentType.id] = componentType;
				}
				layout.componentTypesArr.sortOn("order", Array.NUMERIC);
			}
		}
		
		/**
		 * @private
		 */
		private function initAD($ad:Object):void
		{
			$ad = ($ad is Array && $ad.length) ? $ad[0] : $ad;
			if ($ad)
			{
				var ad:AD = new AD($ad);
				ad.label = ad.label || "广告";
				initComponents(ad, $ad.components);
			}
			else
			{
				ad = VOUtil.createAD(0, 0, layout.defaultWidth, layout.defaultHeight);
			}
			
			layout.ad = ad;
			layout.sheets[ad.id] = ad;
		}
		
		/**
		 * @private
		 */
		private function initPages($data:Object, $parent:* = null):void
		{
			if ($data)
			{
				if ($data is Array)
				{
					$data.sortOn("order", Array.NUMERIC);
					if ($data.length)
					{
						for each (var item:Object in $data) initPages(item, $parent);
						
						if ($parent == layout) 
							layout.ed::arrangeOrder();
						else
							$parent.ed::arrangePageOrder();
					}
				}
				else
				{
					var page:Page = new Page($data);
					
					if ($parent == layout)
						page.layoutID = provider.layoutID;
					else
						page.parentID = $parent.id;
					
					layout.addPage(page, $parent as Page);
					
					initComponents(page, $data.components);
					initPages($data.pages, page);
				}
			}
		}
		
		/**
		 * @private
		 */
		private function initComponents($sheet:Sheet, $components:Object):void
		{
			if ($components && $components.length)
			{
				var l:uint = $components.length;
				
				for (var i:uint = 0; i < l; i++)
				{
					var component:Component = new Component($components[i]);
					
					component.componentType = layout.componentTypesMap[component.componentTypeID];
					component.sheetID = $sheet.id;
					layout.addComponent($sheet, component);
				}
				
				//组件排序
				$sheet.ed::arrangeComponentsOrder();
			}
		}
		
		/**
		 * @private
		 */
		private function initOthers():void
		{
			if(!layout.home)
			{
				if (layout.children.length)
				{
					for (var i:int; i < layout.children.length; i++)
					{
						if (layout.children[i].home)
						{
							layout.home = layout.children[i];
							layout.home.home = true;
							break;
						}

					}
				}
			}
			
			for each (var page:Page in layout.pages)
			{
				for each (var component:Component in page.componentsMap)
				{
					if (component.linkID)
						component.link = layout.pages[component.linkID];
				}
			}
		}
		
		
		/**
		 * @private
		 */
		private var layout:PLayout;
		
		/**
		 * @private
		 */
		private var data:Object;
		
	}
}