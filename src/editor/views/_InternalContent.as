package editor.views
{
	
	/**
	 * 
	 * 
	 * 
	 */
	
	
	import flash.display.DisplayObject;
	
	
	public class _InternalContent extends _InternalView
	{
		
		/**
		 * 
		 * 构造函数。
		 * 
		 */
		
		public function _InternalContent()
		{
			super();
		}
		
		
		/**
		 * 
		 * 清除辅助线。
		 * @param $state:String 所需清除的辅助线位置。默认为"all"即全部删除。
		 * 
		 */
		
		public function cleanLine($state:String = "all"):void
		{
			ruleContainer.cleanLine($state);
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
			ruleContainer.showLine($currentComponent, $forbid);
		}
		
		
		protected function isChanged($dragging:*, $str:String):Boolean
		{
			return $dragging[$str].x != $dragging.x         ||
				   $dragging[$str].y != $dragging.y         ||
				   $dragging[$str].width != $dragging.width ||
				   $dragging[$str].height != $dragging.height;	
		}
		
		/**
		 * @private
		 */
		protected var ruleContainer:RuleDisplay = new RuleDisplay;
		
	}
}