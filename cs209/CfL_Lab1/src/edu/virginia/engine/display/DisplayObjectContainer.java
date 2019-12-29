package edu.virginia.engine.display;

import javax.imageio.ImageIO;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;

/**
 * A very basic display object for a java based gaming engine
 * 
 * */
public class DisplayObjectContainer extends DisplayObject {

	/* A list of DisplayObject objects that are the children of this container */
	private ArrayList<DisplayObject> children;

	/**
	 * Constructors: can pass in the id OR the id and image's file path and
	 * position OR the id and a buffered image and position
	 */
	public DisplayObjectContainer(String id) {
		super(id);
		children = new ArrayList<DisplayObject>();
	}

	public DisplayObjectContainer(String id, String fileName) {
		super(id, fileName);
		children = new ArrayList<DisplayObject>();
	}

	/* Returns the ArrayList of children */
	public ArrayList<DisplayObject> getChildren() { return children; }

	/* Add a child to the end of the ArrayList */
	public void addChild(DisplayObject child){
		child.setParent(this);
		children.add(child);
	}

	/* Add a child at index i */
	public void addChildAtIndex(DisplayObject child, int i){
		child.setParent(this);
		children.add(i, child);
	}

	/* Remove child with a specific id */
	public void removeChild(String id){
		for(DisplayObject child : children){
			if(child.getId() == id){
				child.setParent(null);
				children.remove(child);
				break;
			}
		}
	}

	/* Remove child at index i */
	public void removeByIndex(int i){
		children.get(i).setParent(null);
		children.remove(i);
	}

	/* Remove all the children from the ArrayList */
	public void removeAll(){
		for(DisplayObject child:children){
			child.setParent(null);
		}
		children = new ArrayList<DisplayObject>();
	}

	/* Returns true if child is in the ArrayList */
	public Boolean contains(DisplayObject child){
		return children.contains(child);
	}

	@Override
	public void draw(Graphics g) {
		super.draw(g);
		Graphics2D g2d = (Graphics2D) g;
		super.applyTransformations(g2d);
		for (DisplayObject child :children){ //Draw each of my children
			child.draw(g);
		}
		super.reverseTransformations(g2d);
	}

}
