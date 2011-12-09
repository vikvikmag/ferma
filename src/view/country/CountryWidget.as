package view.country
{
	import as3isolib.display.IsoSprite;
	import as3isolib.display.IsoView;
	import as3isolib.display.primitive.IsoBox;
	import as3isolib.display.scene.IsoGrid;
	import as3isolib.display.scene.IsoScene;
	import as3isolib.geom.Pt;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import lui.LUIWidget;
	
	import model.book.PlantsBook;
	import model.items.Plant;
	
	import view.renderers.CountryRenderer;
	import view.renderers.PlantRenderer;

	public class CountryWidget extends LUIWidget
	{
		private var CELL_SIZE:int = 50;
		
		private var _bg:CountryRenderer;
		private var _isoGrid:IsoGrid;
		private var _isoScene:IsoScene;
		private var _box:IsoBox;
		private var _isoView:IsoView;
		private var _container:Sprite = new Sprite();
		private var _cloverRenderer:PlantRenderer;
		
		public function CountryWidget()
		{
			addChild(_container);
					
			_bg = new CountryRenderer();
			_bg.addEventListener(Event.COMPLETE, onBgLoad);
			_container.addChild(_bg);
			
			//for grid
			_isoGrid = new IsoGrid()
			_isoGrid.showOrigin = true;
			_isoGrid.setGridSize(13,13,1);
			_isoGrid.cellSize = CELL_SIZE;
			
			_box = new IsoBox();
			_box.setSize(50,50,100);
			//_box.moveTo(100,0,0);
			
			//for scene
			_isoScene = new IsoScene();
			_isoScene.addChild(_isoGrid);
			_isoScene.addChild(_box);
			_isoScene.render();

			//for view
			_isoView = new IsoView();
			_isoView.addScene(_isoScene);
			
			_isoView.visible = false;
			_container.addChild(_isoView);
			
			_container.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			_container.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			_container.addEventListener(MouseEvent.ROLL_OUT, onMouseUp);
			
			_cloverRenderer = new PlantRenderer();
			_cloverRenderer.isNeedOffset = true;
			var plant:Plant = PlantsBook.instance.getPlantByType("sunflower").clone();
			plant.level = 5;
			_cloverRenderer.data = plant;
			_cloverRenderer.addEventListener(Event.COMPLETE, onUpdate);
		}
		
		private function onUpdate(event:Event):void
		{
			var iso:IsoSprite = new IsoSprite();
			_cloverRenderer.opaqueBackground = 0xff0000;
			iso.sprites = [_cloverRenderer];
			iso.setSize(50, 50, 83);
			iso.moveTo(10, 110, 0);
			
			var box:IsoBox = new IsoBox();
			box.setSize(50, 50, 50);
			box.moveTo(0, 100, 0);
			_isoScene.addChild(box);
			_isoScene.addChild(iso);
			_isoScene.render();
		}
		
		private function onMouseDown(event:MouseEvent):void
		{
			_container.startDrag();
		}
		
		private function onMouseUp(event:MouseEvent):void
		{
			_container.stopDrag();
			//trace(_isoView.c, _isoView.currentX, _isoView.currentY);
		}
		
		private function onBgLoad(event:Event):void
		{
			setSize(_bg.width, _bg.height);
			_isoView.setSize(_width, _height);
			_isoView.centerOnPt(new Pt(370, 330, 0));
			_isoView.visible = true;			
		}
	}
}