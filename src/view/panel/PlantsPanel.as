package view.panel
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import lui.LUIWidget;
	
	import model.book.PlantsBook;
	import model.items.Plant;
	
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
			
			_container.addChild(_cloverRenderer);
			_container.addChild(_potatoRenderer);
			_container.addChild(_sunflowerRenderer);
			addChild(_container);
		}
		
		private function onPlant(event:MouseEvent):void
		{
			var renderer:PlantRenderer = event.currentTarget as PlantRenderer;
			var plant:Plant = renderer.data as Plant;
			trace(plant.litName);
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
			_width = _cloverRenderer.width + _potatoRenderer.width + _sunflowerRenderer.width;
			_height = Math.max(_cloverRenderer.height, _potatoRenderer.height, _sunflowerRenderer.height);
			
			_cloverRenderer.x = 0;
			_cloverRenderer.y = _height - _cloverRenderer.height;
			_potatoRenderer.x = _cloverRenderer.width;
			_potatoRenderer.y = _height - _potatoRenderer.height;
			_sunflowerRenderer.x = _potatoRenderer.x + _potatoRenderer.width;
			_sunflowerRenderer.y = _height - _sunflowerRenderer.height;
			
			graphics.clear();
			graphics.beginFill(0xffffff, 0.6);
			graphics.drawRoundRect(0, 0, _width, _height, 25, 25);
			graphics.endFill();
			
			dispatchEvent(new Event(Event.CHANGE));
		}
	}
}