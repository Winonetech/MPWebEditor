package editor.vos
{
	
	/**
	 * 
	 * 版面元素数据结构。
	 * 
	 */
	
	
	import cn.mvc.utils.ObjectUtil;
	import cn.mvc.utils.StringUtil;
	
	import editor.core.ed;
	
	
	
	[Bindable]
	public class Component extends _InternalVO
	{
		/**
		 * 
		 * 构造函数。
		 * 
		 */
		
		public function Component($data:Object = null, $name:String = "component")
		{
			super($data, $name);
		}
		
		/**
		 * @inheritDoc
		 */
		
		override public function toJSON():String
		{
			var temp:Object = ObjectUtil.clone(data);
			if (componentType) temp.componentTypeCode = componentType.code;
			return JSON.stringify(temp);
		}
		
		
		/**
		 * 
		 * 是否允许交互。
		 * 
		 */
		
		public function get interactable():Boolean
		{
			return getProperty("interactEnabled", Boolean);
		}
		
		/**
		 * @private
		 */
		public function set interactable($value:Boolean):void
		{
			setProperty("interactEnabled", $value);
		}
		
		
		/**
		 * 
		 * 名称。
		 * 
		 */
		
		public function get label():String
		{
			return getProperty("label");
		}
		
		/**
		 * @private
		 */
		public function set label($value:String):void
		{
			setProperty("label", $value);
		}
		
		
		/**
		 * 
		 * h。
		 * 
		 */
		
		public function get height():Number
		{
			var value:Number = getProperty("height", Number);
			value = Math.floor(value);
			return isNaN(value) ? 0 : value;
		}
		
		/**
		 * @private
		 */
		public function set height($value:Number):void
		{
			$value = int($value);
			setProperty("height", $value);
		}
		
		
		/**
		 * 
		 * w。
		 * 
		 */
		
		public function get width():Number
		{
			var value:Number = getProperty("width", Number);
			value = Math.floor(value);
			return isNaN(value) ? 0 : value;
		}
		
		/**
		 * @private
		 */
		public function set width($value:Number):void
		{
			$value = int($value);
			setProperty("width", $value);
		}
		
		
		/**
		 * 
		 * x。
		 * 
		 */
		
		public function get x():Number
		{
			var value:Number = getProperty("coordX", Number);
			value = int(value);
			return isNaN(value) ? 0 : value;
		}
		
		/**
		 * @private
		 */
		public function set x($value:Number):void
		{
			setProperty("coordX", int($value));
		}
		
		/**
		 * 
		 * y。
		 * 
		 */
		
		public function get y():Number
		{
			var value:Number = getProperty("coordY", Number);
			value = int(value);
			return isNaN(value) ? 0 : value;
		}
		
		/**
		 * @private
		 */
		public function set y($value:Number):void
		{
			setProperty("coordY", int($value));
		}
		
		
		/**
		 * 
		 * 顺序。
		 * 
		 */
		
		public function get order():uint
		{
			return getProperty("order", uint);
		}
		
		/**
		 * @private
		 */
		public function set order($value:uint):void
		{
			setProperty("order", $value);
		}
		
		
		/**
		 * 
		 * 链接至的页面数据结构。
		 * 
		 */
		
		public function get link():Page
		{
			return ed::link;
		}
		
		/**
		 * @private
		 */
		public function set link($value:Page):void
		{
			ed::link = $value;
			
			linkID = link ? link.id : null;
		}
		
		
		/**
		 * 
		 * 元素类比编码。
		 * 
		 */
		
		public function get componentTypeCode():String
		{
			return componentType ? componentType.code : null;
		}
		
		
		/**
		 * 
		 * 获取属性集合。
		 * 
		 */
		
		public function get property():Object
		{
			return getProperty("property", Object);
		}
		
		
		/**
		 * 
		 * 元素类别ID。
		 * 
		 */
		
		public function get componentTypeID():String
		{
			return getProperty("componentTypeId");
		}
		
		
		/**
		 * 
		 * 所属的页面ID。
		 * 
		 */
		
		public function get sheetID():String
		{
			return data && data.page ? data.page.id : null;
		}
		
		/**
		 * @private
		 */
		public function set sheetID($value:String):void
		{
			if (StringUtil.empty($value))
			{
				delete data["page"];
			}
			else
			{
				data["page"] = data["page"] || {};
				data["page"]["id"] = $value;
			}
		}
		
		
		/**
		 * 
		 * 链接至页面ID。
		 * 
		 */
		
		public function get linkID():String
		{
			return getProperty("linkId");
		}
		
		/**
		 * @private
		 */
		public function set linkID($value:String):void
		{
			setProperty("linkId", $value);
		}
		
		
		
		/**
		 * 
		 * 链接至页面ID。
		 * 
		 */
		
		public function get hasContent():Boolean
		{
			return getProperty("hasContent");
		}
		
		/**
		 * @private
		 */
		public function set hasContent($value:Boolean):void
		{
			setProperty("hasContent", $value);
		}
		
		
		/**
		 * 
		 * 是否被选中。
		 * 
		 */
		public var selected:Boolean;
		
		/**
		 * 
		 * 过渡效果。
		 * 可能的值："leftRight" 或 "upDown"
		 * 
		 */
		public function get transition():String 
		{
			return getProperty("transition");
		}
		
		public function set transition(value:String):void 
		{
			setProperty("transition", value);
		}
		
		/**
		 * 
		 * 元素类别引用。
		 * 
		 */
		
		public var componentType:ComponentType;
		
		private var value:int;
		/**
		 * @private
		 */
		ed var link:Page;
	}
}