package view.panel
{
	import controller.GameController;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import lui.LUIWidget;
	
	import model.book.PlantsBook;
	import model.items.Plant;
	
	import myLib.controls.Button;
	
	import view.renderers.PlantRenderer;

	public class PlantsPanel extends LUIWidget
	{
		private var _cloverRenderer:PlantRenderer = new PlantRenderer();
		private var _potatoRenderer:PlantRenderer = new PlantRenderer();
		private var _sunflowerRenderer:PlantRenderer = new PlantRenderer();
		
		private var _clover:Plant = PlantsBook.instance.getPlantByType("clover").clone();
		private var _potato:Plant = PlantsBook.instance.getPlantByType("potato").clone();
		private var _sunflower:Plant = PlantsBook.instance.getPlantByType("sunflower").clone();
		
		private var _container:Sprite = new Sprite();
		private var _countLoaders:int = 0;
		
		private var _tickBtn:Button;
		private var _version:TextField = new TextField();
		
		public function PlantsPanel()
		{
			_cloverRenderer.addEventListener(Event.COMPLETE, onResize);
			_potatoRenderer.addEventListener(Event.COMPLETE, onResize);
			_sunflowerRenderer.addEventListener(Event.COMPLETE, onResize);
			
			_cloverRenderer.addEventListener(MouseEvent.CLICK, onPlant);
			_potatoRenderer.addEventListener(MouseEvent.CLICK, onPlant);
			_sunflowerRenderer.addEventListener(MouseEvent.CLICK, onPlant);
			
			_cloverRenderer.buttonMode = true;
			_potatoRenderer.buttonMode = true;
			_sunflowerRenderer.buttonMode = true;
			
			_cloverRenderer.data = _clover;
			_potatoRenderer.data = _potato;
			_sunflowerRenderer.data = _sunflower;
			
			_version.text = GameController.VERSION;
			
			_container.addChild(_version);
			_container.addChild(_cloverRenderer);
			_container.addChild(_potatoRenderer);
			_container.addChild(_sunflowerRenderer);
			addChild(_container);
			
			_tickBtn = new Button(_container);
			_tickBtn.text = "Сделать ход";
			_tickBtn.addEventListener(MouseEvent.CLICK, onTickClick);
		}
		
		private function onTickClick(event:MouseEvent):void
		{
			GameController.instance.tickTime();
		}
		
		private function onPlant(event:MouseEvent):void
		{
			var renderer:PlantRenderer = event.currentTarget as PlantRenderer;
			var plant:Plant = renderer.data as Plant;
			GameController.instance.beginCropPlant(plant);
		}
		
		private function onResize(event:Event):void
		{
			_countLoaders++;
			if (_countLoaders == 3)
			{
				_cloverRenderer.removeEventListener(Event.COMPLETE, onResize);
				_potatoRenderer.removeEventListener(Event.COMPLETE, onResize);
				_sunflowerRenderer.removeEventListener(Event.COMPLETE, onResize);
				resize();
			}
		}
		
		override public function resize():void
		{
			_width = _cloverRenderer.width + _potatoRenderer.width + _sunflowerRenderer.width + 
				_tickBtn.width + 10;
			_height = Math.max(_cloverRenderer.height, _potatoRenderer.height, _sunflowerRenderer.height);
			
			_version.x = 10;
			_version.y = 10;
			
			_cloverRenderer.x = 0;
			_cloverRenderer.y = _height - _cloverRenderer.height;
			_potatoRenderer.x = _cloverRenderer.width;
			_potatoRenderer.y = _height - _potatoRenderer.height;
			_sunflowerRenderer.x = _potatoRenderer.x + _potatoRenderer.width;
			_sunflowerRenderer.y = _height - _sunflowerRenderer.height;
			
			_tickBtn.x = _sunflowerRenderer.x + _sunflowerRenderer.width + 5;
			_tickBtn.y = (_height - _tickBtn.height) / 2;
			
			graphics.clear();
			graphics.beginFill(0xffffff, 0.6);
			graphics.drawRoundRect(0, 0, _width, _height, 25, 25);
			graphics.endFill();
			
			dispatchEvent(new Event(Event.CHANGE));
		}
	}
}