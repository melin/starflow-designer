package com.starflow.itemRenderer {
	import flash.display.BitmapData;
	import flash.display.Graphics;
	
	import mx.collections.ICollectionView;
	import mx.collections.IList;
	import mx.controls.Tree;
	import mx.controls.treeClasses.ITreeDataDescriptor;
	import mx.controls.treeClasses.TreeItemRenderer;
	
	
	/**
	 * Alpha value for the Tree lines.
	 * @default 1
	 */
	[Style(name="lineAlpha", type="Number", format="Length", inherit="no")]
	
	/**
	 * Color of the Tree lines.
	 * @default 0x808080
	 */
	[Style(name="lineColor", type="uint", format="Color", inherit="no")]
	
	/**
	 * Thickness value for the Tree lines.
	 * @default 1
	 */
	[Style(name="lineThickness", type="Number", format="Length", inherit="no")]
	
	/**
	 * The Tree line style - none, dotted (default), or solid.
	 * @default "dotted"
	 */
	[Style(name="lineStyle", type="String", enumeration="dotted,solid,none", inherit="no")]
	
	/**
	 * Extends TreeItemRenderer to draw the dotted lines of the tree.
	 * It supports 3 line styles - dotted (default), solid, or none.  
	 * And the tree line color, alpha, and thickness values are configurable styles too. 
	 * 
	 * <pre>
	 *  &lt;ui:TreeItemLinesRenderer
	 *   <b>Styles</b>
	 *   lineAlpha="1"
	 *   lineColor="#808080"
	 *   lineThickness="1"
	 *   lineStyle="dotted"
	 * &gt;
	 *      ...
	 *      <i>child tags</i>
	 *      ...
	 *  &lt;/ui:TreeItemLinesRenderer&gt;
	 *  </pre>
	 * 
	 * @author Chris Callendar
	 * @date April 20th, 2009
	 */
	public class TreeItemLinesRenderer extends TreeItemRenderer
	{
		
		public static const DOTTED:String = "dotted";	// default
		public static const SOLID:String = "solid";
		public static const NONE:String = "none";
		
		public function TreeItemLinesRenderer() {
			super();
		}
		
		override public function set data(value:Object):void {
			super.data = value;
		}
		
		override protected function updateDisplayList(w:Number, h:Number):void {
			super.updateDisplayList(w, h);
			
			if ((w > 0) && (h > 0)) {
				// go up the hierarchy, drawing the vertical dotted lines for each node 
				var tree:Tree = (owner as Tree);
				var desc:ITreeDataDescriptor = tree.dataDescriptor;
				var currentNode:Object = data;
				var parentNode:Object = tree.getParentItem(currentNode);
				// the level is zero at this node, then increases as we go up the tree
				var levelsUp:int = 0;
				
				var lineStyle:String = getStyle("lineStyle");
				var lineColor:uint = getColorStyle("lineColor", 0x808080);
				var lineAlpha:Number = getNumberStyle("lineAlpha", 1);
				var lineThickness:Number = getNumberStyle("lineThickness", 1);
				var indentation:Number = tree.getStyle("indentation");
				
				// move the icon and label over to make room for the lines (less for root nodes)
				var shift:int = (parentNode == null ? 2 : 6) + lineThickness;
				if (icon) {
					icon.move(icon.x + shift, icon.y);
				}
				if (label) {
					label.move(label.x + shift, label.y);
				}
				
				var g:Graphics = graphics;
				g.clear();
				
				if ((lineStyle != NONE) && (lineAlpha > 0) && (lineThickness > 0)) {
					while (parentNode != null) {
						var children:ICollectionView = desc.getChildren(parentNode);
						if (children is IList) {
							var itemIndex:int = (children as IList).getItemIndex(currentNode);
							// if this node is the last child of the parent
							var isLast:Boolean = (itemIndex == (children.length - 1));
							drawLines(g, w, h, lineStyle, lineColor, lineAlpha, lineThickness, isLast, levelsUp, indentation);
							
							// go up to the parent, increasing the level
							levelsUp++;
							currentNode = parentNode;
							parentNode = tree.getParentItem(parentNode);
						} else {
							break;
						}
					}
				}
			}
		} 
		
		protected function drawLines(g:Graphics, w:Number, h:Number, lineStyle:String, lineColor:uint,
			lineAlpha:Number, lineThickness:Number, isLastItem:Boolean, levelsUp:int, indentation:Number):void {
			var midY:Number = Math.round(h / 2);
			var lineX:Number = 0;
			if (disclosureIcon) {
				lineX = disclosureIcon.x + (disclosureIcon.width / 2);
			} else if (icon) {
				lineX = icon.x - 8;
			} else if (label) {
				lineX = label.x - 8;
			}
			lineX = Math.floor(lineX) - int(lineThickness / 2);
			// adjust the x position based on the indentation
			if (levelsUp > 0) {
				if (!isNaN(indentation) && (indentation > 0)) {
					lineX = lineX - (levelsUp * indentation);
				} else {
					// Invalid indentation style value
					return;
				}
			}
			var lineY:Number = h;
			// stop the dotted line halfway on the last item
			if (isLastItem) {
				lineY = midY;
				// no lines need to be drawn for parents of the last item
				if (levelsUp > 0) {
					return;
				}
			}
			
			g.lineStyle(0, 0, 0);
			if (lineStyle == SOLID) {
				g.beginFill(lineColor, lineAlpha);
			} else {
				var verticalDottedLine:BitmapData = createDottedLine(lineColor, lineAlpha, lineThickness, true);
				g.beginBitmapFill(verticalDottedLine);
			}
			
			// draw the vertical line
			g.drawRect(lineX, 0, lineThickness, lineY);
			// end the fill and start it again otherwise the lines overlap and it create white squares
			g.endFill();
			
			// draw the horizontal line - only needed on this node (not on any parents)
			if (levelsUp == 0) {
				var startX:int = lineX + 1 + int(lineThickness / 2);
				var endX:int = startX + 11;	// 5 dots
				if (isLastItem) {
					startX = lineX;
				}
				var startY:Number = midY - int(lineThickness / 2);
				if (lineStyle == SOLID) {
					g.beginFill(lineColor, lineAlpha);
				} else {
					var horizontalDottedLine:BitmapData = createDottedLine(lineColor, lineAlpha, lineThickness, false);
					g.beginBitmapFill(horizontalDottedLine);
				}
				g.drawRect(startX, startY, endX - startX, lineThickness);	
				g.endFill();
			}
			
		}
		
		/**
		 * Creates a BitmapData that is used to renderer a dotted line.
		 * If the vertical parameter is true, then it creates a rectangle bitmap that is 
		 * twice as long as it is wide (lineThickness).  Otherwise it creates a rectangle
		 * that is twice as wide as it is long.
		 * The first half of the rectangle is filled with the line color (and alpha value),
		 * then second half is transparent.
		 */
		private function createDottedLine(lineColor:uint, lineAlpha:Number, lineThickness:Number, 
			vertical:Boolean = true):BitmapData {
			var w:Number = (vertical ? lineThickness : 2 * lineThickness);
			var h:Number = (vertical ? 2 * lineThickness : lineThickness);
			var color32:uint = combineColorAndAlpha(lineColor, lineAlpha);
			var dottedLine:BitmapData = new BitmapData(w, h, true, 0x00ffffff);
			// create a dotted bitmap
			for (var i:int = 0; i < lineThickness; i++) {
				for (var j:int = 0; j < lineThickness; j++) {
					dottedLine.setPixel32(i, j, color32);
				}
			}
			return dottedLine;
		}
		
		/**
		 * Combines the color value and the alpha value into a 32 bit uint like #AARRGGBB.
		 */
		private function combineColorAndAlpha(color:uint, alpha:Number):uint {
			// make sure the alpha is a valid number [0-1]
			if (isNaN(alpha)) {
				alpha = 1;
			} else {
				alpha = Math.max(0, Math.min(1, alpha));
			}
			
			// convert the [0-1] alpha value into [0-255]
			var alphaColor:Number = alpha * 255;
			// bitshift it to come before the color
			alphaColor = alphaColor << 24;
			// combine the two values: #AARRGGBB
			var combined:uint = alphaColor | color;
			return combined;  
		}
		
		private function getColorStyle(propName:String, defaultValue:uint):uint {
			var color:uint = defaultValue;
			if (propName != null) {
				var n:Number = getStyle(propName);
				if (!isNaN(n)) {
					color = uint(n);
				}
			}
			return color;
		}
		
		
		private function getNumberStyle(propName:String, defaultValue:Number):Number {
			var number:Number = defaultValue;
			if (propName != null) {
				var n:Number = getStyle(propName);
				if (!isNaN(n)) {
					number = n;
				}
			}
			return number;
		}
		
	}
}