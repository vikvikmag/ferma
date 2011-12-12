package view.windows.events
{
	import flash.events.Event;

	public class WindowEvent extends Event
	{
		public static const CLICK_BUTTON:String = "clickButton";
		
		private var _code:String;
		
		public function WindowEvent(type:String, code:String)
		{
			super(type, false, false);
			_code = code;
		}
		
		override public function clone():Event
		{
			return new WindowEvent(type, code);
		}
		
		public function get code():String
		{
			return _code;
		}
	}
}