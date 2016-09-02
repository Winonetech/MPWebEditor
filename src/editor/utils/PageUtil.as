package editor.utils
{
	import cn.mvc.core.NoInstance;
	
	import editor.vos.Page;
	
	import mx.controls.Alert;
	
	public class PageUtil extends NoInstance
	{
		/**
		 * 
		 * 判定$selected是否允许添加到$container中。
		 * 
		 */
		public static function isAllowAdd($selected:Page, $container:Page):Boolean
		{
			var result:Boolean;
			var tempS:Page;
			var tempC:Page;
			if ($selected)
			{
				if ($container)
				{
					tempS = $selected;
					tempC = $container.parent;
					while (tempS != tempC)
					{
						if (tempC == null)
						{
							result = true;
							break;
						}
						tempC = tempC.parent;
					}
				}
				else
				{
					result = true;
				}
			}
			if (!result) Alert.show("“" + $container.label + "” 页面是" + " “" + $selected.label + "” 页面的子级，不能调换！");
			return result;
		}
	}
}