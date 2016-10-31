package editor.commands
{
	
	/**
	 * 
	 * 初始化节目数据。
	 * 
	 */
	
	public final class InitProgramCommand extends _InternalCommand
	{
		
		/**
		 * 
		 * 构造函数。
		 * 
		 * @param $data:Object 传入一个初始化数据，格式为：<br>
		 * {<br>
		 * &nbsp;&nbsp;domain:"http://192.168.7.3:9000",<br>
		 * &nbsp;&nbsp;programId: 3,<br>
		 * &nbsp;&nbsp;layoutId: 1,<br>
		 * &nbsp;&nbsp;programName: "测试",<br>
		 * &nbsp;&nbsp;defaultWidth: "1920",<br>
		 * &nbsp;&nbsp;defaultHeight: "1080"<br>
		 * }
		 * 
		 */
		
		public function InitProgramCommand($data:Object)
		{
			super();
			
			data = $data;
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		override protected function excuteCommand():void
		{
			if (data is String) data = JSON.parse(data as String);
			
			provider.domain        = data.domain;
			provider.programID     = data.programId;
			provider.layoutID      = data.layoutId;
			provider.publishID     = data.publishId;
			provider.programName   = data.programName;
			provider.defaultWidth  = data.defaultWidth;
			provider.defaultHeight = data.defaultHeight;
			provider.userName      = data.userName;
			config.mode			   = data.mode;
		}
		
		
		/**
		 * @private
		 */
		private var data:Object;
		
	}
}