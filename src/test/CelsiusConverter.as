package test
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	import myLib.controls.Button;
	
	import org.aswing.AssetPane;
	import org.aswing.GridLayout;
	import org.aswing.Insets;
	import org.aswing.JButton;
	import org.aswing.JFrame;
	import org.aswing.JLabel;
	import org.aswing.JPanel;
	import org.aswing.JTextField;
	import org.aswing.JWindow;
	import org.aswing.border.EmptyBorder;
	import org.aswing.geom.IntDimension;
	
	public class CelsiusConverter extends Sprite
	{
		private static var FAHRENHEIT : String = "fahrenheit";
		private var fahrenheitLabel : JLabel;
		private var button : JButton;
		private var inputTxt : JTextField;
		
		public function CelsiusConverter(){
			super();
			//createUI();
			var button:Button = new Button();
			button.text = "dsff";
			addChild(button);
				
		}
		
		private function createUI() : void{
			var frame : JFrame = new JFrame( this, "Convert Celsius to Fahrenheit" );
			frame.getContentPane().append( createCenterPane() );
			frame.setSize(new IntDimension( 200, 120 ) );
			frame.show();
		}
		
		private function createCenterPane() : JPanel{
			var pane : JPanel = new JPanel(new GridLayout(2,2,0,8));
			inputTxt = new JTextField("");
			inputTxt.setMaxChars(5);
			inputTxt.setRestrict("0-9");
			var celsiusLabel : JLabel = new JLabel("celsius");
			fahrenheitLabel = new JLabel(FAHRENHEIT);
			button = new JButton("Convert");
			pane.append(inputTxt);
			pane.append(celsiusLabel);
			pane.append(button);
			pane.append(fahrenheitLabel);
			pane.setBorder(new EmptyBorder(null, new Insets(10,2,10,2)));
			initHandlers();
			return pane;
		}
		
		private function initHandlers() : void{
			button.addActionListener( __pressButton );
			inputTxt.addActionListener(__pressButton);
		}
		
		private function __pressButton( e : Event ) : void{			
			calcTemp();
		}
		
		private function calcTemp() : void{
			var inputTemp : Number = Number(inputTxt.getText());
			if(!isNaN(inputTemp)){
				fahrenheitLabel.setText((inputTemp* 1.8 + 32)+" "+FAHRENHEIT);
				fahrenheitLabel.revalidate();
			}
		}
	}
}