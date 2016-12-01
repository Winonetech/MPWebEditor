package editor.utils
{
	import cn.mvc.core.NoInstance;
	
	import editor.core.MDProvider;
	import editor.core.MDVars;
	import editor.views.Debugger;
	import editor.views.tabs.TitleBar;
	import editor.views.tabs.TitleTab;
	import editor.vos.Sheet;
	
	import mx.collections.ArrayCollection;
	
	import spark.components.HGroup;
	
	public final class TabUtil extends NoInstance
	{
		
		
		/**
		 * 
		 * 将Sheet类型转为其对应的TitleTab（如果存在）
		 * 
		 */
		public static function sheet2Tab($sheet:Sheet):TitleTab
		{
			var temp:TitleTab;
			for (var i:int = 1; i < HG.numElements; i++)
			{
				temp = HG.getElementAt(i) as TitleTab;
				if ($sheet.id == idObj[temp.uid])
				{
					return temp; 
				}
			}
			
			for (var j:int; j < dataArrs.length; j++)
			{
				temp = dataArrs[j]["tab"];
				if ($sheet.id == idObj[temp.uid])
				{
					return temp;
				}
			}
			return null;
		}
		
		
		/**
		 * 
		 * 将TitleTab类型转为其对应的Sheet（如果存在）
		 * 
		 */
		public static function tab2Sheet($tab:TitleTab):Sheet
		{
			return $tab ? MDProvider.instance.program.sheets[idObj[$tab.uid]] : null;
		}
		
		/**
		 * 
		 * 在titleBar上添加一个TitleTab
		 * 如已存在则视为选中之
		 * 
		 */
		public static function addTitle(sheet:Sheet):void
		{
			if (repeatById(sheet.id))
			{
				var title:TitleTab = new TitleTab;
				var temp:TitleTab = HG.addElement(title) as TitleTab;
				idObj[temp.uid] = sheet.id;
			}
			titleBar.selected = TabUtil.sheet2Tab(sheet);
		}
		
		
		/**
		 * 
		 * 根据id值来匹配该Sheet是否有对应的TitleTab
		 * 
		 */
		public static function repeatById($id:String):Boolean
		{
			for each (var id:String in idObj)
			if (id == $id) return false;
			return true;
		}
		
		/**
		 * 
		 * 根据TitleTab来匹配其是否存在于comboBox内
		 * 
		 */
		public static function repeatByTab($tab:TitleTab):Boolean
		{
			for each (var tab:Object in dataArrs)
			if (tab["tab"] == $tab) return false;
			return true;	
		}
		
		/**
		 * @private
		 */
		private static function get HG():HGroup
		{
			return titleBar.HG;
		}
		
		/**
		 * @private
		 */
		private static function get dataArrs():ArrayCollection
		{
			return titleBar.dataArrs;
		}
		
		/**
		 * @private
		 */
		private static function get idObj():Object
		{
			return titleBar.idObj;
		}
		
		/**
		 * @private
		 */
		private static var titleBar:TitleBar = MDVars.instance.titleBar;
		
	}
}