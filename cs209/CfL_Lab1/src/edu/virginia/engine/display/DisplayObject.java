package edu.virginia.engine.display;

import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.awt.Point;
import java.awt.AlphaComposite;
import java.awt.Shape;
import java.awt.geom.Area;
import java.awt.geom.AffineTransform;

import javax.imageio.ImageIO;

/**
 * A very basic display object for a java based gaming engine
 *
 * */
public class DisplayObject {

	/* All DisplayObject have a unique id */
	private String id;

	/* The image that is displayed by this object */
	private BufferedImage displayImage;

	/* Describes the x, y position where this object will be drawn */
	private Point position;

	/* The object rotates around this point */
	private Point pivotPoint;

	/* Defines the amount in degrees to rotate this object */
	private double rotation;

	/* Should be true iff this display object is meant to be drawn*/
	private boolean visibility;

	/* float which defines how transparent to draw this object*/
	private float alpha;

	private float oldAlpha;

	/* Double which scales the image up or down (1.0 is actual size)*/
	private double scaleX;

	private double scaleY;

	private DisplayObjectContainer parent;

	private int visibilityLag;

	private ArrayList<Shape> hitbox;

	private boolean hasPhysics;

	/**
	 * Constructors: can pass in the id OR the id and image's file path and
	 * position OR the id and a buffered image and position
	 */
	public DisplayObject(String id) {
		this.setId(id);
		this.setPosition(new Point(0, 0));
		this.setPivotPoint(new Point(0, 0));
		this.setRotation(0.0);
		this.setVisibility(true);
		this.setAlpha(1.0f);
		this.setOldAlpha(0.0f);
		this.setScaleX(1.0);
		this.setScaleY(1.0);
		this.parent = null;
		this.hitbox = new ArrayList<Shape>();
		this.hasPhysics = false;
	}

	public DisplayObject(String id, String fileName) {
		this.setId(id);
		this.setImage(fileName);
		this.setPosition(new Point(0, 0));
		this.setPivotPoint(new Point(0, 0));
		this.setRotation(0.0);
		this.setVisibility(true);
		this.setAlpha(1.0f);
		this.setOldAlpha(0.0f);
		this.setScaleX(1.0);
		this.setScaleY(1.0);
		this.parent = null;
		this.hitbox = new ArrayList<Shape>();
		this.hasPhysics = false;
	}

	public void setPhysics(boolean physics) {
		this.hasPhysics = physics;
	}

	public boolean getPhysics() {
		return hasPhysics;
	}

	public void setHitbox(ArrayList<Shape> hitbox) {
		this.hitbox = hitbox;
	}

	public ArrayList<Shape> getHitbox() {
		return hitbox;
	}

	public void addHitboxShape(Shape newShape){
		hitbox.add(newShape);
	}

	public Boolean collidesWith(DisplayObject other){
		ArrayList<Shape> otherHitbox = other.getHitbox();
		for(Shape shape : hitbox){
			for(Shape otherShape : otherHitbox){
				Area area = new Area(shape);
				AffineTransform shapeTrans = new AffineTransform();
				shapeTrans.translate(this.position.x, this.position.y);
				shapeTrans.rotate(Math.toRadians(this.getRotation()), pivotPoint.x, pivotPoint.y);
				shapeTrans.scale(this.scaleX, this.scaleY);
				area.transform(shapeTrans);
				Area otherArea = new Area(otherShape);
				AffineTransform otherTrans = new AffineTransform();
				otherTrans.translate(other.getPosition().x, other.getPosition().y);
				otherTrans.rotate(Math.toRadians(other.getRotation()), other.getPivotPoint().x, other.getPivotPoint().y);
				otherTrans.scale(other.getScaleX(), other.getScaleY());
				otherArea.transform(otherTrans);
				area.intersect(otherArea);
				if(!area.isEmpty()){
					return true;
				}
			}
		}
		return false;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getId() {
		return id;
	}

	public void setPosition(Point pos) { this.position = pos; }

	public Point getPosition() {
		return position;
	}

	public void setPivotPoint(Point piv) { this.pivotPoint = piv; }

	public Point getPivotPoint() {
		return pivotPoint;
	}

	public void setRotation(double rot) { this.rotation = rot; }

	public double getRotation() { return rotation; }

	public void setVisibility(boolean vis) {
		if(visibilityLag == 0){
			this.visibility = vis;
			visibilityLag += 20;
		}
	}

	public boolean getVisibility() { return visibility; }

	public void setAlpha(float a) { this.alpha = a; }

	public float getAlpha() { return alpha; }

	public void setOldAlpha(float a) { this.oldAlpha = a; }

	public float getOldAlpha(float a) { return oldAlpha; }

	public void setScaleX(double s) { this.scaleX = s; }

	public void setScaleY(double s) { this.scaleY = s; }

	public double getScaleX() { return scaleX; }

	public double getScaleY() { return scaleY; }

	public void setParent(DisplayObjectContainer parent) {
		this.parent = parent;
	}

	public DisplayObjectContainer getParent() {
		return parent;
	}

	/**
	 * Returns the unscaled width and height of this display object
	 * */
	public int getUnscaledWidth() {
		if(displayImage == null) return 0;
		return displayImage.getWidth();
	}

	public int getUnscaledHeight() {
		if(displayImage == null) return 0;
		return displayImage.getHeight();
	}

	public BufferedImage getDisplayImage() {
		return this.displayImage;
	}

	protected void setImage(String imageName) {
		if (imageName == null) {
			return;
		}
		displayImage = readImage(imageName);
		if (displayImage == null) {
			System.err.println("[DisplayObject.setImage] ERROR: " + imageName + " does not exist!");
		}
	}


	/**
	 * Helper function that simply reads an image from the given image name
	 * (looks in resources\\) and returns the bufferedimage for that filename
	 * */
	public BufferedImage readImage(String imageName) {
		BufferedImage image = null;
		try {
			String file = ("resources" + File.separator + imageName);
			image = ImageIO.read(new File(file));
		} catch (IOException e) {
			System.out.println("[Error in DisplayObject.java:readImage] Could not read image " + imageName);
			e.printStackTrace();
		}
		return image;
	}

	public void setImage(BufferedImage image) {
		if(image == null) return;
		displayImage = image;
	}


	/**
	 * Invoked on every frame before drawing. Used to update this display
	 * objects state before the draw occurs. Should be overridden if necessary
	 * to update objects appropriately.
	 * */
	protected void update(ArrayList<Integer> pressedKeys) {

	}

	/**
	 * Draws this image. This should be overloaded if a display object should
	 * draw to the screen differently. This method is automatically invoked on
	 * every frame.
	 * */
	public void draw(Graphics g) {
		if(visibilityLag != 0){
			visibilityLag -= 1;
		}
		if ((displayImage != null) && (getVisibility())) {
			
			/*
			 * Get the graphics and apply this objects transformations
			 * (rotation, etc.)
			 */
			Graphics2D g2d = (Graphics2D) g;
			applyTransformations(g2d);

			/* Actually draw the image, perform the pivot point translation here */
			g2d.drawImage(displayImage, 0, 0,
					(int) (getUnscaledWidth()),
					(int) (getUnscaledHeight()), null);


			/*
			 * undo the transformations so this doesn't affect other display
			 * objects
			 */
			reverseTransformations(g2d);
		}
	}

	/**
	 * Applies transformations for this display object to the given graphics
	 * object
	 * */
	protected void applyTransformations(Graphics2D g2d) {
		g2d.translate(this.position.x, this.position.y);
		g2d.rotate(Math.toRadians(this.getRotation()), pivotPoint.x, pivotPoint.y);
		g2d.scale(this.scaleX, this.scaleY);
		float curAlpha;
		this.oldAlpha = curAlpha = ((AlphaComposite)
				g2d.getComposite()).getAlpha();
		g2d.setComposite(AlphaComposite.getInstance(3, curAlpha *
				this.alpha));
	}

	/**
	 * Reverses transformations for this display object to the given graphics
	 * object
	 * */
	protected void reverseTransformations(Graphics2D g2d) {
		g2d.setComposite(AlphaComposite.getInstance(3, this.oldAlpha));
		g2d.scale((1.0 / this.scaleX), (1.0 / this.scaleY));
		g2d.rotate(-Math.toRadians(this.getRotation()), pivotPoint.x, pivotPoint.y);
		g2d.translate(-this.position.x, -this.position.y);
	}

	/* Given a point in the local coordinate system, return its corresponding point in the global
	coordinate system */
	public Point localToGlobal(Point p){
		Point localOrigin = getLocalOrigin();
		return new Point(p.x + localOrigin.x, p.y + localOrigin.y);
	}

	/* Given a point in the global coordinate system, return its corresponding point in the DisplayObject’s
	own coordinate system */
	public Point globalToLocal(Point p){
		Point localOrigin = getLocalOrigin();
		return new Point(p.x - localOrigin.x, p.y - localOrigin.y);
	}

	/* Helper function that returns the position of the local origin in the global coordinate system */
	protected Point getLocalOrigin(){
		if (parent != null){
			int newX = position.x + parent.getLocalOrigin().x;
			int newY = position.y + parent.getLocalOrigin().y;
			return new Point(newX, newY);
		} else{
			return position;
		}
	}
}
