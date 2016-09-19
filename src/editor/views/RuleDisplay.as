package editor.views
{
	
	import cn.mvc.utils.ColorUtil;
	
	import editor.core.MDConfig;
	import editor.utils.CanvasUtil;
	
	import flash.display.DisplayObject;
	
	import mx.controls.HRule;
	import mx.controls.VRule;
	
	import spark.components.Group;
	
	
	public final class RuleDisplay extends Group
	{
		
		/**
		 * 
		 * 构造函数。
		 * 
		 */
		
		public function RuleDisplay()
		{
			super();
		}
		
		
		/**
		 * 
		 * 展示辅助线。
		 * @param $currentComponent:DisplayObject 需要被展示辅助线的组件
		 * @param $forbid:* 限制参数  : 当为String时，只允许获取该参数对应边的参数。<br>
		 *     当为一个Array时表示只允许right和bottom。其默认值为all表示无限制全部允许获取。<br>
		 *     可能的值为“left”, “right”, "bottom", "top", "all" 和 任意一个数组类型。
		 * 
		 */
		
		public function showLine($currentComponent:DisplayObject, $forbid:* = "all"):void
		{
			var obj:Object = CanvasUtil.showWhere($currentComponent, $forbid);
			controlLine(obj);
		}
		
		
		/**
		 * 
		 * 清除辅助线。
		 * @param $state:String 所需清除的辅助线位置。默认为"all"即全部删除。
		 * 
		 */
		
		public function cleanLine($state:String = "all"):void
		{
			switch($state)
			{
				case "all" : ;
				case "Hor":
				{
					if (containsElement(htrule))
						removeElement(htrule);
					if ($state != "all") break;
				}
				case "Ver":
				{
					if (containsElement(vlrule)) 
						removeElement(vlrule);
					if ($state != "all") break;
				}
			}
		}
		
		/**
		 * 
		 * @private
		 * 
		 */
		public function controlLine($data:Object):void
		{
			for (var state:String in $data)
			{
				var $rule:*;
				var lineColor:uint = 0x00FFFFFF - backgroundColor;
				if ($data[state] != null)
				{
					if (state == "Ver")
					{
						$rule = vlrule;
						$rule.x = $data[state];
						$rule.height = 2000;
						
					}
					else if (state == "Hor")
					{
						$rule = htrule;
						$rule.y = $data[state];
						$rule.width = 2000;
					}
					
					$rule.setStyle("strokeWidth", 2);
					$rule.setStyle("shadowColor", lineColor);
					$rule.setStyle("strokeColor", lineColor);
					addElement($rule);
				}
				else
				{
					cleanLine(state);
				}
			}
		}
		
		
		/**
		 * @private
		 */
		private function get backgroundColor():uint
		{
			return config.editingSheet ? ColorUtil.colorString2uint(config.editingSheet.backgroundColor) : 0xFFFFFF;
		}
		
		/**
		 * @private
		 */
		private function get config():MDConfig
		{
			return MDConfig.instance;
		}
		
		
		/**
		 * @private
		 */
		private var vlrule:VRule = new VRule;
		
		
		/**
		 * @private
		 */
		private var htrule:HRule = new HRule;
		
	}
}