package view.windows
{
	import flash.events.MouseEvent;
	
	import myLib.controls.Button;
	
	import view.windows.events.WindowEvent;

	public class PickUpWindow extends Window
	{
		public static const PICKUP_CLICK:String = "pickUpClick";
		
		private var _pickUpBtn:Button;
		private var _cancel:Button;
		
		public function PickUpWindow()
		{
			_modal = true;
			_pickUpBtn = new Button(this);
			_pickUpBtn.text = "Собрать урожай";
			_pickUpBtn.addEventListener(MouseEvent.CLICK, onPickUpClick);
			_cancel = new Button(this);
			_cancel.text = "Отмена";
			_cancel.addEventListener(MouseEvent.CLICK, onCancelClick);
			setSize(250, 50);
		}
		
		private function onPickUpClick(event:MouseEvent):void
		{
			dispatchEvent(new WindowEvent(WindowEvent.CLICK_BUTTON, PICKUP_CLICK));
			close();
		}
		
		private function onCancelClick(event:MouseEvent):void
		{
			close();
		}
		
		override public function resize():void
		{
			graphics.clear();
			graphics.beginFill(0x2222aa, 0.6);
			graphics.lineStyle(1, 0, 1);
			graphics.drawRoundRect(0, 0, _width, _height, 25, 25);
			graphics.endFill();
			
			_pickUpBtn.x = _width / 4 - _pickUpBtn.width / 2;
			_pickUpBtn.y = (_height - _pickUpBtn.height) / 2;
			_cancel.x = _width * 3 / 4 - _cancel.width / 2;
			_cancel.y = (_height - _cancel.height) / 2;
		}
	}
}